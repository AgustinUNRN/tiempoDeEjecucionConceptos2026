#!/bin/bash

# Asegurarse de que la carpeta Reportes existe
mkdir -p Reportes

# Menú para el Lenguaje
echo "Seleccione el lenguaje a ejecutar:"
echo "1) C"
echo "2) Java"
echo "3) Prolog"
echo "4) Todos"
read -p "Opción (1-4): " opt_lang

# Menú para el Algoritmo
echo ""
echo "Seleccione el algoritmo a procesar:"
echo "1) Bucket Sort"
echo "2) Radix Sort"
echo "3) Ambos"
read -p "Opción (1-3): " opt_algo

# Mapeo de selecciones
langs=()
if [ "$opt_lang" == "1" ]; then langs=("c"); fi
if [ "$opt_lang" == "2" ]; then langs=("java"); fi
if [ "$opt_lang" == "3" ]; then langs=("prolog"); fi
if [ "$opt_lang" == "4" ]; then langs=("c" "java" "prolog"); fi

algos=()
if [ "$opt_algo" == "1" ]; then algos=("bucket"); fi
if [ "$opt_algo" == "2" ]; then algos=("radix"); fi
if [ "$opt_algo" == "3" ]; then algos=("bucket" "radix"); fi

echo ""
echo "Iniciando benchmarks..."
echo "------------------------------------------------"

# Procesar todos los archivos CSV en el directorio ArreglosCSV
for csv in ArreglosCSV/*.csv; do
    # Validar que existan archivos csv
    if [ ! -f "$csv" ]; then
        echo "No se encontraron archivos .csv en la carpeta ArreglosCSV/"
        exit 1
    fi

    echo "Procesando archivo: $csv"

    for lang in "${langs[@]}"; do
        for algo in "${algos[@]}"; do
            
            echo " -> Ejecutando $algo en $lang..."

            case $lang in
                "c")
                    ./Algoritmos/$algo "$csv"
                    ;;
                "java")
                    # Java asume que el nombre de la clase comienza con mayúscula
                    if [ "$algo" == "bucket" ]; then
                        className="Bucket"
                    else
                        className="Radix"
                    fi
                    java -cp Algoritmos "$className" "$csv"
                    ;;
                "prolog")
                    swipl -q -t halt -s Algoritmos/${algo}.pl -- "$csv"
                    ;;
            esac
        done
    done
done

echo "------------------------------------------------"
echo "Procesamiento finalizado. Revisa la carpeta Reportes/."
