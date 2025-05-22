#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
  printf("Hello from Parent\n");
  pid_t pid = fork();
  if (pid == 0) {
    printf("Hello from Child1\n");
    pid_t pid2 = fork();
    if (pid2 == 0) {
      printf("Hello from Child2\n");
      exit(EXIT_SUCCESS);
    } else if (pid2 > 0) {
      waitpid(pid2, NULL, 0);
    } else {
      perror("fork");
      exit(EXIT_FAILURE);
    }
    exit(EXIT_SUCCESS);
  } else if (pid > 0) {
    waitpid(pid, NULL, 0);
  } else {
    perror("fork");
    exit(EXIT_FAILURE);
  }

  return EXIT_SUCCESS;
}