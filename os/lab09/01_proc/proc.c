#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Wrong args count");
    return EXIT_FAILURE;
  }

  int timeout = atoi(argv[1]);

  int counter = 0;
  for (int i = 0;; i++) {
    sleep(timeout);

    pid_t pid = getpid();
    printf("%d: %d\n", pid, counter);
    fflush(stdout);

    counter++;
  }

  return EXIT_SUCCESS;
}
