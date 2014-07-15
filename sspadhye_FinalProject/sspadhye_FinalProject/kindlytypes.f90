module kindlytypes
!-------------------------------------------------------------------------
! Store the kinds of integers, reals, etc needed for a Fortran procedure.
! This sets shortint and default_int as 4-byte integers, mainly
! because who needs a 16-bit integer nowadays?
!-------------------------------------------------------------------------
    implicit none
    public 
    
    integer, parameter:: single      = selected_real_kind(6,37)
    integer, parameter:: doubles     = selected_real_kind(13,300)
    integer, parameter:: real4       = single
    integer, parameter:: real8       = doubles

    integer, parameter:: shortint    = selected_int_kind(8)
    integer, parameter:: defint      = selected_int_kind(8)
    integer, parameter:: longint     = selected_int_kind(18)
    !------------------------------------------------------------
    ! Names that C programmers might feel more comfortable with. 
    ! And if they don't, then let 'em write their own.
    !------------------------------------------------------------
    integer, parameter:: float_type   = single
    integer, parameter:: double_type  = doubles
    integer, parameter:: int_type     = shortint
    integer, parameter:: longint_type = longint

end module kindlytypes
