/*---------------------------------------------------------------- 
 *  Author:        Marco Gurrola  
 *  Written:       Feb 14th 2014 
 *  Last updated:  Feb 16th 2014 
 * 
 *  Compilation:   javac Percolation.java 
 *  Execution:     from PercolationStats or 
 *                 instantianting: Percolation p = new Percolation(N) 
 *   
 *  A percolation model using an N-by-N grid of sites in order to determine 
 *  if any Top site(x,y coordinate on the grid) has a full path (not diagonally) 
 *  with a bottom site, then we can say that the system percolates 
 *----------------------------------------------------------------*/

public class Percolation 
{ 
    private WeightedQuickUnionUF wquUF;    // performs a Weighted Quick Union
    private WeightedQuickUnionUF wquUFull; // for isFull() check, no backwash
    private int simpleDim;                 // represents grid's height or width 
    private int sitesCount;                // number of sites on the grid 
    private boolean[] sites;               // True for Open 
    private boolean percolated;            // once percolated always 
    private int openedCount;               // number of opened sites on the grid
    private int virtTopId;                 // virtual site for is Full and Perc
    private int virtBotId;                 // virtual site for is Full and Perc
     
    // create N-by-N grid, with all sites blocked. 
    public Percolation(int N) 
    {
        if (N <= 0)
            throw new IllegalArgumentException("N must be greater than 0");
        //showMessage("P N = " + N);
        
        simpleDim = N; 
        sitesCount = N * N; 
        openedCount = 0;
        virtTopId = sitesCount + 1;
        virtBotId = sitesCount + 2;

        sites = new boolean[sitesCount];
        wquUF = new WeightedQuickUnionUF(sitesCount + 2);
        wquUFull = new WeightedQuickUnionUF(sitesCount + 1);
    } 
     
    // does the system percolates? By having a full path (not diagonally) 
    // from top to bottom the system percolates 
    public boolean percolates() 
    {         
        if (!percolated && openedCount >= simpleDim)
        {
            if (joined(virtTopId, virtBotId))
            {
                percolated = true;
                return percolated;
            }
        }
        return percolated; 
    }

    // is site (row i, column j) full? 
    // A full site is an open site that can be connected to an open site in the 
    // top row via a chain of neighboring (left, right, up, down) open sites 
    public boolean isFull(int i, int j) 
    {   
        if (i > 0 && i <= simpleDim && j > 0 && j <= simpleDim) 
        {
            // Full
            if (fakeJoined(virtTopId, getIdFromGrid(i, j))) 
                return true;
        } 
        else 
            throwEx("i/j out of range: " + i + ", " + j); 
         
        return false; 
    }
     
    // is site (row i, column j) open? 
    public boolean isOpen(int i, int j) 
    { 
        if ((i < 1 || i > simpleDim) || (j < 1 || j > simpleDim)) 
            throwEx("i/j out of range: " + i + ", " + j);
        
        return sites[getIdFromGrid(i, j) - 1];
    }
    
    // open site (row i, column j) if it is not already open 
    public void open(int i, int j) 
    { 
        if ((i < 1 || i > simpleDim) || (j < 1 || j > simpleDim)) 
            throwEx("i/j out of range: " + i + ", " + j);
         
        int openedSiteId = getIdFromGrid(i, j);
        
        // Only opens closed sites
        if (!sites[openedSiteId - 1])
        {                
            sites[openedSiteId - 1] = true;
            openedCount++;
            
            if (i == 1)
            {
                join(virtTopId, openedSiteId);
                fakeJoin(virtTopId, openedSiteId);
                
                if (simpleDim == 1)
                    join(virtBotId, openedSiteId);
            }
            else if (i == simpleDim)
                join(virtBotId, openedSiteId);
            
            gatherNeighboors(i, j, openedSiteId);
        }
    }
         
    // Makes the weighted quick union (connect) for contiguous opened sites 
    private void gatherNeighboors(int i, int j, int guestId) 
    {        
        if (j > 1) // left neighboor, row i must be greater than 0
            gatherNeighboor(guestId, getIdFromGrid(i, j - 1));
        if (j < simpleDim)
            gatherNeighboor(guestId, getIdFromGrid(i, j + 1));
        if (i > 1) // top neighboor, column j must be lesser than N
            gatherNeighboor(guestId, getIdFromGrid(i - 1, j));
        if (i < simpleDim)
            gatherNeighboor(guestId, getIdFromGrid(i + 1, j));
    }
    
    private void gatherNeighboor(int guestId, int neighboorId) 
    {
        if (sites[neighboorId - 1])
        {
            join(guestId, neighboorId);
            fakeJoin(guestId, neighboorId);
        }
    }
    
    // weighted quick union connect 
    private void join(int p, int q) 
    {
        wquUF.union(p - 1, q - 1);
    }
    
    private void fakeJoin(int p, int q) 
    {
        wquUFull.union(p - 1, q - 1);
    }
    
    // weighted quick union connected 
    private boolean joined(int p, int q) 
    {
        return wquUF.connected(p - 1, q - 1);
    }
    
    private boolean fakeJoined(int p, int q) 
    {
        return wquUFull.connected(p - 1, q - 1);
    }  
     
    // Obtains the site id given its coordinates (row, column) 
    // for further use on a 1D array (WeightedQuickUnionUF) 
    private int getIdFromGrid(int r, int c) 
    { 
        // id = (yN - N + x) // 1 based id
        return r*simpleDim - simpleDim + c; 
    } 
     
    // prints a standard message 
    private void showMessage(String message) 
    { 
        StdOut.println(message); 
    } 
     
    // throws a exception when bounds out of range 
    private void throwEx(String message) 
    { 
        throw new IndexOutOfBoundsException(message); 
    } 
}