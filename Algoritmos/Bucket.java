import java.nio.file.*;
import java.io.*;
import java.util.*;

public class Bucket {
  static void bucketSort(int[] a){
    int n = a.length;
    if(n==0) return;
    int min=a[0], max=a[0];
    for(int v:a){ if(v<min) min=v; if(v>max) max=v; }
    int range = max - min + 1;
    int bucketsCount = Math.max(1, Math.min(n, range));
    @SuppressWarnings("unchecked")
    ArrayList<Integer>[] buckets = new ArrayList[bucketsCount];
    for(int i=0;i<bucketsCount;i++) buckets[i]=new ArrayList<>();
    for(int v:a){
      int idx = (range==1) ? 0 : (int)((long)(v - min) * (bucketsCount - 1) / Math.max(1, range - 1));
      buckets[idx].add(v);
    }
    int pos=0;
    for(ArrayList<Integer> b: buckets){
      for(int i=1;i<b.size();i++){
        int key=b.get(i), j=i-1;
        while(j>=0 && b.get(j)>key){ b.set(j+1,b.get(j)); j--; }
        b.set(j+1,key);
      }
      for(int val: b) a[pos++]=val;
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
    bucketSort(a); 
    long e = System.nanoTime();
    long elapsed = Math.round((e - s) / 1_000_000.0);

    String outName = String.format("Reportes/bucket_java_%d.txt", n);
    try(PrintWriter out = new PrintWriter(new FileWriter(outName))){
      out.printf("Algoritmo: bucket%nLenguaje: java%nTamaño del archivo: %d%nTiempo (ms): %d%n", n, elapsed);
    }
  }
}
