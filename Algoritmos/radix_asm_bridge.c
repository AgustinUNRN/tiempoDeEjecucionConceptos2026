// Guardar como: Algoritmos/radix_asm_bench.c
// Compilar: gcc -no-pie -O2 radix.o radix_asm_bench.c -o radix_asm_bench

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Declaramos la función externa en Assembler (definida en radix.asm)
extern void radix_sort(int *a, size_t n);

static long now_ms() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000L + ts.tv_nsec / 1000000L;
}

static int *read_values_file(const char *file, size_t *out_n) {
    FILE *f = fopen(file, "r");
    if (!f) { perror("fopen"); return NULL; }
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

static double mean_long(const long *vals, size_t n) {
    if (n == 0) return 0.0;
    double s = 0.0;
    for (size_t i = 0; i < n; ++i) s += vals[i];
    return s / n;
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "Uso: %s <input.csv>\n", argv[0]); return 1; }
    size_t n;
    int *base = read_values_file(argv[1], &n);
    if (!base) { fprintf(stderr, "Error leyendo archivo\n"); return 2; }
    
    const size_t runs = 10;
    long times[runs];

    for (size_t run = 0; run < runs; ++run) {
        int *a = malloc(n * sizeof(int));
        memcpy(a, base, n * sizeof(int));
        
        // Buscamos mínimos y máximos para el offset idéntico a radix_bench.c
        int min = a[0];
        for (size_t i = 1; i < n; ++i) { if (a[i] < min) min = a[i]; }
        int offset = (min < 0) ? -min : 0;
        if (offset) for (size_t i = 0; i < n; ++i) a[i] += offset;

        // Medimos la ejecución en Assembler
        long s = now_ms(); 
        radix_sort(a, n); 
        long e = now_ms();
        
        times[run] = e - s;
        free(a);
    }

    // Generamos el archivo con formato idéntico para el script unificador
    char fname[256];
    snprintf(fname, sizeof(fname), "results_%zu_asm_radix.txt", n);
    FILE *out = fopen(fname, "w");
    if (out) {
        fprintf(out, "Se generaron 10 ejecuciones por algoritmo y el tiempo promedio en milisegundos es:\n\n");
        fprintf(out, "Lenguaje: ASM\nCantidad de datos: %zu\n\n", n);
        fprintf(out, "Algoritmo: radix (ordenamiento radix, LSD base 10)\n");
        fprintf(out, "Tiempos (ms): [");
        for (size_t i = 0; i < runs; i++) { 
            if (i) fprintf(out, ", "); 
            fprintf(out, "%ld", times[i]); 
        }
        fprintf(out, "]\nPromedio (ms): %.2f\n", mean_long(times, runs));
        fclose(out);
        printf("Archivo generado: %s\n", fname);
    }
    
    free(base); 
    return 0;
}