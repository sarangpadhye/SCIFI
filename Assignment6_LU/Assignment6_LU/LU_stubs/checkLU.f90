
function checkLU(m, n, A, lda, Afac, ldAfac, ipiv) result(resid)

!===================================================================================
!
! Verify a LU factorization with row pivoting, by reconstructing A. Multiply
! out P'*L*U, where P is the permutation matrix corresponding to the pivoting.
! Return the scaled 1-norm of the difference between the computed P'*L*U and
! the original A. The factored matrix is multiplied out in place.
!
! Afac   = input array containing the alleged LU factorization
! m,n    = number of rows, columns in factored matrix.
! A      = input array containing the original matrix A, column-major
! lda    = declared leading dimension of A
! ldafac = declared leading dimension of Afac 
! ipiv   = array containing permutation in form of 1-based pivot indices
! resid  = scaled 1-norm of LU - PA treated as a long vector. 
!           scaled by the matrix size (m*n) since larger arrays will 
!           tend to have more errors due to floating point arithmetic
!
!---------------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!--------------------------------
! Started: Thu 31 Oct 2013, 03:07 PM
! Last Modified: Mon 04 Nov 2013, 05:55 AM
!===================================================================================

    use kinds
    implicit none
    real(kind=real8), parameter :: ZERO = 0.0_real8, ONE = 1.0_real8

    integer(kind=integer4) :: lda, ldAfac, m, n
    integer(kind=integer4) :: ipiv(n), i, j, k

    real(kind=real8) :: resid, t
    real(kind=real8) :: A(lda, n), Afac(ldAfac, n)

    ! Needed BLAS routines 
    real(kind=real8), external :: ddot
    external dgemv, swaps, dscal, dtrmv

    if(m <= 0 .or. n <= 0) then
        resid = ZERO
        return
    end if


    !------------------------------------------------------------------------
    ! Compute the product L*U and overwrite Afac with the result. ONE column
    ! at a time of the product is found, starting with column n. That saves
    ! on space, but requires working backwards through the pivot sequence.
    !------------------------------------------------------------------------
    do k = n, 1, -1
        if (k > m) then
            call dtrmv('lower', 'no transpose', 'unit', m, Afac, ldAfac, Afac(1, k), 1)
        else

            ! Compute A(k+1:m,k), the subdiagonal of column k
            t = Afac(k, k)
            if (k+1 <= m) then
                call dscal(m-k, t, Afac(k+1, k), 1)
                call dgemv('no transpose', m-k, k-1, ONE,                &
                            Afac(k+1, 1), ldAfac, Afac(1, k), 1, ONE,    &
                            Afac(k+1, k), 1)
            end if
    
            ! Compute the k-th diagonal element
            Afac(k, k) = t + ddot(k-1, Afac(k, 1), ldAfac, Afac(1, k), 1)
    
            ! Get superdiagonal elements (1:k-1,k)
            call dtrmv('lower', 'no transpose', 'unit', k-1, Afac, ldAfac, Afac(1, k), 1)
        end if
    end do

    call swaps(n, Afac, ldAfac, 1, min(m,n), ipiv, -1)

    ! Compute the difference  L*U - P*A  and store in Afac
    resid = ZERO
    do j = 1, n
        do i = 1, m
            Afac(i,j) = Afac(i,j) - A(i,j)
            resid = resid + abs(Afac(i,j)) 
        end do
    end do

    ! Normalize the residual for the case of m, n large. This is to eliminate
    ! size effects that otherwise might make the error look artificially large
    resid = resid/(m*n)

    return

end function checkLU
