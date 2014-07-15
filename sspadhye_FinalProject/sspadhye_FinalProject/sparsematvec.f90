
module sparsematvec
    use kindlytypes
    use, intrinsic :: iso_fortran_env , only: stdout => output_unit, &
                                              stdin  => input_unit,  &
                                              stderr => error_unit
    implicit none
    logical, parameter:: spewage = .false.

    contains

    !
    !--------------------------------------------------------------------
    subroutine COOmatvec(x, y, rows, cols, vals, n, nnz)
    
        integer(kind=defint):: nnz, n
        integer(kind=defint):: i, k
        integer(kind=defint):: rows(nnz), cols(nnz)
        real(kind=real8):: vals(nnz), x(n), y(n)
       
        if (spewage) then
            write(unit=stdout,fmt=666)'In COOmatvec, have the following inputs:'
            write(unit=stdout,fmt=777)'                   n = ', n
            write(unit=stdout,fmt=777)'                 nnz = ', nnz
        end if
    
        if (n < 1 .or. nnz < 1) then
            write(unit=stderr,fmt=666) 'Things are badly screwed with n, nnz'
            stop
        end if
    
        y(1:n) = 0_real8
        do k = 1, nnz
            y(rows(k)) = vals(k)*x(cols(k))
        end do
        return
        include 'formats'
    
    end subroutine COOmatvec


    !
    !--------------------------------------------------------------------
    subroutine CSRmatvec(x, y, rows, cols, vals, n, nnz)
    
        integer(kind=defint):: nnz, n
        integer(kind=defint):: i, k
        integer(kind=defint):: rows(n+1), cols(nnz)
        real(kind=real8):: vals(nnz), x(n), y(n)
       
        if (spewage) then
            write(unit=stdout,fmt=666)'In CSRmatvec, have the following inputs:'
            write(unit=stdout,fmt=777)'                   n = ', n
            write(unit=stdout,fmt=777)'                 nnz = ', nnz
        end if
    
        if (n < 1 .or. nnz < 1) then
            write(unit=stderr,fmt=666) 'Things are badly screwed with n, nnz'
            stop
        end if

        y(1:n) = 0_real8
        do i = 1, n
            do k = rows(i), rows(i+1)-1
                y(i) = y(i) + vals(k)*x(cols(k))
            end do
        end do
    
        return
        include 'formats'
    
    end subroutine CSRmatvec

    !
    !--------------------------------------------------------------------
    subroutine CSCmatvec(x, y, rows, cols, vals, n, nnz)
    
        integer(kind=defint):: nnz, n
        integer(kind=defint):: i, k
        integer(kind=defint):: rows(n+1), cols(nnz)
        real(kind=real8):: vals(nnz), x(n), y(n)
       
        if (spewage) then
            write(unit=stdout,fmt=666)'In CSCmatvec, have the following inputs:'
            write(unit=stdout,fmt=777)'                   n = ', n
            write(unit=stdout,fmt=777)'                 nnz = ', nnz
        end if
    
        if (n < 1 .or. nnz < 1) then
            write(unit=stderr,fmt=666) 'Things are badly screwed with n, nnz'
            stop
        end if

        y(1:n) = 0_real8

        do k = 1 , n
            do i = cols(k), cols(k+1)-1
                y(rows(i)) = y(rows(i)) + vals(i)*x(k) 
            end do
        end do

        return
        include 'formats'
    
    end subroutine CSCmatvec

end module sparsematvec


