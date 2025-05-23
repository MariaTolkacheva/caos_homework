#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  if (argc < 4) {
    perror("Wrong number of args");
    exit(EXIT_FAILURE);
  }

  char *command = argv[3];
  const char *input_file = argv[1];
  const char *output_file = argv[2];

  pid_t pid = fork();
  if (pid < 0) {
    perror("forking failed");
    exit(EXIT_FAILURE);
  }
  if (pid == 0) {
    int fd2 = open(input_file, O_RDONLY);
    if (fd2 < 0) {
      perror("open input file difficulties");
      exit(EXIT_FAILURE);
    }

    if (dup2(fd2, STDIN_FILENO) < 0) {
      perror("dup2 stdin failed");
      close(fd2);
      exit(EXIT_FAILURE);
    }
    close(fd2);

    int fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) {
      perror("open out file difficulties");
      exit(EXIT_FAILURE);
    }

    if (dup2(fd, STDOUT_FILENO) < 0) {
      perror("dup2");
      exit(EXIT_FAILURE);
    }
    close(fd);
    char **args = malloc(argc * sizeof(char *));
    for (int i = 3; i < argc; i++) {
      args[i - 3] = argv[i];
    }
    args[argc - 3] = NULL;

    execvp(command, args);

    free(args);
    perror("execvp got here smth is wrong");
    exit(EXIT_FAILURE);
  } else {
    int status;
    if (waitpid(pid, &status, 0) == -1) {
      perror("waitpid failed");
      exit(EXIT_FAILURE);
    }
    printf("received %d", status);
    if (WIFEXITED(status)) {
      return WEXITSTATUS(status);
    }
    return EXIT_FAILURE;
  }
}