/*----------------------------------------------------------------
 *  Author:        Marco Gurrola 
 *  Written:       Feb 14th 2014
 *  Last updated:  Feb 16th 2014
 *
 *  Compilation:   javac PercolationStats.java
 *  Execution:     java PercolationStats N T
 *  
 *  Test Percolation Thresholds, perform T independent computational experiments
 *  on an N-by-N grid to get statistics such as mean, standar deviation,
 *  confidence intervals
 *----------------------------------------------------------------*/
public class PercolationStats
{
    //private Stopwatch sw;          //  environment timer, used as cronometer
    private double[] percThresholds; //  stores the percolation thresholds 
    private int attempts;            //  equals to T, used to save object calls
    
    // perform T independent computational experiments on an N-by-N grid
    public PercolationStats(int N, int T)
    {
        if (T <= 0)
            throw new IllegalArgumentException("T must be greater than 0");

        percThresholds = new double[T];
        attempts = T;
        Percolation p;  //  object with the main methods for the percolation
        
        for (int a = 0; a < T; a++)
        {
            p = new Percolation(N);
            int openedSites = 0;
            int i = 0;
            int j = 0;
            int iterations = 0;
            //sw = new Stopwatch();
            
            while (!p.percolates()) 
            { 
                // Percolation requires random openings 
                StdRandom.setSeed(StdRandom.getSeed() + System.currentTimeMillis()); 
                i = StdRandom.uniform(1, N + 1); 
                j = StdRandom.uniform(1, N + 1);
                
                if (!p.isOpen(i, j))
                {
                    p.open(i, j);
                    openedSites++;
                }
                
                iterations++;
            }
            
            //StdOut.println("S " + sw.elapsedTime());
            percThresholds[a] = (double) (openedSites) / (double) (N*N);
            //showMessage("OK!; I = " + iterations); 
        }
        
        //StdOut.println("T: " + T);

        showMessage("mean                    = " + mean());
        showMessage("stddev                  = " + stddev());
        showMessage("95% confidence interval = " + confidenceLo() + ", "
           + confidenceHi());
    }
    
    // test client
    public static void main(String[] args)
    {
        int N = 0;  //  grid single dimension
        int T = 0;  //  percolation attempts
        
        if (args.length > 0)
        {
            N = Integer.parseInt(args[0]);
            T = Integer.parseInt(args[1]);
            
            //StdOut.println("PS start");
            new PercolationStats(N, T);
        }
    }
    
    // sample standard deviation of percolation threshold
    public double stddev()
    {
        // standard deviation is the root of the variance
        double stdDeviation = Math.sqrt(variance());
        return stdDeviation;
    }
    
    // sample variance of percolation threshold
    private double variance()
    {
        double meanR = mean();
        double quadSum = 0;
        
        for (double pt: percThresholds)
            quadSum += (meanR - pt) * (meanR - pt);
            
        return quadSum/attempts;
    }
    
    // sample mean of percolation threshold.
    public double mean() 
    {
        double summatory = 0;
        double meanR = 0;
        for (double pt : percThresholds)
            summatory += pt;
        
        meanR = summatory/attempts;
        return meanR;
    }
    
    // returns lower bound of the 95% confidence interval
    public double confidenceLo()
    {
        // confidence interval (low) = mean - (1.96*StandardDeviation)/T
        return mean() - getErrorMargin();
    }
    
    // returns upper bound of the 95% confidence interval
    public double confidenceHi()
    {
        return mean() + getErrorMargin();
    }
    
    // returns upper bound of the 95% confidence interval
    private double getErrorMargin()
    {
        return 1.96 * stddev() / Math.sqrt(percThresholds.length);
    }
    
    private void showMessage(String message)
    {
        StdOut.println(message);
        return;
    }
}