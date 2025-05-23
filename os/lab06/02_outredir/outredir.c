#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  if (argc < 3) {
    perror("Wrong number of args");
    exit(EXIT_FAILURE);
  }

  char *command = argv[1];
  const char *output_file = argv[argc - 1];

  pid_t pid = fork();
  if (pid < 0) {
    perror("forking failed");
    exit(EXIT_FAILURE);
  }
  if (pid == 0) {
    int fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) {
      perror("file difficulties");
      exit(EXIT_FAILURE);
    }

    if (dup2(fd, STDOUT_FILENO) < 0) {
      perror("dup2");
      exit(EXIT_FAILURE);
    }
    close(fd);
    char **args = malloc(argc * sizeof(char *));
    for (int i = 1; i < argc - 1; i++) {
      args[i - 1] = argv[i];
    }
    args[argc - 2] = NULL;

    execvp(command, args);

    free(args);
    perror("execvp got here smth is wrong");
    exit(EXIT_FAILURE);
  } else {
    int status;
    waitpid(pid, &status, 0);
    if (WIFEXITED(status)) {
      return WEXITSTATUS(status);
    }
    return EXIT_FAILURE;
  }
}