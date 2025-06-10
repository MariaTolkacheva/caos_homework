#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct {
  const char *name;
  int number;
} SignalMap;

SignalMap signal_map[] = {
    {"HUP", SIGHUP},   {"INT", SIGINT},   {"QUIT", SIGQUIT}, {"ILL", SIGILL},
    {"ABRT", SIGABRT}, {"FPE", SIGFPE},   {"KILL", SIGKILL}, {"SEGV", SIGSEGV},
    {"PIPE", SIGPIPE}, {"ALRM", SIGALRM}, {"TERM", SIGTERM}, {"USR1", SIGUSR1},
    {"USR2", SIGUSR2}, {"CHLD", SIGCHLD}, {"CONT", SIGCONT}, {"STOP", SIGSTOP},
    {"TSTP", SIGTSTP}, {"TTIN", SIGTTIN}, {"TTOU", SIGTTOU}};

int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Wrong args count");
    return EXIT_FAILURE;
  }

  int pid = atoi(argv[1]);
  const char *sig_name = argv[2];
  int sig = -1;

  for (size_t i = 0; i < sizeof(signal_map) / sizeof(signal_map[0]); ++i) {
    if (strcmp(sig_name, signal_map[i].name) == 0) {
      sig = signal_map[i].number;
      break;
    }
  }

  if (sig == -1) {
    fprintf(stderr, "No such signal\n");
    return EXIT_FAILURE;
  }

  if (kill(pid, sig) == -1) {
    perror("Failed to send signal\n");
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
