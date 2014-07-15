subroutine rowswp( n, A, lda, startrow, endrow, ipiv)
!--------------------------------------------------------------------------
!
! Do row interchanges corresponding to pivoting in an LU factorization 
! on the array A. This is done on rows startrow through endrow, with
! a row swap for each of those rows. This differs from the subprogram
! swaps by only handling going forward through the interchanges.
! ipiv(k) = j means rows k and j are to be swapped with each other.
!
! n         = number of columns of the matrix A
! A         = lda x n array with rows to be permuted
! lda       = declared leading dimension of the array A
! startrow  = first row where interchanges will be done.
! endrow    = last row needing interchanges
! ipiv      = vector of pivots
!
! The parameter spew_bile is an artifact of original debugging.
!
!----------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!-----------------
! Started: Thu 31 Oct 2013, 03:05 PM
! Last Modified: Thu 31 Oct 2013, 03:06 PM
!--------------------------------------------------------------------------

    use kinds, only: real8, default_int
    use iso_fortran_env, only: stderr => error_unit
    implicit none

    integer, intent(in) :: startrow, endrow, lda, n, ipiv(lda)
    real(kind=real8)    :: A(lda,n)
    integer(default_int):: i, ip
    logical, parameter  :: spew_bile = .false.
    !---------------------------------------------------------------------
    ! Use the BLAS-1 routine dswap for the actual swaps. This external 
    ! declaration is not really needed, but is considered good practice.
    !---------------------------------------------------------------------
    external :: dswap

    if (spew_bile) then
        Write(unit=stderr,fmt=666) '  inside of rowswp'
        Write(unit=stderr,fmt=777) '  n = ', n
        Write(unit=stderr,fmt=777) '  lda = ', lda
        Write(unit=stderr,fmt=777) '  startrow = ', startrow
        Write(unit=stderr,fmt=777) '  endrow = ', endrow
        Write(unit=stderr,fmt=666) '  ---------'
        Write(unit=stderr,fmt=777) '  rowswp:lbound(ipiv) = ', lbound(ipiv)
        Write(unit=stderr,fmt=777) '  rowswp:ubound(ipiv) = ', ubound(ipiv)
        Write(unit=stderr,fmt=777) '  ipiv(1) = ', ipiv(1)
        Write(unit=stderr,fmt=777) '  ipiv(n) = ', ipiv(n)
        ! Stop
    end if

    do i = startrow, endrow
        ip = ipiv(i)
        if (ip /= i ) call dswap(n, A(i, 1), lda, A(ip, 1), lda )
    end do 
    if (spew_bile) then
        write(unit=stderr, fmt=666) "  By y'all, from good ol' rowswp"
    end if

    return
    666 format(a)
    777 format(a, i6)
end
