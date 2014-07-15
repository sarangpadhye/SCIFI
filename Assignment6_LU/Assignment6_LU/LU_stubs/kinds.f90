
module kinds

!---------------------------------------------------------------------------------
! 
! Store the kinds of integers, reals, etc needed for a single program suite. The
! term "kinds" here is in the Fortran sense of single versus double precision
! or 32 bit versus 64 bit integer. First question everyone asks about this:
! why specify a precision of 13 digits for a double?  Answer: because Cray is
! screwed up.  Although its double precision uses 8 bytes nowadays, it only
! provides 13 digits of precision, having traded off the other bits for exponent.
! 
! It could be worse. The older crays had single precision taking 8 bytes, and
! double precision 16 bytes. IEEE 754 standard?  If Cray had heard of it, they
! must have sneered.
! 
! Another note: the convention of using real*4 and real*8 for single and
! double precision is widespread and supported by all of the compilers I have
! tested. However, it is not standard Fortran, unless the 2008 standard has
! brought them into the fold.
! 
! This module does not contain definitions of complex kinds, because the codes
! it's been used for do not have complex numbers. Add 'em on if you need them.
!
!-----------------
! Randall Bramley
! Department of Computer Science
! Indiana University, Bloomington
!-----------------
! Started: circa 1999
! Modified: Tue 27 Oct 2009, 05:52 PM for commenting
! Last Modified: Mon 24 Sep 2012, 07:49 PM
!---------------------------------------------------------------------------------

    implicit none
    public 
    

    !================== Real number kinds =====================================
    integer, parameter :: real4 = selected_real_kind(6,37)
    integer, parameter :: real8 = selected_real_kind(13,300)

    ! Names that C programmers may feel more comfortable with
    integer, parameter :: float_type = real4
    integer, parameter :: double_type= real8

    !================== Integers kinds ========================================
    
    integer, parameter::  integer4 = selected_int_kind(9)
    integer, parameter::  integer8 = selected_int_kind(18)
    integer, parameter::  default_int = integer4
    
    integer, parameter::  int_type = selected_int_kind(9)
    integer, parameter::  longint_type = selected_int_kind(18)


end module kinds
