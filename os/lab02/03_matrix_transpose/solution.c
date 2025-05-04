/***
inputs two integer values N and M;
allocates a matrix of size N * M and fills it with values from standard input;
transposes the matrix;
prints the resulting matrix;
deallocate the matrices.
***/

#include <stdio.h>
#include <stdlib.h>


int main() {
    int n, m, x;
    scanf("%d", &n);
    scanf("%d", &m);
    int **array1 = malloc(n * sizeof(int *));
    for (int i = 0; i < n; i++) {
        array1[i] = malloc(m * sizeof(int));
    }
    int **array2 = malloc(m * sizeof(int *));
    for (int i = 0; i < m; i++) {
        array2[i] = malloc(n * sizeof(int));
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            scanf("%d", &x);
            array1[i][j] = x;
        }
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            array2[j][i] = array1[i][j];
        }
    }

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n - 1; j++) {
            printf("%d ", array2[i][j]);
        }
        printf("%d", array2[i][n-1]);
        printf("\n");
    }

    for (int i = 0; i < n; i++) {
        free(array1[i]);
    }

    free(array1);
    for (int i = 0; i < m; i++) {
        free(array2[i]);
    }
    free(array2);
}