
Python


readme_content = """# Benchmark de Algoritmos de Ordenamiento (Bucket & Radix Sort)
## Comparativa de Rendimiento Multilenguaje (C, Java, Prolog)

Este proyecto es un entorno de pruebas automatizado (*benchmarking*) diseñado para medir, comparar y analizar el tiempo de ejecución de dos algoritmos de ordenamiento clave: **Bucket Sort** y **Radix Sort (LSD Base 10)**. La evaluación se realiza de forma cruzada sobre tres paradigmas de programación distintos utilizando los lenguajes **C** (Imperativo/Compilado), **Java** (Orientado a Objetos/Híbrido JIT) y **Prolog** (Lógico/Declarativo).

Para garantizar el rigor científico de las mediciones, los programas consumen exactamente los mismos conjuntos de datos aleatorios a partir de archivos en formato `.csv` y ejecutan los algoritmos **una sola vez ("en frío")**. Esto permite capturar el comportamiento de ejecución bruto y el *overhead* inicial de memoria/entorno antes de que entren en juego optimizaciones en tiempo de ejecución (como la compilación JIT de la JVM).

---

## 1. Estructura del Proyecto

El proyecto sigue una arquitectura limpia y segmentada, organizada de la siguiente manera:



Resultado de código
README.md generated successfully.

```text
.
├── Algoritmos/
│   ├── bucket.c          # Código fuente de Bucket Sort en C
│   ├── radix.c           # Código fuente de Radix Sort en C
│   ├── Bucket.java       # Código fuente de Bucket Sort en Java
│   ├── Radix.java        # Código fuente de Radix Sort en Java
│   ├── bucket.pl         # Código fuente de Bucket Sort en Prolog
│   └── radix.pl          # Código fuente de Radix Sort en Prolog
├── ArreglosCSV/
│   ├── datos_1000.csv    # Set de datos de ejemplo (1,000 enteros positivos)
│   ├── datos_50000.csv   # Set de datos de ejemplo (50,000 enteros positivos)
│   └── ...               # Otros archivos de datos que desees agregar
├── Reportes/
│   └── (Vacío)           # Aquí se guardarán automáticamente los .txt individuales
├── run.sh                # Script Bash interactivo para compilar y ejecutar pruebas
└── generar_cuadros.py    # Script Python que consolida reportes en tablas para Google Sheets


Descripción de Directorios:
Algoritmos/: Contiene las implementaciones optimizadas de los dos métodos de ordenamiento en los tres lenguajes seleccionados.
ArreglosCSV/: Carpeta destinada a almacenar los vectores o listas de números enteros positivos separados por comas que se usarán como entrada uniforme.
Reportes/: Repositorio automatizado de salida. Cada ejecución generará un archivo plano .txt con la nomenclatura estándar: algoritmo_lenguaje_tamañoDelArchivo.txt.
2. Requisitos Previos
Antes de ejecutar los entornos de pruebas, asegúrate de tener instalados los siguientes compiladores e intérpretes en tu distribución Linux (ej. Ubuntu):

Bash


# Actualizar repositorios
sudo apt update

# Compilador de C (GCC)
sudo apt install build-essential

# Kit de Desarrollo de Java (OpenJDK)
sudo apt install default-jdk

# Intérprete de SWI-Prolog
sudo apt install swi-prolog

# Entorno de Python 3 (para consolidar resultados)
sudo apt install python3


3. Instrucciones de Uso
Todo el flujo de trabajo está automatizado mediante dos fases sencillas: Ejecución automatizada y Consolidación de datos.
Paso 1: Ejecución del Benchmark (run.sh)
El archivo run.sh es un script interactivo en Bash que se encarga de la lógica de compilación y orquestación.
Concede permisos de ejecución al script desde la raíz del proyecto:
Bash
chmod +x run.sh


Ejecuta el orquestador:
Bash
./run.sh


El script te solicitará mediante un menú en la terminal que selecciones:
El Lenguaje: Puedes elegir uno en específico (C, Java o Prolog) o seleccionar la opción 4) Todos.
El Algoritmo: Puedes seleccionar Bucket Sort, Radix Sort o 3) Ambos.
El script detectará automáticamente todos los archivos .csv presentes dentro de la carpeta ArreglosCSV/, compilará el código de C y Java en caliente, e irá procesando uno a uno los archivos, guardando los tiempos de respuesta calculados en milisegundos dentro de la carpeta Reportes/.
Paso 2: Generación de Cuadros Comparativos (generar_cuadros.py)
Una vez finalizadas las ejecuciones, tendrás decenas de archivos de reporte individuales en la carpeta Reportes/. Para evitar unificarlos a mano, se utiliza el script inteligente de Python.
Ejecuta el consolidador desde la raíz del proyecto:
Bash
python3 generar_cuadros.py


El script procesará recursivamente la carpeta Reportes/ usando expresiones regulares, imprimiendo dos tablas estructuradas en texto plano directamente en tu terminal (una para Bucket Sort y otra para Radix Sort).
Adicionalmente, el script creará dos archivos de datos en tu directorio raíz:
cuadro_comparativo_bucket.csv
cuadro_comparativo_radix.csv
¿Cómo llevar los datos a Google Sheets?
Los archivos .csv generados utilizan un delimitador por Tabulaciones (\t). Esto significa que puedes abrirlos con cualquier editor de texto plano (como Gedit, VS Code, Nano o cat), seleccionar todo el texto (Ctrl+A), copiarlo (Ctrl+C) y pegarlo directamente (Ctrl+V) sobre la celda A1 de una hoja en blanco de Google Sheets. Los datos se distribuirán automáticamente en filas y columnas perfectas de manera nativa.
💡 Consejo de Visualización Histográfica: Debido a la enorme diferencia de rendimiento entre lenguajes (C procesa millones de datos en el tiempo en que Prolog procesa miles), al graficar tus curvas de dispersión, dale doble clic al Eje Vertical (Y) en el editor de gráficos de Google Sheets y activa la casilla Escala Logarítmica. Esto evitará que las líneas más rápidas queden aplastadas contra el suelo del gráfico.
4. Prompts Utilizados para el Desarrollo del Proyecto
Este proyecto fue diseñado de manera iterativa junto con un modelo de Inteligencia Artificial (Gemini). A continuación se exponen los prompts secuenciales que dieron origen a toda la lógica y estructura:
Prompt 1: Consultoría Inicial de Datos y Gráficos
"tengo que hacer un grafico que compare el tiempo de ejecucion de cada algoritmo en cada lenguaje en base al tamaño del arreglo y el tiempo que tarda en ejecutarse. la idea es comparar los lenguajes, como armo la tabla en google sheets"
Resultado: Se definió la estructura matricial óptima para Sheets (Filas = Tamaños de matriz $N$, Columnas = Lenguajes) y se recomendó separar el experimento en dos gráficos de tipo dispersión.
Prompt 2: Diagnóstico de Escalas Críticas y Solución Estética
"hice esto pero los graficos se ven medios feos [Datos crudos con desfases gigantescos de magnitudes entre C y Prolog desde 0ms hasta 1,414,566ms]"
Resultado: Se diagnosticó el problema del crecimiento no uniforme en el eje X y las diferencias de órdenes de magnitud en el eje Y. Se introdujo el concepto matemático y práctico de la Escala Logarítmica en Google Sheets para separar visualmente las curvas de C, Java y Prolog.
Prompt 3: Refactorización de Arquitectura y Scripting Linux
"vamos a hacer esto, te paso mis 6 codigos: los 6 hacen lo mismo, tienen 2 algoritmos de ordenamiento (bucket y radix) por lenguaje. Consumen los arreglos de un csv para garantizar que usan los mismos arreglos o listas. Miden el tiempo que les lleva ordenar los arreglos o listas. Generan un reporte indicando la cantidad de datos procesados (el tamaño del csv), el tiempo en milisegundos que les tomó ordenarlo. Cada reporte va en una carpeta llamada reportes y la nomenclatura del reporte es algoritmo_lenguaje_tamañoDelArchivo.txt. En los ejemplos se procesan 10 veces el mismo algoritmo para calcular el promedio, esto no es necesario porque con cada ejecucion van optimizando la memoria asique necesito que solo se procese una sola vez. Los csv son siempre enteros positivos. La estructura del folder es la siguiente... [Estructura Tree]. Necesito que me proporciones los comandos en bash linux para compilar cada archivo y un script de linux que me pida por consola cual lenguaje quiero si uno o todos y que algoritmo voy a procesar si uno en especifico o ambos. Los scripts se ejecutan desde la carpeta padre."
Resultado: Se reescribieron los 6 códigos fuentes eliminando bucles repetitivos y adaptándolos a rutas relativas fijas, se proveyeron las flags óptimas de compilación de GCC (-O2) y se construyó el menú de automatización interactiva run.sh.
Prompt 4: Automatización de Análisis Final (Consolidador)
"por ultimo necesito un script que lea todos los reportes y haga 2 cuadros comparativos, uno para bucket que tenga como filas los tamaños de los arreglos y como columnas los lenguajes de programacion y se rellenen los datos con los tiempos y otro cuadro con el algoritmo radix"
Resultado: Se diseñó el script en Python puro generar_cuadros.py encargado de parsear, tabular y exportar los resultados directamente a formato portapapeles para Google Sheets, completando el ecosistema del proyecto.
"""
with open('README.md', 'w', encoding='utf-8') as f:
f.write(readme_content)
print("README.md generated successfully.")



Tu archivo `README.md` ha sido generado con éxito.
[file-tag: code-generated-file-0-1778959385382395314]

Este archivo contiene toda la documentación estructurada de manera técnica y profesional utilizando sintaxis Markdown. Al descargar este archivo y colocarlo en la raíz de tu proyecto, plataformas como GitHub, GitLab o tu propio entorno local renderizarán automáticamente las tablas, bloques de comandos y el árbol jerárquico.

### Resumen del contenido incluido en el `README.md`:

1. **Estructura Arquitectónica:** Se visualiza el árbol de directorios (`Algoritmos/`, `ArreglosCSV/`, `Reportes/`) detallando qué función cumple cada parte para evitar desorden.
2. **Requisitos de Entorno:** Incluye los comandos directos de `apt install` para instalar de golpe `gcc`, el JDK de `java`, el intérprete `swipl` de Prolog y `python3`.
3. **Guía Práctica de Ejecución (`run.sh`):** Paso a paso explicando cómo darle permisos de ejecución con `chmod +x` y cómo interactuar con el menú nativo para lanzar pruebas en frío.
4. **Guía de Consolidación (`generar_cuadros.py`):** Explica la automatización mediante el script de Python, la lectura inteligente por regex y expone el **"truco del Tabulador"** para pasar los datos resultantes a Google Sheets haciendo un simple `Ctrl+C` $\rightarrow$ `Ctrl+V` sin pasar por asistentes de importación.
5. **Bitácora de Prompts:** Una sección dedicada que recopila la traza histórica y la evolución de los comandos que le diste a la IA (desde la consulta inicial de cómo graficar escalas dispares, pasando por la queja estética que derivó en la recomendación de escala logarítmica, hasta la consolidación en Bash y Python). 