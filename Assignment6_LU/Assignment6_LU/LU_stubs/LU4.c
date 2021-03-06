#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <mkl.h>
#include <solvers.h>
//#include <mkl_blas.h>
//#include <blas.h>

void lu4_(double *B, int *pldb, int *pm, int *pn, int *ipiv, int *perrflag)
{

//===================================================================================
//
// LU factorization with partial pivoting on an m x n matrix B. This version should
// be based on matrix-vector products, and calls BLAS-2 (BLAS level 2) routines.
// The parameter small below determines when partial pivoting has failed from the
// diagonal element B(k,k) being too small to safely divide by. When that happens
// errflag is set to k and LU4 bails out. The array B can be rectangular (viz.,
// m /= n). Beware: this assumes that the indexing of the matrix B starts from
// 1, not 0. Otherwise a failure on the first step is indistinguishable from a
// no-error condition.
//
// B  is an array of doubles containing the matrix B in column-major order. It
//    is (part of) an array of declared leading dimension ldb in the calling
//    function. 
//   m is the number of rows in B 
//   n is the number of columns in B 
// ipiv is an array of length at least m which contains the pivot indices
// errflag is what would normally be returned by a function in C. Values:
// errflag = 0: success
//         < 0: if errflag = -k, the k-th argument had an illegal value
//         > 0: if errflag =  k, B(k,k) is too small to rely upon and the 
//              factorization probably failed.
//
// The BLAS requires each vector argument also has an "increment" giving how far
// apart consecutive entries of the vector are in memory. E.g., if a matrix H is
// stored in the upper 128 x 128 part of an array declared as G[128][256] in
// row-major order, consecutive entries in a row of G have an increment of 1.
// Accessing consecutive entries in a column of G will have an increment of 256.
//
// Similarly with column major ordering, if a matrix H stored in the first 128x128
// entries of an array declared as G(256,128), then accessing elements along a
// row of G have increment = 256, and elements along a column have increment = 1.
//
//===================================================================================

    // Value to use to bail out because pivot is too small
    double small = ((double) 1000.0)*2.216e-16;

    // To avoid messing with stars and ampersands, make local variables
    int lead_db     = *pldb;
    // m is no_of_rows
    // n is no_of_cols

    

    int no_of_cols = *pn;
    int no_of_rows = *pm;

    double ONE   =  1.0;
    double ZERO  =  0.0;
    double MONE  = -1.0;

    

    // Because quantities like m-k cannot be passed by address to the BLAS, use
    // some temporary variables, e.g., nrows = ldb-j and then pass in &nrows

// variable declaration

    int nrows, ncols, p,i,j,k,l,x,y,incx,incy,nelements;
    
    		
    char trans;
    
    double MAX = -999999; // This is to find the maximum elements so that it can be swapped with the pivot
    
    double diag_el = 0;
    
    double *temp= (double*)malloc(sizeof(double)*no_of_rows*no_of_cols);
    


//Check for incorrect parameters passed to this function
    if(B == NULL)
    {
	*perrflag = -1;
	 printf("\n Matrix does not exists!");
	 return;
    }

 
    if(pn == NULL)
    {
        *perrflag = -3;
	 printf("\n Number of columns is null!");
	return;
    }


    if(pm == NULL)
    {
         *perrflag = -2;
	  printf("\n Number of rows is null!");
          return;
    }


    if(pldb == NULL)
    {
	*perrflag = -4;
	 printf("\n Leading Dimension of array is null!");
	return;
    }
	
    if(ipiv == NULL)
    {
        *perrflag = -5;
	printf("\n The array of pivot indices is null!");
	return;
    }


	//printmatrix(B,no_of_rows,no_of_cols);

	
    	for(k=1;k<=no_of_cols-1;k++)
    	{
		if (k>1)
		{	// We are checking this condition because we want the pivot element for this position but not vectors x and y  
        		x = (k-1)*lead_db;		//starting address of vector x
			y = (k-1)*lead_db+(k-1);	//starting address of vector y
			incx = 1;
			incy = 1;
			nrows = no_of_rows-k+1;
			ncols = k-1;
			trans='N'; 
			dgemv(&trans,&nrows,&ncols,&MONE,(B+k-1),&lead_db,B+x,&incx,&ONE,B+y,&incy);
     		}
	
	// Find the maximum element from the coloumn in order to enable partial pivoting
    		
		for(l=0;l<no_of_rows*no_of_cols;l++)
		temp[l]=B[l];
     		temp = temp + (k-1)*no_of_cols;

	
	//puts("After copying values of B into b_dupl");
    		for(i=k;i<no_of_rows;i++)
    		{
    			if(temp[i-1]>MAX)
    			{
      				MAX = temp[i-1];
      				j = i;
    			}
    		}
    			
			p = j;

    			ipiv[k] = p;

    			temp=B;

		

	
    		if(k!= p)
    		{            
			
			
          		
			dswap( &no_of_cols, B+(k-1), &lead_db, B+(p-1), &lead_db);
    		
		}
    		if(k > 1)
        	{	
	    		incx = lead_db;
	    		incy = lead_db;
	    		trans = 'T';
            		nrows = k-1;
            		ncols = no_of_cols-k;
            		x = k-1;
            		y = (k*lead_db)+(k-1);
            		dgemv(&trans, &nrows, &ncols, &MONE, (B+k*lead_db), &lead_db, (B+x), &incx, &ONE, (B+y), &incy);
		}

	

			nelements = no_of_cols-k;    		
			incx = 1;

			//check if the diagonal element is too small

		if(B[(k-1)*lead_db + (k-1)]!=0)
		{
			diag_el = (double)1/B[(k-1)*lead_db + (k-1)];
		}
		else
		{
			*perrflag = k;
			return;
		}

		x = (k-1)*lead_db + (k+1-1); 
		dscal(&nelements, &diag_el , (B+x), &incx);
  	}


			//Second call to dgemv
		incx=1;
		incy=1;
		x=(no_of_cols-1)*lead_db;
		nrows=no_of_rows-no_of_cols+1;
		ncols=no_of_cols-1;
		y=(no_of_cols-1)+(no_of_cols-1)*lead_db;
		trans='N';


		dgemv(&trans, &nrows, &ncols, &MONE, (B+lead_db-1), &lead_db, (B+x), &incx, &ONE, (B+y), &incy);

			//This comes to picture when the number of rows and no of coloumns are not the same		

		if(no_of_rows > no_of_cols)
		{
			nelements = no_of_rows-no_of_cols;
			incx=1;
			if(B[lead_db*(no_of_cols-1)+(no_of_cols-1)]!=0)
			diag_el= (double) 1/B[lead_db*(no_of_cols-1)+(no_of_cols-1)];
			else
			{
				*perrflag=k;
				return;
			}
			x = (no_of_cols+1-1)+lead_db*(no_of_cols-1);
			dscal(&nelements,&diag_el,(B+x),&incx);
		}

	
}



/*printmatrix(double *B,int no_of_rows,int no_of_cols)
{
	
	int i,j;
	printf("\n In Function PrintMatrix\n");	
		
	for(i=0;i<no_of_rows;i++)
	{
		for(j=0;j<no_of_cols;j++)
		printf("%lf\t",*(B+j*no_of_rows+i));

		printf("\n");
	}
}*/
