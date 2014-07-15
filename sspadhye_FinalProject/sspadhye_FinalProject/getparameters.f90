subroutine getparameters(nmin, nmax, nstride, nzperrow)

!-------------------------------------------------------
! Read in the parameters that define the sizes to test
!-------------------------------------------------------

    use kindlytypes
    use, intrinsic :: iso_fortran_env , only: stdout => output_unit, &
                                              stdin  => input_unit,  &
                                              stderr => error_unit
    implicit none
    logical:: benoisy = .false.

    integer(kind=defint) :: nmin, nmax, nstride, nzperrow
    integer(kind=defint) :: sizes = 18, iostatus
    
    if (benoisy) write(stdout, *) 'Opening file sizes from getparameters'
    open(newunit=sizes,       &
            file='sizes',     &
            action='read',    &
            iostat=iostatus)
    if (iostatus /= 0) then
        write(stderr, 777) 'Unable to open input file sizes; iostat = ', iostatus
        stop
    end if
    
    read(unit=sizes, iostat=iostatus, fmt=*) nmin, nmax, nstride, nzperrow
    if (iostatus /= 0) then
        write(stderr, 777) 'Unable to read in sizes; iostat = ', iostatus
        stop
    end if
    
    close(sizes)

    if (benoisy) then
        write(stdout,777) 'nmin = ', nmin
        write(stdout,777) 'nmax = ', nmax
        write(stdout,777) 'nstride = ', nstride
        write(stdout,777) 'nnzmin = ', nzperrow
        write(stdout,666) 'Returning from getparameters'
    end if

    return
    include 'formats'

end subroutine getparameters
