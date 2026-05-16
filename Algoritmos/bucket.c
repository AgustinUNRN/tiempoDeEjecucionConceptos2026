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

static void insertion_sort_int(int *a, size_t n) {
    for (size_t i = 1; i < n; ++i) {
        int key = a[i]; ssize_t j = i - 1;
        while (j >= 0 && a[j] > key) { a[j+1] = a[j]; j--; }
        a[j+1] = key;
    }
}

static void bucket_sort(int *a, size_t n) {
    if (n == 0) return;
    int min = a[0], max = a[0];
    for (size_t i = 1; i < n; ++i) { if (a[i] < min) min = a[i]; if (a[i] > max) max = a[i]; }
    long range = (long)max - (long)min + 1;
    size_t bucketsCount = (size_t) (range < 1 ? 1 : (range < (long)n ? range : n));
    if (bucketsCount == 0) bucketsCount = 1;
    
    int **bucks = calloc(bucketsCount, sizeof(int*));
    size_t *sizes = calloc(bucketsCount, sizeof(size_t));
    size_t *caps = calloc(bucketsCount, sizeof(size_t));
    
    for (size_t i = 0; i < bucketsCount; ++i) { caps[i]=4; bucks[i]=malloc(caps[i]*sizeof(int)); }
    for (size_t i = 0; i < n; ++i) {
        size_t idx = (range == 1) ? 0 : (size_t)(((long)(a[i] - min) * (bucketsCount - 1)) / ( (range-1)>0 ? (range-1) : 1 ));
        if (sizes[idx] >= caps[idx]) { caps[idx]*=2; bucks[idx]=realloc(bucks[idx], caps[idx]*sizeof(int)); }
        bucks[idx][sizes[idx]++] = a[i];
    }
    size_t pos = 0;
    for (size_t i = 0; i < bucketsCount; ++i) {
        if (sizes[i] > 1) insertion_sort_int(bucks[i], sizes[i]);
        for (size_t j = 0; j < sizes[i]; ++j) a[pos++] = bucks[i][j];
        free(bucks[i]);
    }
    free(bucks); free(sizes); free(caps);
}

int main(int argc, char **argv) {
    if (argc < 2) return 1;
    size_t n;
    int *a = read_values_file(argv[1], &n);
    if (!a) return 2;
    
    long s = now_ms(); 
    bucket_sort(a, n); 
    long e = now_ms();
    long elapsed = e - s;
    free(a);
    
    char fname[256];
    snprintf(fname, sizeof(fname), "Reportes/bucket_c_%zu.txt", n);
    FILE *out = fopen(fname, "w");
    if (out) {
        fprintf(out, "Algoritmo: bucket\nLenguaje: c\nTamaño del archivo: %zu\nTiempo (ms): %ld\n", n, elapsed);
        fclose(out);
    }
    return 0;
}
