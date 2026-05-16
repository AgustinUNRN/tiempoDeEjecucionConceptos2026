import java.nio.file.*;
import java.io.*;

public class Radix {
  static void radixSort(int[] a){
    int n = a.length; 
    if(n == 0) return;
    int max = a[0];
    for(int v : a){ if(v > max) max = v; }
    
    int[] aux = new int[n];
    for(int exp = 1; max / exp > 0; exp *= 10){
      int[] count = new int[10];
      for(int i=0; i<n; i++) count[(a[i]/exp)%10]++;
      for(int i=1; i<10; i++) count[i] += count[i-1];
      for(int i=n-1; i>=0; i--){
        int d = (a[i]/exp)%10;
        aux[--count[d]] = a[i];
      }
      System.arraycopy(aux, 0, a, 0, n);
    }
  }

  static int[] parseLine(String line) {
    if(line.startsWith("\"") && line.endsWith("\"")) line = line.substring(1,line.length()-1);
    String[] toks = line.split(",");
    int[] a = new int[toks.length];
    for(int i=0;i<toks.length;i++) a[i]=Integer.parseInt(toks[i].trim());
    return a;
  }

  public static void main(String[] args) throws Exception {
    if(args.length < 1) System.exit(1);
    int[] a = parseLine(Files.readAllLines(Paths.get(args[0])).get(0).trim());
    int n = a.length;
    
    long s = System.nanoTime(); 
    radixSort(a); 
    long e = System.nanoTime();
    long elapsed = Math.round((e - s) / 1_000_000.0);

    String outName = String.format("Reportes/radix_java_%d.txt", n);
    try(PrintWriter out = new PrintWriter(new FileWriter(outName))){
      out.printf("Algoritmo: radix%nLenguaje: java%nTamaño del archivo: %d%nTiempo (ms): %d%n", n, elapsed);
    }
  }
}
