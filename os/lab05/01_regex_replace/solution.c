#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#define INITIAL_BUFFER_SIZE 1024

int main(int argc, char *argv[]) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <regex> <text> <replacement>\n", argv[0]);
        return 1;
    }

    const char *pattern = argv[1];
    const char *text = argv[2];
    const char *replacement = argv[3];

    regex_t regex;
    if (regcomp(&regex, pattern, REG_EXTENDED)) {
        fprintf(stderr, "Could not compile regex\n");
        return 1;
    }

    size_t buffer_size = INITIAL_BUFFER_SIZE;
    char *result = malloc(buffer_size);
    if (!result) {
        perror("malloc");
        regfree(&regex);
        return 1;
    }

    result[0] = '\0';
    size_t result_len = 0;

    const char *p = text;
    regmatch_t match;
    while (regexec(&regex, p, 1, &match, 0) == 0) {
        // Length of text before the match
        size_t prefix_len = match.rm_so;

        // Ensure enough space in the buffer
        while (result_len + prefix_len + strlen(replacement) + 1 >= buffer_size) {
            buffer_size *= 2;
            result = realloc(result, buffer_size);
            if (!result) {
                perror("realloc");
                regfree(&regex);
                return 1;
            }
        }

        // Copy text before the match
        strncat(result + result_len, p, prefix_len);
        result_len += prefix_len;

        // Copy replacement
        strcat(result + result_len, replacement);
        result_len += strlen(replacement);

        // Move pointer past the match
        p += match.rm_eo;
    }

    // Copy the rest of the text
    size_t remaining = strlen(p);
    while (result_len + remaining + 1 >= buffer_size) {
        buffer_size *= 2;
        result = realloc(result, buffer_size);
        if (!result) {
            perror("realloc");
            regfree(&regex);
            return 1;
        }
    }
    strcat(result + result_len, p);

    printf("%s\n", result);

    free(result);
    regfree(&regex);
    return 0;
}
