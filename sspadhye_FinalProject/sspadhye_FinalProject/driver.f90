
program testmatvec
!--------------------------------------------------------------------------------
!
! Create a sparse linear system of orders nmin:nstride:nmax, with about nzperrow
! nonzerows per row. Those four parameters are read from a file named "sizes".
! Then call a sparse matrix-vector product function that times how long it takes
! to do the multiply. Output results to a text file named "results".
!
! This uses the ISO C-binding capability of Fortran to allow calling
! elapsedtime() without underscores being needed. 
!
!-----------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!----------------------
! Started: 09 Dec 2013, 02:08 PM
! Last Modified: Wed 11 Dec 2013, 07:07 AM
!--------------------------------------------------------------------------------

    use kindlytypes ! loads real8 = double, defint = default integer
    
    use, intrinsic :: iso_fortran_env , only: stdout => output_unit, &
                                              stdin  => input_unit,  &
                                              stderr => error_unit
    implicit none
    logical, parameter:: benoisy = .false.
    logical, parameter:: dumpmat = .false.

    ! Allocatables
    real(kind=real8),     allocatable, dimension(:) :: vals, x, y
    integer(kind=defint), allocatable, dimension(:) :: rows, cols, rowptrs

    real(kind=real8)            :: tstart, tend, time_taken, gflops
    integer(kind=defint)        :: nmin, nmax, nstride, k
    integer(kind=defint)        :: nzperrow, nzmax
    integer(kind=defint)        :: n, nnz
    
    ! The results file unit number, and error flags 
    integer(kind=defint) :: results=14, iostatus, allocation_status, errflag
    integer(defint) ::  whichone 

!=============================================================================
! Explicit interfaces needed for routines with bind(C), pass by value, or 
! that munge upon allocatable arrays.
    interface
        include "Elapsedtime.intf"
        include "Setmatrix.intf"
        include "Timedmatvec.intf"
    end interface
!=============================================================================

    ! OK, now make sure the output file can be, well, outputted to
    open(newunit=results,      &
            file='results',    &
            action='write',    &
            position='append', &
            iostat=iostatus)
    if (iostatus /= 0) then
        write(stderr, 777) 'Unable to open output file results; iostat = ', iostatus
        stop
    end if
    write(results, 666) '% whichone  n            nnz       timetaken        gflop/sec'

    ! Read in the parameters specifying sizes to test
    call getparameters(nmin, nmax, nstride, nzperrow)

    !----------------------------------------------------------------------------
    ! Allocate the storage needed for the largest size to check. Actual array
    ! sizes needed will be slightly less, because of first/last few rows in the
    ! matrix.
    !----------------------------------------------------------------------------
    nnz = nmax*nzperrow
    allocate(x(nmax),         &
             y(nmax),         &
             vals(nnz),       &
             rows(nnz),       &
             cols(nnz),       &
             rowptrs(nmax+1), &
             stat=allocation_status)          
    if (allocation_status /= 0) then
        write(stderr, *) 'Out of memory when allocating in driver'
        write(stderr, *) '    nmax     = ', nmax
        write(stderr, *) '    nzperrow = ', nzperrow
        write(stderr, *) '    nnz      = ', nnz
        stop
    end if

    x(1:nmax) = 1.0_real8
    y(1:nmax) = 1.0e10_real8

    matrix_sizes: do n = nmin, nmax, nstride

        ! In general, the matrix needs to be reset for different orders
        tstart = elapsedtime()
        call setmatrix(n, nzperrow, nnz, rows, cols, vals, rowptrs)
        tend = elapsedtime() - tstart
        if (benoisy) write(stdout, 888) 'Time to set matrix = ', tend
    
        ! For debugging only. Do *not* use for nmax > 100 or so, it won't help
        ! any.  And it will fill up your quota on shared CS machines.  This
        ! writes to the file "results", so beware it will trash what's there.
        if (dumpmat) then
            do k = 1, nnz
                write(results, 444) rows(k), cols(k), vals(k)
            end do
        end if
    
        data_struct: do whichone = 1, 2
            if (whichone == 1) then
            call timedmatvec(errflag, n, nnz, rows, cols, vals, whichone, &
                        x, y, time_taken)
            else
            call timedmatvec(errflag, n, nnz, rowptrs, cols, vals, whichone, &
                        x, y, time_taken)
            end if
            gflops = (2.0e-9_real8)*real(nnz, real8)/time_taken
            write(results, 333) whichone, n, nnz, time_taken, gflops
        end do data_struct
    
    end do matrix_sizes

    close(results)
    deallocate(vals, rows, cols, x, y, rowptrs)
    stop
    include "formats"

end program testmatvec
