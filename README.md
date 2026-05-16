# Benchmark de Algoritmos de Ordenamiento

Este proyecto implementa y compara el rendimiento de **Bucket Sort** y **Radix Sort** en tres lenguajes:

- **C**
- **Java**
- **Prolog**

El objetivo es ejecutar ambos algoritmos sobre los mismos conjuntos de datos, medir sus tiempos de ejecución y generar reportes comparativos entre lenguajes y tamaños de entrada.

## Objetivo

Analizar el comportamiento de dos algoritmos de ordenamiento utilizando una misma base de datos de entrada en distintos lenguajes, para realizar una comparación justa de rendimiento.

## Estructura del proyecto

```text
.
├── Algoritmos
│   ├── bucket
│   ├── bucket.c
│   ├── Bucket.class
│   ├── Bucket.java
│   ├── bucket.pl
│   ├── radix
│   ├── radix.c
│   ├── Radix.class
│   ├── Radix.java
│   └── radix.pl
├── ArreglosCSV
│   ├── arrays_100.csv
│   ├── arrays_500.csv
│   ├── arrays_1000.csv
│   ├── arrays_5000.csv
│   ├── arrays_10000.csv
│   ├── arrays_50000.csv
│   ├── arrays_100000.csv
│   ├── arrays_500000.csv
│   └── arrays_1000000.csv
├── Cuadros
│   ├── cuadro_comparativo_bucket.csv
│   └── cuadro_comparativo_radix.csv
├── Reportes
│   ├── bucket_c_100.txt
│   ├── bucket_java_100.txt
│   ├── bucket_prolog_100.txt
│   ├── ...
│   ├── radix_c_1000000.txt
│   ├── radix_java_1000000.txt
│   └── radix_prolog_1000000.txt
├── generar_cuadros.py
├── generate_many_arrays.py
├── run.sh
└── README.md
```

## Descripción de carpetas y archivos

### `Algoritmos/`
Contiene las implementaciones de los algoritmos en los distintos lenguajes.

- `bucket.c` y `radix.c`: versiones en C.
- `Bucket.java` y `Radix.java`: versiones en Java.
- `bucket.pl` y `radix.pl`: versiones en Prolog.
- `bucket` y `radix`: ejecutables compilados de C.
- `Bucket.class` y `Radix.class`: clases compiladas de Java.

### `ArreglosCSV/`
Contiene los archivos de entrada usados en las pruebas. Cada archivo representa un arreglo de números enteros separados por comas.

Ejemplos:
- `arrays_100.csv`
- `arrays_1000.csv`
- `arrays_1000000.csv`

### `Reportes/`
Guarda los archivos `.txt` generados luego de cada ejecución del benchmark.

El nombre de cada reporte sigue esta estructura:

```text
algoritmo_lenguaje_tamano.txt
```

Ejemplos:

```text
bucket_c_5000.txt
radix_java_100000.txt
bucket_prolog_1000000.txt
```

### `Cuadros/`
Contiene los archivos `.csv` comparativos generados por `generar_cuadros.py`.

Archivos esperados:
- `cuadro_comparativo_bucket.csv`
- `cuadro_comparativo_radix.csv`

### `generate_many_arrays.py`
Genera múltiples archivos `.csv` con distintos tamaños de entrada para realizar las pruebas.

### `generar_cuadros.py`
Procesa los reportes generados dentro de `Reportes/` y guarda los cuadros comparativos en la carpeta `Cuadros/`.

### `run.sh`
Script principal que automatiza la compilación y ejecución de los benchmarks.

## Requisitos

Para ejecutar el proyecto en Linux, necesitás tener instalado:

- `gcc`
- `java` / `javac`
- `swipl`
- `python3`
- `bash`

En Debian o Ubuntu:

```bash
sudo apt update
sudo apt install build-essential default-jdk swi-prolog python3
```

## Flujo de trabajo

### 1. Generar arreglos de prueba

Si querés crear nuevamente los conjuntos de datos:

```bash
python3 generate_many_arrays.py
```

Esto genera archivos `.csv` dentro de `ArreglosCSV/` con distintos tamaños de entrada.

### 2. Dar permisos al script principal

```bash
chmod +x run.sh
```

### 3. Ejecutar las pruebas

```bash
./run.sh
```

El script permite seleccionar:

- el lenguaje
- el algoritmo
- o ejecutar todas las combinaciones disponibles

Durante la ejecución, se toman los archivos de `ArreglosCSV/`, se compilan los programas necesarios y se guardan los tiempos medidos en `Reportes/`.

### 4. Generar cuadros comparativos

Una vez creados los reportes:

```bash
python3 generar_cuadros.py
```

Este script analiza los archivos de `Reportes/` y genera:

- un cuadro comparativo para **Bucket Sort**
- un cuadro comparativo para **Radix Sort**
- los archivos dentro de `Cuadros/`:
  - `cuadro_comparativo_bucket.csv`
  - `cuadro_comparativo_radix.csv`

## Formato de entrada

Los archivos `.csv` deben contener números enteros positivos separados por comas.

Ejemplo:

```csv
5,8,1,10,3,7
```

## Resultado esperado

El proyecto permite obtener mediciones comparables entre implementaciones de un mismo algoritmo en diferentes lenguajes, y luego consolidarlas para analizarlas o graficarlas.

## Propósito académico

Este trabajo fue realizado con fines académicos para estudiar diferencias de rendimiento entre lenguajes de programación y algoritmos de ordenamiento, utilizando el mismo conjunto de datos como entrada en todos los casos.
