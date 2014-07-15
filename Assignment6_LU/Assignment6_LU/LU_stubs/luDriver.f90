program drive
!---------------------------------------------------------------------------------
! 
! Test a version of LU factorization (AKA Gaussian Elimination) with partial
! pivoting. Try sizes from n = nmin to n = nmax in steps of skip, where all of
! those values are read from a file "sizes". The input parameter file also 
! specifies the minimum total flops needed for a meaningful timing block size,
! and three integers for the range of block sizes for the block versions of LU.
! A "timing block" is defined as the stuff between two successive calls to an
! elapsed time function, and should be at least 100*(clock resolution + clock 
! calling overhead).
!
! This code can optionally verify the accuracy of the factorization by computing
! ||P*A - L*U||. Set check_result = .true. to do this. It will only test the
! first factorization in a timing block, but even then it is slow going. Better
! to use this program in two different modes, selectable by check_result and 
! recompiling:
!   a. test correctness of LU8/LU4
!   b. do timing runs for effects of n and nb varying
! The checkLU.f90 function takes far longer to execute than the LU factorization 
! itself, the reason for recommending it be done with just one factorization
! in the timing block.
!
! This code doesn't call the O(n^2) triangular solves to solve Ax = b.
! That can be done using the trisol.f90 procedure.  Also because of this,
! the code is not a practical tool for LU factorization; for that, get a copy
! of LAPACK which doubtless whomps anyting I can write. 
!
! The results are printed out to a file: 
!
!   results.m : a Matlab m-file that defines arrays Axy, where xy = the
!               blocksize. Each array will have timings for that fixed
!               blocksize with n varying.
!
! Setting the parameter blither to .true. will write out scads of stuff to
! the stderr file (good ol' unit 0 or *). Redirect that if you want to treasure
! it forever. After that it's all bleakness, desolation, and plastic forks.
! 
!---------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!---------------------------
! Started: Thu 31 Oct 2013, 09:11 AM 
! Last Modified: Mon 04 Nov 2013, 06:09 AM 
!---------------------------------------------------------------------------------

    use kinds, only: real8
    ! Get the usual standard I/O unit numbers
    use iso_fortran_env, only: stdout => output_unit, &
                               stdin  => input_unit,  &
                               stderr => error_unit
    implicit none
    logical, parameter:: blither      = .false. ! debug/progress spewage 
    logical, parameter:: check_result = .false. ! correctness test
    real(kind=real8),allocatable::  OriginalA(:,:)   ! allocated iff check_result is true
    !------------------------------------------------------------------------
    real(kind=real8), allocatable :: A(:, :)      ! array to be factored
    real(kind=real8), allocatable :: b(:)         ! RHS vector, not really used
    real(kind=real8)              :: resid        ! error measure if check_result
    real(kind=real8), external    :: checkLU      ! check the code via checkLU.f90
    integer, allocatable          :: ipiv(:)      ! array of pivots
    integer                       :: sizes   = 14 ! for input file "sizes"
    integer                       :: results = 16 ! for output file "results.m"
    !------------------------------------------------------------------------
    ! Performance data:
    !-------------------
    !   flops       = total number of flops for a given n and nb. 
    !   gflops      = computational rate in billion flops per second
    !   elapsedtime = function returning current wall clock or cpu 
    !                   in number of seconds. [this is in timemod.f90 via
    !                   an INCLUDE statement]
    !   time        = time in seconds for a single LU8 invocation
    !   total       = sum of times over a number of timing repetitions made 
    !                   to LU8, for a particular n and blocksize
    !   totalflops  = sum of flops over the number of timing repetitions 
    !                   made to LU8
    !------------------------------------------------------------------------
    real(kind=real8)  :: flops
    real(kind=real8)  :: time, gflops, total, t
    real(kind=real8)  :: elapsedtime
    real(kind=real8)  :: averagetime
    real(kind=real8)  :: total_flops, nflops
    
    !--------------------------------------------------------------------------
    ! Other flotsam and integers:
    !-----------------------------
    ! The systems will be of order n, ranging from nmin to nmax in steps
    ! of skip. The blocksizes nb used will range from blower to bupper in
    ! steps of bstride. The other stuff here includes:
    !    info          = error flag returned from LU8/LU4
    !    allocate_stat = usual did-it-work variable for memory allocation
    !    iters         = iteration counter for timing repetitions loop
    !    j             = all-around integer kinda guy, for loop variables     
    !    repetitions   = number of reps to get reliable timings for a given n
    !    nrpts         = function computing repetitions needed for given n
    !    numbersizes   = number of different values of n to test
    !    numbernus     = number of different block sizes to test
    !    callnumber    = current number of calls made to LU8() during a run 
    !--------------------------------------------------------------------------
    integer :: m, n, info, nrpts,  allocate_stat
    integer :: nmin, nmax, skip, iters, nb, j
    integer :: blower, bupper, bstride, repetitions
    integer :: numbersizes, numbernus
    integer :: callnumber

    ! The first executable statement
    !================================
    open(unit=sizes,  file='sizes')
    open(unit=results, file='results', action='write', position='append')

    !---------------------------------------------------
    ! Slurp in all of the control parameters and stuff 
    !---------------------------------------------------
    read(sizes, *) nmin, nmax, skip, total_flops, blower, bupper, bstride
    if (nmax < 1 .or. nmin > nmax .or. blower < 1) then
        write(stderr, fmt=666) 'Something smells fishy with the input values.'
        call WriteParameters(nmin, nmax, skip, numbersizes, blower, &
            bupper, bstride, numbernus, stderr)
        stop
    end if
    close(sizes)

    numbersizes = mod((nmax - nmin + 1), skip)
    numbersizes = numbersizes + (nmax - nmin + 1)/skip
    numbernus   = mod((bupper - blower + 1), bstride)
    numbernus   = numbernus  + ((bupper - blower + 1)/bstride)

    if (blither) then
        call WriteParameters(nmin, nmax, skip, numbersizes, blower, &
            bupper, bstride, numbernus, stderr)
    end if

    !------------------------------------------------------------------
    ! Allocate the array data needed. This gets the largest array that 
    ! will be required, so effectively the declared leading dimension
    ! of A is lda = nmax.
    !------------------------------------------------------------------
    allocate(A(nmax,nmax), b(nmax), ipiv(nmax), STAT=allocate_stat)
    if (allocate_stat /= 0) then
        write(stderr, fmt=666) 'Could not allocate matrix in drive.f90. Check sizess'
        write(stderr, fmt=666) "in the file sizes. Here is what I've got:"
        call WriteParameters(nmin, nmax, skip, numbersizes, blower, &
            bupper, bstride, numbernus, stderr)
        stop
    end if 

    if (check_result) then
        allocate(OriginalA(nmax,nmax), STAT=allocate_stat)
        if (allocate_stat /= 0) then
            write(stderr,fmt=666) 'Could not allocate storage for second copy of A.'
            write(stderr,fmt=666) 'Reduce nmax or increase stack size'
            call WriteParameters(nmin, nmax, skip, numbersizes, blower, &
                bupper, bstride, numbernus, stderr)
            stop
        end if 
    end if

    write(unit=results, fmt=333)  ! Describes data in rows of results.m

    callnumber = 0
    blocksizes: do nb = blower, bupper, bstride
        if (blither) then
            write(stderr, fmt=777) 'testing blocksize = ', nb
        end if

        matrixsizes: do n = nmin, nmax, skip

            callnumber = callnumber + 1

            if (blither) then
                write(stderr, fmt=777) '   testing matrix order = ', n
            end if
            total   = 0.0
            repetitions = nrpts(total_flops, n)
            timing_repetitions: do iters = 1, repetitions
                call seta(A, b, nmax, n)
                ! Only save a copy of the original A if checking the result via
                ! check_result.f90. Turn this off for timing runs.
                if (check_result .and. iters == 1) then 
                    OriginalA = A ! Original copy of A
                end if

                time = elapsedtime()
                call LU8(A, nmax, n, ipiv, info, nb)
                time = elapsedtime() - time
                total = total + time
                if (info /= 0) then
                    write(results, *) 'Error in factorization; info = ',info
                    stop
                end if

                if (check_result .and. iters == 1) then 
                    resid = checkLU(n, n, OriginalA, nmax, A, nmax, ipiv)
                    write(stderr, fmt=555) 'For n = ', n, ', resid = ', resid
                end if
    
            end do timing_repetitions
    
            nflops = flops(n)
            averagetime = total/repetitions
            gflops = (1.0d-9)*nflops/averagetime

            write(results, 1000) n, nb, gflops, repetitions, averagetime, nflops
            1000 format(i9, 3x, i4, 3x, es18.6, 3x, i4, 3x, es14.4, 3x, es18.6)
            flush results

        end do matrixsizes

    end do blocksizes
    
    close(results)
    if (blither) write(stderr, fmt=666) 'All testing finished'
    if (check_result) deallocate(OriginalA)
    deallocate(A, b, ipiv)

    stop

    333 format(&
'%----------------------------------------------------------------------------',/, &
'%     n      nb           gflops        reps     averagetime          nflops', /, &
'%----------------------------------------------------------------------------')

    555 format(a, i12, a, es17.10)
    666 format(a)
    777 format(a, i12)
    888 format(a, es24.17)
    999 format(a, i12, a)
end program drive
