subroutine swaps( n, A, lda, k1, k2, ipiv, incpiv )
!==========================================================================
!
! This routine is copied from the LINPACK project, with minor reformatting
! performed for F90+ readability.
!
!  Perform a series of row interchanges corresponding to pivoting in LU
!  factorization on the array A. This works on rows k1 through k2, with
!  a row swap for each of those rows.
!
!  Arguments
!  =========
!
!  n       (input) integer
!          The number of columns of the matrix A.
!
!  a       (input/output) double precision array, dimension (lda,n)
!          On entry, the matrix of column dimension n to which the row
!          interchanges will be applied.
!          On exit, the permuted matrix.
!
!  lda     (input) integer
!          The leading dimension of the array A.
!
!  k1      (input) integer
!          The first element of ipiv for which a row interchange will
!          be done.
!
!  k2      (input) integer
!          The last element of ipiv for which a row interchange will
!          be done.
!
!  ipiv    (input) integer array, dimension (m*abs(incpiv))
!          The vector of pivot indices.  Only the elements in positions
!          k1 through k2 of ipiv are accessed.
!          ipiv(k) = l implies rows k and l are to be interchanged.
!
!  incpiv    (input) integer
!          The increment between successive values of ipiv.  If incpiv
!          is negative, the pivots are applied in reverse order.
!
!==========================================================================
      implicit none
      integer :: incpiv, k1, k2, lda, n
      integer ::  ipiv(n)
      double precision :: A(lda,n)
      integer ::  i, ip, ix

      if (incpiv  ==  0) return
      if (incpiv  >  0) then
         ix = k1
      else
         ix = 1 + ( 1-k2 )*incpiv
      end if
      if (incpiv  ==  1) then
         do i = k1, k2
            ip = ipiv( i )
            if (ip  /=  i) call dswap(n, A(i,1), lda, A(ip,1), lda)
         end do 
      else if (incpiv  >  1) then
         do i = k1, k2
            ip = ipiv( ix )
            if (ip  /=  i) call dswap(n, A(i,1), lda, A(ip,1), lda)
            ix = ix + incpiv
         end do 
      else if (incpiv  <  0) then
         do i = k2, k1, -1
            ip = ipiv( ix )
            if(ip  /=  i) call dswap(n, A(i,1), lda, A(ip,1), lda )
            ix = ix + incpiv
         end do 
      end if

      return

end subroutine swaps
