#!/usr/bin/env python3
import os
import glob
import re

def parse_reports():
    data = {'bucket': {}, 'radix': {}}
    languages = set()
    sizes = {'bucket': set(), 'radix': set()}

    # Buscar todos los archivos .txt en la carpeta Reportes
    report_files = glob.glob(os.path.join('Reportes', '*.txt'))
    
    if not report_files:
        print("No se encontraron archivos en la carpeta 'Reportes/'.")
        print("Asegúrate de ejecutar primero tus benchmarks para generar los datos.")
        return None, None, None, None

    for file_path in report_files:
        algo, lang, size, time_ms = None, None, None, None
        
        # Intentar parsear el contenido del archivo
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
                algo_match = re.search(r'Algoritmo:\s*(\w+)', content, re.IGNORECASE)
                lang_match = re.search(r'Lenguaje:\s*(\w+)', content, re.IGNORECASE)
                size_match = re.search(r'(?:Tamaño del archivo|Cantidad de datos):\s*([\d,]+)', content, re.IGNORECASE)
                time_match = re.search(r'Tiempo\s*\(ms\):\s*([\d\.]+)', content, re.IGNORECASE)
                
                if algo_match: algo = algo_match.group(1).lower()
                if lang_match: lang = lang_match.group(1).lower()
                if size_match: size = int(size_match.group(1).replace(',', ''))
                if time_match: time_ms = float(time_match.group(1))
        except Exception:
            pass

        # Si el contenido no se pudo parsear completamente, intentar deducir por el nombre del archivo
        if not (algo and lang and size is not None and time_ms is not None):
            basename = os.path.basename(file_path)
            # Formato esperado: algoritmo_lenguaje_tamaño.txt
            match = re.match(r'(\w+)_(\w+)_(\d+)\.txt', basename)
            if match:
                algo = match.group(1).lower()
                lang = match.group(2).lower()
                size = int(match.group(3))
                # Si no pudimos leer el tiempo, no podemos agregar el registro
                if time_ms is None:
                    continue

        if algo in data and lang and size is not None and time_ms is not None:
            languages.add(lang)
            sizes[algo].add(size)
            if size not in data[algo]:
                data[algo][size] = {}
            data[algo][size][lang] = time_ms

    return data, sorted(list(languages)), sorted(list(sizes['bucket'])), sorted(list(sizes['radix']))

def print_table(algo_name, data, sorted_langs, sorted_sizes):
    if not sorted_sizes:
        print(f"\n--- No hay datos para el algoritmo {algo_name.upper()} ---")
        return

    print(f"\n=== CUADRO COMPARATIVO: {algo_name.upper()} SORT ===")
    
    # Encabezado para consola (Markdown)
    headers = ["Tamaño"] + [lang.upper() for lang in sorted_langs]
    header_line = " | ".join(f"{h:<12}" for h in headers)
    separator = "-|-".join("-" * 12 for _ in headers)
    
    print(header_line)
    print(separator)
    
    for size in sorted_sizes:
        row = [f"{size:,}"]
        for lang in sorted_langs:
            val = data[algo_name].get(size, {}).get(lang, "N/A")
            if isinstance(val, (int, float)):
                row.append(f"{val:,.2f}" if val % 1 != 0 else f"{int(val)}")
            else:
                row.append(str(val))
        print(" | ".join(f"{item:<12}" for item in row))
        
    # Crear archivo CSV separado por tabulaciones (fácil de copiar y pegar en Google Sheets)
    csv_filename = f"cuadro_comparativo_{algo_name}.csv"
    with open(csv_filename, 'w', encoding='utf-8') as f:
        # Escribir encabezados
        f.write("Tamaño\t" + "\t".join(lang.upper() for lang in sorted_langs) + "\n")
        for size in sorted_sizes:
            row_vals = [str(size)]
            for lang in sorted_langs:
                val = data[algo_name].get(size, {}).get(lang, "")
                row_vals.append(str(val))
            f.write("\t".join(row_vals) + "\n")
    print(f" -> Guardado archivo listo para Google Sheets: {csv_filename}")

def main():
    data, languages, bucket_sizes, radix_sizes = parse_reports()
    if not data:
        return
        
    print_table('bucket', data, languages, bucket_sizes)
    print_table('radix', data, languages, radix_sizes)
    print("\n[CONSEJO] Los archivos .csv generados usan tabulaciones. Puedes abrirlos o arrastrarlos a Google Sheets directamente, o abrir el archivo, copiar todo (Ctrl+A -> Ctrl+C) y pegarlo en una celda de Sheets.")

if __name__ == '__main__':
    main()
