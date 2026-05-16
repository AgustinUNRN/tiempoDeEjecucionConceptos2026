# Benchmark de Algoritmos de Ordenamiento

Este proyecto permite ejecutar y comparar pruebas de rendimiento de dos algoritmos de ordenamiento:

- **Bucket Sort**
- **Radix Sort**

Las implementaciones están desarrolladas en:

- **C**
- **Java**
- **Prolog**

El objetivo es medir tiempos de ejecución usando los mismos archivos de entrada en formato `.csv`, de manera que la comparación entre lenguajes y algoritmos sea consistente.

## Estructura del proyecto

```text
.
├── Algoritmos/
│   ├── bucket.c
│   ├── radix.c
│   ├── Bucket.java
│   ├── Radix.java
│   ├── bucket.pl
│   └── radix.pl
├── ArreglosCSV/
│   ├── datos_1000.csv
│   ├── datos_50000.csv
│   └── ...
├── Reportes/
├── run.sh
├── generar_cuadros.py
└── README.md
```

## ¿Qué hace el proyecto?

1. Toma archivos `.csv` con listas de números enteros.
2. Ejecuta los algoritmos seleccionados sobre esos datos.
3. Mide el tiempo de ejecución.
4. Guarda los resultados en archivos dentro de `Reportes/`.
5. Permite consolidar los resultados en cuadros comparativos.

## Requisitos

Para ejecutar el proyecto en Linux, necesitás tener instalado:

- `gcc`
- `java` / `javac`
- `swipl`
- `python3`
- `bash`

Ejemplo en Ubuntu/Debian:

```bash
sudo apt update
sudo apt install build-essential default-jdk swi-prolog python3
```

## Uso

### 1. Dar permisos al script principal

```bash
chmod +x run.sh
```

### 2. Ejecutar el benchmark

```bash
./run.sh
```

El script permite elegir:

- lenguaje
- algoritmo
- o ejecutar todas las combinaciones disponibles

Durante la ejecución, se procesan los archivos `.csv` de `ArreglosCSV/` y se generan reportes en la carpeta `Reportes/`.

## Generación de cuadros comparativos

Una vez generados los reportes, podés consolidarlos ejecutando:

```bash
python3 generar_cuadros.py
```

Este script procesa los archivos de `Reportes/` y genera cuadros comparativos para:

- Bucket Sort
- Radix Sort

Además, crea archivos `.csv` listos para usar en hojas de cálculo.

## Formato esperado de entrada

Los archivos dentro de `ArreglosCSV/` deben contener números enteros separados por comas.

Ejemplo:

```csv
5,8,1,10,3,7
```

## Salida

Los resultados de cada ejecución se guardan en la carpeta `Reportes/`.

El nombre de los archivos puede seguir una lógica similar a:

```text
algoritmo_lenguaje_tamano.txt
```

Por ejemplo:

```text
bucket_c_1000.txt
radix_java_50000.txt
```

## Propósito académico

Este proyecto fue desarrollado con fines académicos para analizar el comportamiento de distintos algoritmos de ordenamiento en diferentes lenguajes de programación, utilizando una misma base de datos de entrada para asegurar comparaciones justas.
