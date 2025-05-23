#include <errno.h>
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

  int fd[2];

  if (pipe(fd) == -1) {
    perror("Pipe creation failed");
    exit(EXIT_FAILURE);
  }

  char *com1 = argv[1];
  char *com2 = argv[2];

  pid_t pid1 = fork();
  if (pid1 < 0) {
    perror("forking 1 failed");
    exit(EXIT_FAILURE);
  }

  if (pid1 == 0) {
    // Child process
    close(fd[0]); // Close the read end of the pipe
    if (dup2(fd[1], STDOUT_FILENO) < 0) {
      perror("dup2 out failed");
      exit(EXIT_FAILURE);
    }
    close(fd[1]);
    char *args[] = {com1, NULL};
    execvp(com1, args);
    perror("execvp got here smth is wrong");
    exit(EXIT_FAILURE);
  } else {
    // Parent process
    pid_t pid2 = fork();
    if (pid2 < 0) {
      perror("forking 2 failed");
      exit(EXIT_FAILURE);
    }
    if (pid2 == 0) {
      // Child process
      //
      char **args2 = malloc(argc * sizeof(char *));
      for (int i = 2; i < argc; i++) {
        args2[i - 2] = argv[i];
      }
      args2[argc - 2] = NULL;

      //
      close(fd[1]); // Close the write end of the pipe
      if (dup2(fd[0], STDIN_FILENO) < 0) {
        perror("dup2 stdin failed");
        close(fd[0]);
        exit(EXIT_FAILURE);
      }
      close(fd[0]);
      execvp(com2, args2);

      free(args2);
      perror("execvp got here smth is wrong");
      exit(EXIT_FAILURE);
    } else {
      close(fd[0]);
      close(fd[1]);

      int status;
      int exit_status1 = -1;
      int exit_status2 = -1;

      while (1) {
        pid_t wpid = waitpid(-1, &status, 0);
        if (wpid == -1) {
          if (errno == ECHILD) {
            break; // Все дочерние процессы завершены
          } else {
            perror("waitpid failed");
            exit(EXIT_FAILURE);
          }
        }

        if (WIFEXITED(status)) {
          if (wpid == pid1) {
            exit_status1 = WEXITSTATUS(status);
          } else if (wpid == pid2) {
            exit_status2 = WEXITSTATUS(status);
          }
        }
      }

      printf("child %d exited with %d\n", pid1, exit_status1);
      printf("child %d exited with %d\n", pid2, exit_status2);

      if ((exit_status1 != 0) | (exit_status1 != 0)) {
        return EXIT_FAILURE;
      }
      return EXIT_SUCCESS;
    }
  }
}