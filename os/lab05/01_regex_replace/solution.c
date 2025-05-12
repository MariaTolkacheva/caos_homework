#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { INITIAL_BUFFER_SIZE = 2048, SP = 2 };

int main(int argc, char *argv[]) {

  const char *pattern = argv[1];
  const char *text = argv[2];
  const char *replacement = argv[3];

  regex_t regex;
  size_t buffer_size = INITIAL_BUFFER_SIZE;
  char *result = (char *)malloc(buffer_size);
  if (!result) {
    perror("malloc failed (unlucky)");
    regfree(&regex);
    return EXIT_FAILURE;
  }

  result[0] = '\0';
  size_t result_len = 0;
  regmatch_t match;

  const char *p = text;

  while (regexec(&regex, p, 1, &match, 0) == 0) {
    size_t prefix_len = match.rm_so;

    while (result_len + prefix_len + strlen(replacement) + 1 >= buffer_size) {
      buffer_size *= SP;
      result = (char *)realloc(result, buffer_size);
      if (!result) {
        perror("lloc failed (unlucky)");
        regfree(&regex);
        return EXIT_FAILURE;
      }
    }

    strncat(result + result_len, p, prefix_len);
    result_len += prefix_len;
    strcat(result + result_len, replacement);
    result_len += strlen(replacement);
    p += match.rm_eo;
  }

  //(МАША) добавь обработки
  size_t remaining = strlen(p);
  while (result_len + remaining + 1 >= buffer_size) {
    buffer_size *= SP;
    result = (char *)realloc(result, buffer_size);
    if (!result) {
      perror("lloc failed (unlucky)");
      regfree(&regex);
      return EXIT_FAILURE;
    }
  }
  strcat(result + result_len, p);
  printf("%s\n", result);
  free(result);
  regfree(&regex);
  return 0;
}
