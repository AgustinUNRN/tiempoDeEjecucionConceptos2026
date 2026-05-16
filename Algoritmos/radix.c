#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static long now_ms() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000L + ts.tv_nsec / 1000000L;
}

static int *read_values_file(const char *file, size_t *out_n) {
    FILE *f = fopen(file, "r");
    if (!f) return NULL;
    char *line = NULL; size_t len = 0;
    ssize_t r = getline(&line, &len, f);
    fclose(f);
    if (r <= 0) { free(line); return NULL; }
    while (r>0 && (line[r-1]=='\n' || line[r-1]=='\r')) { line[--r]='\0'; }
    char *s = line;
    while (*s == ' ' || *s == '\t') s++;
    if (s[0]=='"' && s[strlen(s)-1]=='"') { s[strlen(s)-1]='\0'; s++; }
    size_t count = 1;
    for (char *p = s; *p; ++p) if (*p==',') count++;
    int *arr = malloc(count * sizeof(int));
    if (!arr) { free(line); return NULL; }
    size_t idx = 0;
    char *tok = strtok(s, ",");
    while (tok && idx < count) {
        while (*tok==' ' || *tok=='\t') tok++;
        arr[idx++] = atoi(tok);
        tok = strtok(NULL, ",");
    }
    free(line); *out_n = idx; return arr;
}

static void radix_sort(int *a, size_t n) {
    if (n == 0) return;
    int max = a[0];
    for (size_t i = 1; i < n; ++i) { if (a[i] > max) max = a[i]; }
    
    int *aux = malloc(n * sizeof(int));
    for (int exp = 1; max / exp > 0; exp *= 10) {
        int count[10] = {0};
        for (size_t i = 0; i < n; ++i) count[(a[i]/exp)%10]++;
        for (int i = 1; i < 10; ++i) count[i] += count[i-1];
        for (ssize_t i = n-1; i >= 0; --i) {
            int d = (a[i] / exp) % 10;
            aux[--count[d]] = a[i];
        }
        memcpy(a, aux, n * sizeof(int));
    }
    free(aux);
}

int main(int argc, char **argv) {
    if (argc < 2) return 1;
    size_t n;
    int *a = read_values_file(argv[1], &n);
    if (!a) return 2;
    
    long s = now_ms(); 
    radix_sort(a, n); 
    long e = now_ms();
    long elapsed = e - s;
    free(a);
    
    char fname[256];
    snprintf(fname, sizeof(fname), "Reportes/radix_c_%zu.txt", n);
    FILE *out = fopen(fname, "w");
    if (out) {
        fprintf(out, "Algoritmo: radix\nLenguaje: c\nTamaño del archivo: %zu\nTiempo (ms): %ld\n", n, elapsed);
        fclose(out);
    }
    return 0;
}
