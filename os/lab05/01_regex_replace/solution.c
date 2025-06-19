#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { INITIAL_BUFFER_SIZE = 2048, SP = 2 };

int main(int argc, char *argv[]) {
  if (argc != 4) {
    fprintf(stderr, "wrong number of args");
    return EXIT_FAILURE;
  }

  const char *pattern = argv[1];
  const char *text = argv[2];
  const char *replacement = argv[3];

  regex_t regex;
  if (regcomp(&regex, pattern, REG_EXTENDED)) {
    return EXIT_FAILURE;
  }

  size_t buffer_size = INITIAL_BUFFER_SIZE;
  char *result = (char *)malloc(buffer_size);
  if (!result) {
    perror("malloc failed");
    regfree(&regex);
    return EXIT_FAILURE;
  }

  result[0] = '\0';
  size_t result_len = 0;
  regmatch_t match;
  const char *p = text;

  while (regexec(&regex, p, 1, &match, 0) == 0) {
    size_t prefix_len = match.rm_so;
    size_t replacement_len = strlen(replacement);
    size_t needed_size = result_len + prefix_len + replacement_len + 1;

    if (needed_size >= buffer_size) {
      while (buffer_size <= needed_size) {
        buffer_size *= SP;
      }
      char *new_result = (char *)realloc(result, buffer_size);
      if (!new_result) {
        perror("realloc failed");
        free(result);
        regfree(&regex);
        return EXIT_FAILURE;
      }
      result = new_result;
    }

    strncpy(result + result_len, p, prefix_len);
    result_len += prefix_len;
    strcpy(result + result_len, replacement);
    result_len += replacement_len;
    p += match.rm_eo;
  }

  size_t remaining = strlen(p);
  size_t needed_size = result_len + remaining + 1;
  if (needed_size >= buffer_size) {
    while (buffer_size <= needed_size) {
      buffer_size *= SP;
    }
    char *new_result = (char *)realloc(result, buffer_size);
    if (!new_result) {
      perror("realloc failed (unlucky)");
      free(result);
      regfree(&regex);
      return EXIT_FAILURE;
    }
    result = new_result;
  }
  strcat(result + result_len, p);
  printf("%s\n", result);
  free(result);
  regfree(&regex);
  return 0;
}
