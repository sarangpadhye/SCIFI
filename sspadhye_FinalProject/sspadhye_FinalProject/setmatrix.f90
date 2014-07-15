subroutine setmatrix(n, nzperrow, nnz, rows, cols, vals, rowptrs)
!----------------------------------------------------------------------------------
!
! This returns a matrix stored in a COO data structure. The variables are the 
! usual suspects:
!
! On entry, 
!   n         = number of rows = number of cols
!   nzperrow  = approximate number of nonzeros to set per row
!
! on return, 
!   nnz  = actual number of nonzeros in array
!   rows = integer array of the row indices, of length nnz
!   cols = integer array with column indices of the nonzeros 
!   vals    = double precision array with the nonzero values
!
! requirement: nnz >= 3*n
!
! If anything goes wrong, this just stops the whole show. No point in continuing
! if the data is not there.
!
! For C/C++ programmers: beware that (at least by default) Fortran starts 
! indexing from 1, not 0.
!----------------------------------------------------------------------------------

    use kindlytypes
    use iso_c_binding
    use, intrinsic :: iso_fortran_env , only: stdout => output_unit, &
                                              stdin  => input_unit,  &
                                              stderr => error_unit
    implicit none
    logical, parameter:: benoisy = .false.

    ! Values that define the matrix A 
    real(kind=real8),   dimension(:)   :: vals
    integer(kind=defint), dimension(:) :: rows, cols, rowptrs
    integer(kind=defint)               :: n, nzperrow, nnz

    integer(kind=defint) :: nrow, ncol, halfband, k, k0, j, i, iad

    halfband = (nzperrow-1)/2
    k   = 1
    nnz = 0

    if (benoisy) then
        write(stdout, 666) 'Inside setmatrix; have:'
        write(stdout, 777) '    n = ', n
        write(stdout, 777) '    nzperrow = ', nzperrow
        write(stdout, 777) '    nnz = ', nnz
        write(stdout, 777) '    halfband = ', halfband
        write(stdout, 777) '    max(nrow-halfband,1) = ', max(nrow-halfband,1)
    end if

    do nrow = 1, n
        lowerband: do ncol = max(nrow-halfband,1), nrow-1
            rows(k) = nrow
            cols(k) = ncol
            vals(k) = 10*nrow+ncol
            nnz     = nnz + 1
            k       = k + 1
        end do lowerband
    
        rows(k) = nrow
        cols(k) = nrow
        vals(k) = 10*nrow+nrow
        nnz     = nnz + 1
        k       = k + 1
    
        upperband: do ncol = nrow+1, min(nrow+halfband,n)
            rows(k) = nrow
            cols(k) = ncol
            vals(k) = 10*nrow+ncol
            nnz     = nnz + 1
            k       = k + 1
        end do upperband
    end do 

    !--------------------------------------------------
    ! Now create the vector of row "pointers" for CSR
    !--------------------------------------------------
    
    rowptrs(1:n+1) = 0
    ! Get length of each row
    do k = 1, nnz
        rowptrs(rows(k)) = rowptrs(rows(k))+1
    end do
    ! Find the starting position of each row
    k = 1
    do j = 1, n+1
         k0         = rowptrs(j)
         rowptrs(j) = k
         k          = k+k0
    end do

    ! Now fill in 
    do k = 1, nnz
         i          = rows(k)
         iad        = rowptrs(i)
         rowptrs(i) = iad+1
    end do

    ! shift back the row pointers
    do j = n, 1, -1
         rowptrs(j+1) = rowptrs(j)
    end do
    rowptrs(1) = 1

    return
    include "formats"

end subroutine setmatrix
