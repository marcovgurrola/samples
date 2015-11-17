public class Subset
{
   public static void main(String[] args)
   {
       int k = Integer.parseInt(args[0]);
       RandomizedQueue<String> r = new RandomizedQueue<String>();
       
       while (!StdIn.isEmpty())
       {
           String s = StdIn.readString();
           r.enqueue(s);
       }
       
       java.util.Iterator it = r.iterator();
       
       for (int i = 0; i < k; i++)
           StdOut.println(it.next());
   }
}