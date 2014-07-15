#include <solvers.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
// #include <mkl_blas.h>
#include "blas.h"
#include <mkl.h>

void lu8_(double *A, int *plda, int *pn, int *ipiv, int *perrflag, int *pnb)
{

//================================================================================
//
// Perform a BLAS-3 LU factorization of a square n x n matrix stored in the array
// A. As a 2D array, A is stored in column-major order with leading declared
// dimension lda. On exit, array A contains the L and U factors of the matrix A.
//
// LU8 computes the LU factorization of a general n-by-n matrix A using partial
// pivoting via row swaps. This implementation should use matrix-matrix products, a
// BLAS level 3 operation and hence able to get and maintain a high fraction of a
// machine's theoretical peak. The base version is the rank-1 update form, so the
// matrix-matrix products are of the form of rank-nb updates.
// 
// The parameter small below determines when partial pivoting has failed from the
// diagonal element A(k,k) being too small to safely divide by. When that happens
// errflag is set to k and LU8 returns.
//
//   A is an array of doubles containing the matrix A in column-major order.
//   m is the number of rows in A 
//   n is the number of columns in A 
// ipiv is an array of length at least n which contains the pivot indices
// errflag is what would normally be returned by a function in C. Values:
// errflag = 0: success
//         < 0: if errflag = -k, the k-th argument had an illegal value
//         > 0: if errflag =  k, A(k,k) is too small to rely upon and the 
//              factorization probably failed.
// nb is the blocksize to use. Using nb = n or nb > n will lead to a BLAS-2 solve
//  using LU4.
//
//===================================================================================

   
    // value to use to bail out because pivot is too small
    const double small = ((double) 1000.0)*2.216e-16;
    int lda     = *plda;
    int n       = *pn;
    int nb      = *pnb;
    int k;
    *perrflag = 0;

    
    char trans = 'N';
    int mat_B;
    int mat_C;
    int M,N,K;
    double alpha = -1;
    double beta = 1;
    int i,j;
	

if(nb<n)
{


    for(k=1;k<=n-nb;k=k+nb)
    {
        matrixB = (k-1)*lda;
        matrixC =  (k-1)*lda + k-1;
        //printf("%d\t%d\n",matrixB,matrixC);
        M = n - (k-1);
        N = nb;
        K = k - 1;
        dgemm(&trans,&trans,&M,&K,&N,&alpha,A+(k-1),&lda,A+mat_B,&lda,&beta,A+matrix_C,&lda);

        lu4_(A+mat_C, &lda, &M, &N, ipiv, perrflag);
	}

}

else
	lu4_(A, &lda, &nb, &nb, ipiv, perrflag);
}
