#include <stdio.h>

void swap(int *a, int *b) {
  int tmp = *a;
  *a = *b;
  *b = tmp;
}
int main() {
  int x, y;
  scanf("%d", &x);
  scanf("%d", &y);
  swap(&x, &y);
  printf("%d %d", x, y);
}