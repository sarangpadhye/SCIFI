
subroutine WriteParameters(nmin, nmax, skip, numbersizes, blower, &
            bupper, bstride, numbernus, outputunit)

!----------------------------------------------------------------------------------
!
! Virtually un-reusable routine to write out the inputs and some calculated values
! from those, for the LU factorization driver. This is mainly for debugging but
! can also write out stuff for Matlab analysis of timing results and other
! detritus. For Matlab munging, use format 200 to suppress the values being
! printed to the screen.
!
!-------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!---------------------------------
! Started: Sat 12 Dec 2009, 05:40 PM
! Last Modified: Thu 31 Oct 2013, 09:27 AM
!----------------------------------------------------------------------------------

    implicit none
    logical, parameter :: preceedMatlab = .true.
    integer :: outputunit    ! Output unit number, which must be alreadyh opened
    integer :: nmin          ! Smallest matrix order
    integer :: nmax          ! Largest matrix order
    integer :: skip          ! Stride in increasing matrix order from nmin to nmax
    integer :: numbersizes   ! How many matrix orders the last three imply
    integer :: blower        ! Smallest blocksize to test
    integer :: bupper        ! Largest blocksize to test
    integer :: bstride       ! Stride from smallest to largest blocksizes
    integer :: numbernus     ! How many block sizes will be tested
    ! integer :: numberevents  ! Number of code blocks to be independently timed
    ! integer :: si_fmt        ! Testing use of assign statement for grins

    !----------------------------
    ! Deleted as of Fortran 95:
    !----------------------------
    ! assign 100 to si_fmt

    if (preceedMatlab) then
        write(outputunit, fmt=200) 'nmin = ', nmin
        write(outputunit, fmt=200) 'nmax = ', nmax
        write(outputunit, fmt=200) 'skip = ', skip
        write(outputunit, fmt=200) 'numbersizes = ', numbersizes
        write(outputunit, fmt=200) 'blower = ', blower
        write(outputunit, fmt=200) 'bupper = ', bupper
        write(outputunit, fmt=200) 'bstride = ', bstride
        write(outputunit, fmt=200) 'numbernus = ', numbernus
        ! write(outputunit, fmt=200) 'numberevents = ', numberevents
        write(outputunit, fmt=200) 'total_factorizations = ', numbernus*numbersizes
    else
        write(outputunit, fmt=100) 'nmin = ', nmin
        write(outputunit, fmt=100) 'nmax = ', nmax
        write(outputunit, fmt=100) 'skip = ', skip
        write(outputunit, fmt=100) 'numbersizes = ', numbersizes
        write(outputunit, fmt=100) 'blower = ', blower
        write(outputunit, fmt=100) 'bupper = ', bupper
        write(outputunit, fmt=100) 'bstride = ', bstride
        write(outputunit, fmt=100) 'numbernus = ', numbernus
        ! write(outputunit, fmt=100) 'numberevents = ', numberevents
        write(outputunit, fmt=100) 'total factorizations = ', numbernus*numbersizes
    end if

100 format(a, i10)
200 format(a, i10, ';')
return

end subroutine WriteParameters

