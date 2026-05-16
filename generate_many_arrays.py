#!/usr/bin/env python3
# generate_many_arrays.py — crea files arrays_<n>.csv con solo los valores (una línea, separados por comas)
import random, os

SIZES = [100,500,1000,5000,10000,50000,100000,500000,1000000]
OUT_DIR = './ArreglosCSV'          # cambiar si quieres otro directorio
BASE_SEED = 12345

def gen_file(n, seed, out_dir=OUT_DIR):
    random.seed(seed)
    path = os.path.join(out_dir, f"arrays_{n}.csv")
    with open(path, 'w', newline='') as f:
        # escribir en streaming para no construir una cadena gigantesca en memoria
        for i in range(n):
            val = str(random.randint(0, 999999))
            if i == 0:
                f.write(val)
            else:
                f.write(',' + val)
    print(f"Generado: {path} (n={n}, seed={seed})")

if __name__ == '__main__':
    os.makedirs(OUT_DIR, exist_ok=True)
    for i, n in enumerate(SIZES, start=1):
        gen_file(n, BASE_SEED + i)
