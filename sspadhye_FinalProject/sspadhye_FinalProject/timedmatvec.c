#include <stdlib.h>
#include <stdio.h>
double elapsedtime(void);

void timedmatvec_( int *errorflag,
                  int n,
                  int nnz,
                  int *rows,
                  int *cols,
                  double *vals,
                  int whichone,
                  double *x,
                  double *y,
                  double *timetaken)
{
    //------------------------------------------------------------------------------
    //
    // Perform and time the sparse matrix*vector product y = A*x, where 
    //      n = order of the matrix A
    //      nnz = number of nonzeros in the matrix A
    //      x and y are dense vectors stored in 1D arrays
    //      timetaken = time in seconds for a single matrix-vector product
    //      whichone = 1 if data structure is COO
    //                 2 if data structure is CSR
    //      cols  = array of length nnz with col indices of nonzeros in A
    //      vals  = array of length nnz with nonzero values in A
    //      rows  = array of length nnz for COO, with row indices of nonzeros in A
    //            = array of length n+1 for CSR, giving 1-based indexes of
    //              where each row begins in the arrays cols and vals.
    //
    // All indices are 1-based, and should not be shifted in a preprocessing
    //      or postprocessing phase.
    //
    // errorflag is interpreted as
    //      errflag = -k, k-th argument is invalid on entry
    //      errflag =  0, everything is OK
    //      errflag =  k, something went wrong
    //      where k is a positive integer
    //
    // All arrays are already allocated on entry. Notice that n, nnz, and whichone
    // are passed in by value, not address. So a Fortran caller needs to specify
    // that calling convention for those arguments.
    //
    //------------------------------------------------------------------------------

    int k, i;
    double t,tstart1,tstart2;
    
    *errorflag = 0;
    *timetaken = -17.0;
    
   
    //error checking : n cannot be negative    
	    
    if(n < 0)
    {
	printf("\n Error -1: The order of the matrix cannot be negative\n");
	*errorflag = -1;	
	exit(0);
    }

    //error checking : nnz cannot be greater than n
    if(nzperrow > n)
    {
	printf("\n Error -2: nzperrow cannot be grater than n\n");
	*errorflag = -2;	
	exit(0);
    }

    if(nmin < 0 || nmax < 0)
    {
	printf("\n Error -3: Either nmin or nmax is negative\n");
	*errorflag = -3;	
	exit(0);
    }
  
    tstart1 = elapsedtime(); // take the initial time
    //if whichone = 1 then then perform Sparse matrix - vector multiplication using COO data structure 
    if(1 == whichone)
    {
		 
		for(k=0;k<nnz;k++)
		{
			*(y + rows[k]-1) = *(y + rows[k]-1) + vals[k] * (*(x + cols[k]-1));	
		}
	}
	else
	{
		//if whichone = 1 then then perform Sparse matrix - vector multiplication using CSR data structure 
		for(i=0;i<n;i++)
		{
			for(k=(rows[i]-1);k<(rows[i+1]-1);k++)
			{
				
				*(y+i) = *(y+i) + vals[k] * (*(x + cols[k]-1));
				
			}
		}				

	}
		
		*timetaken = elapsedtime() - tstart1; //Capture the difference between the start date and end date
	return;

}




	
		





	
