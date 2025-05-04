#include <stdio.h>
#include <stdlib.h>

int main() {
    int n, x;
    scanf("%d", &n);
    int *array = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        scanf("%d", &x);
        array[i] = x;
    }
    for (int i = n - 1; i >= 0; i--) {
        printf("%d ", array[i]);
    }
    free(array);
    return 0;
}