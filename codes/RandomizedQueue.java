import java.util.Iterator;
import java.util.Arrays;
import java.util.NoSuchElementException;

public class RandomizedQueue<Item> implements Iterable<Item>
{
    private Object[] queue;
    private int n = 0;
    
    //construct an empty randomized queue
    public RandomizedQueue()
    { queue = new Object[]{null}; }
    
    //unit testing
    public static void main(String[] args)
    { }

    //is the queue Empty?
    public boolean isEmpty()
    { return n == 0; }
    
    //return the number of items on the queue
    public int size()
    { return n; }
    
    //add the item
    public void enqueue(Item item)
    {
        if (item == null) throw new NullPointerException();
        
        //doubles the array size when it is full
        if (n == queue.length) queue = Arrays.copyOf(queue, n * 2);
        queue[n++] = item;
    }
    
    //delete and return a random item
    public Item dequeue()
    {
        if (isEmpty()) throw new NoSuchElementException();
        
        //halves the array size when it is 1/4 full
        if (n == queue.length / 4) queue = Arrays.copyOf(queue, n * 2);
        
        int iPicked = getRandom(n);
        Item item = (Item) queue[iPicked];        
        queue[iPicked] = queue[--n];
        
        queue[n] = null;
        return item;
    }
    
    //return (but do not delete) a random item
    public Item sample()
    { 
        if (isEmpty()) throw new NoSuchElementException();
        return (Item) queue[getRandom(n)];
    }
    
    //return an independent iterator over items in random order
    public Iterator<Item> iterator()
    { return new RandomIterator<Item>(); }
       
    private int getRandom(int range)
    {
        StdRandom.setSeed(StdRandom.getSeed() + System.currentTimeMillis());
        return StdRandom.uniform(0, range);
    }
    
    private Object[] getQueue()
    { return Arrays.copyOfRange(queue, 0, n); }

    private class RandomIterator<Item> implements Iterator<Item>
    {
        private int size = 0;
        private Object[] itArray;
        private boolean initiated = false;
       
        public boolean hasNext()
        {
            if (!initiated)
            {
                initiated = true;
                itArray = getQueue();
                size = itArray.length;
            }
            if (size > 0) return true;
            return false;    
        }
       
        public Item next()
        {
            if (!hasNext()) throw new NoSuchElementException();

            int iPicked = getRandom(size);
            Item item = (Item) itArray[iPicked];           
            itArray[iPicked] = itArray[--size];           
            return item;
        }
       
        public void remove()
        { throw new UnsupportedOperationException(); }
    }    
}