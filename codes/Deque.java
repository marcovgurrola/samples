import java.util.Iterator;
import java.util.NoSuchElementException;

public class Deque<Item> implements Iterable<Item>
{
    private DoublyLinkedList l;
    
    public Deque()
    { l = new DoublyLinkedList(); }
    
    // unit testing
    public static void main(String[] args)
    { }
    
    // return an iterator over items in order from front to end
    public Iterator<Item> iterator()
    { return new DequeIterator<Item>(); }
    
    // is the deque empty?
    public boolean isEmpty()
    { return l.isEmpty(); }
   
    // return the number of items on the deque
    public int size()
    { return l.size(); }
    
    // insert the item at the front
   public void addFirst(Item item)
   { l.addAtFront(item); }
   
   // insert the item at the end
   public void addLast(Item item)
   { l.addAtRear(item); }
   
   // delete and return the item at the front
   public Item removeFirst()
   { return (Item) l.removeAtFront(); }
   
   // delete and return the item at the end
   public Item removeLast()
   { return (Item) l.removeAtRear(); }
   
   private class Node<Item>
   {
       private Item item;
       private Node<Item> prev;
       private Node<Item> next;
       public Node(Item value)
       { this.item = value; }
   }

   private class DoublyLinkedList<Item>
   {
       private Node<Item> rear;
       private Node<Item> front;
       private int n;
       
       // construct an empty deque
       public DoublyLinkedList()
       {
           rear = null;
           front = null;
       }
       
       public boolean isEmpty()
       { return n == 0; }
       
       public int size()
       { return n; }
       
       public void addAtFront(Item item)
       {
           if (item == null) throw new NullPointerException();
           Node<Item> nod = new Node<Item>(item);
           nod.next = null;
           if (isEmpty()) rear = nod;
           else
           {
               front.prev = nod;
               nod.next = front;
           }
           front = nod;
           n++;
       }
       
       public void addAtRear(Item item)
       {
           if (item == null) throw new NullPointerException();
           Node<Item> nod = new Node<Item>(item);
           nod.prev = null;
           if (isEmpty()) front = nod;
           else
           {
               rear.next = nod;
               nod.prev = rear;
           }
           rear = nod;
           n++;
       }
       
       public Item removeAtFront()
       {
           if (isEmpty()) throw new NoSuchElementException();
           Item itmResult = front.item;
           Node<Item> newFront = front.next;
           if (newFront == null) rear = null;
           else newFront.prev = null;
           front = newFront;
           n--;
           return itmResult;
       }
       
       public Item removeAtRear()
       {
           if (isEmpty()) throw new NoSuchElementException();
           Item itmResult = rear.item;
           Node<Item> newRear = rear.prev;
           if (newRear == null) front = null;
           else newRear.next = null;
           rear = newRear;
           n--;
           return itmResult;
       }     
   }
   
   private class DequeIterator<Item> implements Iterator<Item>
   {
       private boolean initiated = false;
       private Node nodIteration;
       
       public boolean hasNext()
       {
           if (!initiated)
           {
               nodIteration = l.front;
               initiated = true;
           }
           return nodIteration != null;
       }
       
       public Item next()
       {
           if (!hasNext()) throw new NoSuchElementException();
           
           Node nodResult =  nodIteration;
           if (nodIteration != null) nodIteration = nodIteration.next;
           
           return (Item) nodResult.item;
       }
       
       public void remove()
       { throw new UnsupportedOperationException(); }
   }
}