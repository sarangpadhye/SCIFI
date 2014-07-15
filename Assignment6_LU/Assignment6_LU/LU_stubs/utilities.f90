!===============================================================================
!
! File (not a module!) with the kitchen sink stuff for LU, viz., 
!
!   subroutine setA(A, b, lda, n): 
!       sets values for matrix A, vector b
!
!   integer function nrpts(total_flops, n):
!       how many repetitions of LU are needed to assure that at least 
!       total_flops are done. Overcomes any clock resolution issues.
!
!   double precision function flops(n): compute number of flops LU takes for a
!       n x n matrix. A floating point value because n^3 may overflow measly 
!       little 32-bit integers
!
!===============================================================================

subroutine setA(A, b, lda, n)
!-----------------------------------------------------------------------------
! Set up random or other values into the 2D array A and b = right hand side
! vector. Pseudo-random is enough, but for fuller testing make sure not all
! entries are positive. This routine also has the ability to make A diagonally
! dominant (and not require pivoting). The intrinsic subroutine random_number()
! is uniform on [0,1]. 
!-----------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!----------------------
! Started: Thu 31 Oct 2013, 03:00 PM
! Last Modified: Fri 01 Nov 2013, 09:14 AM
!-----------------------------------------------------------------------------

    use kinds, only: integer4, real8
    implicit none

    integer(kind=integer4):: i, j, n, lda
    real(kind=real8)      :: A(lda,n), b(n)
    real(kind=real8), external:: random_normal
    real(kind=real8), parameter:: pi = 3.141592653589793238462643_real8 

    ! diagonal dominance avoids need for pivoting.
    logical, parameter :: diagonally_dominant = .true.

    call random_number(A)
    ! Shift the uniform distribution interval from [0,1] to [-1,1]
    A = 2.0_real8*A - 1.0_real8
    ! Not as vital that the RHS vector b has a different distribution
    call random_number(b)

    if (diagonally_dominant) then
        do i = 1, n
         A(i,i) = 2.0_real8*n
        end do
    end if

    return
end subroutine setA

!======================================================================

double precision function flops(n)
!------------------------------------------------------------------------
! Return the number of flops required. Beware that n^3 is larger than a
! 32-bit integer can hold for values of n greater than 1587 (1260 if
! signed integers were used instead of unsigned ones.) The variable
! nreal takes care of that.
!------------------------------------------------------------------------
    use kinds
    implicit none
    integer(kind=integer4) :: n
    flops = (1.0_real8/6.0_real8)*n*(4.0_real8*n+1.0_real8)*(n-1.0_real8)
end function flops

!======================================================================

integer function nrpts(total_flops, n)
!----------------------------------------------------------------
! How many repetitions to perform for a given number of flops
! a single iteration requires.
!----------------------------------------------------------------
    use kinds
    implicit none
    integer(kind=integer4) :: n
    real(kind=real8) :: flops, total_flops
    nrpts = ceiling(max(1.0_real8, total_flops/flops(n)))
end function nrpts

!======================================================================

