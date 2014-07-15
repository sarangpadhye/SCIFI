!===========================================================================
!
! This function elapsedtime.f90 can be used either directly, or via the
! module timemod.f90. The latter is the recommended way, because an optional
! argument to elapsedtime() requires any caller to have an explicit 
! interface block for it. If that is needed, it should take the form:
! 
! The elapsedtime.f90 function returns a double precision number,
! the number of seconds since some unspecified but specific event.
! Use the "which_version" variable to choose among the variants,
! or trust the default system_clock_version setting here. The possible
! values are:
!
!    which_version = 1 for date_and_time()
!    which_version = 3 for cpu_time()
!    which_version = 4 for system_clock() with 4-byte integers
!    which_version = 8 for system_clock() with 8-byte integers
!
!----------------------
! R. Bramley
! Department of Computer Science
! Indiana University
!-----------------------------------
! Started: 31 Oct 2013, 02:41 PM 
! Last Modified: Thu 31 Oct 2013, 02:42 PM 
!========================================================================

function elapsedtime() result (current_time)
    implicit none
    !--------------------------------------------------------------------
    ! Normally this would use the module kindlytypes to get the kind
    ! declarations, but that makes this function less stand-alone.
    !-------------------------------------------------------------------- 
    integer, parameter :: int4  = selected_int_kind( 9)
    integer, parameter :: int8  = selected_int_kind(18)
    integer, parameter :: real4 = selected_real_kind(6,37)
    integer, parameter :: real8 = selected_real_kind(13,300)
    real(kind=real8)   :: current_time
    integer, parameter :: which_version = 8

    integer(kind=int4) :: rate4, start4   ! cycles4 and finish4 not used
    integer(kind=int8) :: rate8, start8   ! cycles8 and finish8 not used
    integer            :: time_array(8)
    integer            :: use_dis_one
    integer, parameter :: date_and_time_version = 1
    integer, parameter :: system_clock_version4 = 4
    integer, parameter :: system_clock_version8 = 8
    integer, parameter :: cpu_time_version      = 3


    select case (which_version)

    !------------------------------------------------------------------
    ! Option 1 [time_array(4) is UTC offset and so not needed here]
    !------------------------------------------------------------------
    case (date_and_time_version)
        call date_and_time (values=time_array)
        current_time = time_array(8) * (1.0d-3)     &   ! number of milliseconds
                     + time_array(7) * (1.0d0)      &   ! number of seconds
                     + time_array(6) * (6.0d1)      &   ! number of minutes
                     + time_array(5) * (3.6d3)      &   ! number of hours
                     + time_array(3) * (24*3.6d3)       ! number of days

    !-------------
    ! Option 4
    !-------------
    case (system_clock_version4)
        call system_clock( count=start4, count_rate=rate4)
        current_time = real(start4, kind=real4)/real(rate4, kind=real4)


    !-------------
    ! Option 8
    !-------------
    case (system_clock_version8)
        call system_clock( count=start8, count_rate=rate8)
        current_time = real(start8, kind=real8)/real(rate8, kind=real8)

    !-------------
    ! Option 3
    !-------------
    case (cpu_time_version)
        call cpu_time(current_time)

    !---------------
    ! Non-option
    !---------------
    case default
        write(*,*) 'Dude (or dudess) read the code. gawt default case in timer'
        call system_clock( count=start8, count_rate=rate8)
        current_time = real(start8, kind=real8)/real(rate8, kind=real8)

    end select

    return

end function elapsedtime

