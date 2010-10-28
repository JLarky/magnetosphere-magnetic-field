	program task
        CHARACTER(len=1)::filename
	do Kp_interval = 1, 6 ! all available Kp-indexes. See T89c for meaning of IOPT parameter
	  write (filename,'(I1)') Kp_interval !filename = Kp_interval;
          open (unit=1, file='../data/polar.dat',status='OLD')
	  open (unit=2, file='compare_full_'//filename//'.dat')
	  open (unit=3, file='compare_ext_'//filename//'.dat')
	  ! input unit=1, output unit=2,3
	  call run_compare(Kp_interval)
	  close(1)
	  close(2)
	  close(3)
	end do
	end program

        subroutine run_compare(Kp_interval)
	L=0;
123     format(i2,1x,i2,1x,i4,1x, i2,1x,i2,1x,i2,4x,6f23.8)
	do
	read (1,123,end=34,err=35) IDAY,MON,IYEAR,IHOUR,MIN,ISEC,XGSM,YGSM,
     _    ZGSM, BXGSM,BYGSM,BZGSM
	L=L+1
c	iday день с начала года
	call compare(IYEAR,IDAY,IHOUR,MIN,ISEC,XGSM,YGSM,ZGSM,
     _    BXGSM,BYGSM,BZGSM, Kp_interval)
	end do

35      print *, 'error L=', L
	stop 1
34      print *, 'End of file L=', L
	end subroutine


	subroutine compare(IYEAR,IDAY,IHOUR,MIN,ISEC,XGSM,YGSM,ZGSM,
     _    BXGSM,BYGSM,BZGSM, Kp_interval)
        dimension parmod(10) ! -- dummy
        COMMON /GEOPACK1/ ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,SFI,CFI,
     _  SPS, CPS,SHI,CHI,HI,PSI,XMUT,A11,A21,A31,A12,A22,A32,A13,A23,A33,
     _  DS3,CGST,SGST,BA(6)
        CALL RECALC(IYEAR,IDAY,IHOUR,MIN,ISEC)
	ps = psi ! from recalc
	!print *, PSI, sps, cps
	iopt = Kp_interval

c	output: bx,by,bz --- extraterresial sources
        call t89c(iopt,parmod,ps,XGSM,YGSM,ZGSM,bx,by,bz)

c	output: HXGSM,HYGSM,HZGSM --- internas sources
	call IGRF_GSM (XGSM,YGSM,ZGSM,HXGSM,HYGSM,HZGSM)

c	compare full field
	write (2,'(6f12.4)') HXGSM+bx,HYGSM+by,HZGSM+bz, BXGSM,BYGSM,BZGSM
c       compare extraterresial sources only
	write (3,'(6f12.4)') bx,by,bz, BXGSM-HXGSM,BYGSM-HYGSM,BZGSM-HZGSM
	end subroutine compare
