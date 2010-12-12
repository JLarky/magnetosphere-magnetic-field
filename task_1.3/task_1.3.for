	program task3
        COMMON /GEOPACK1/ AAA(10),SPS,CPS,BBB(23)

        open (unit=1, file='../data/polar.dat',status='OLD')
        open (unit=2, file='trace.dat')
        open (unit=3, file='pitch.dat')
	L=0;
123    format(i2,1x,i2,1x,i4,1x, i2,1x,i2,1x,i2,4x,6f23.8)
	do
	read (1,123,end=34,err=35) IDAY,MON,IYEAR,IHOUR,MIN,ISEC,
     _    XGSM,YGSM,ZGSM
        L=L+1

	if (MON.eq.2) then ! february
	  IDAY = IDAY + 31
        end if
        call recalc (Iyear,Iday,Ihour,min,Isec)	

c	call get_footprint(XGSM,YGSM,ZGSM)
c	stop

	call gsm_to_mag_ll(XGSM,YGSM,ZGSM, THETA,PHI)
	print *, 'init point', theta, phi

	call get_footprint_gsm(XGSM,YGSM,ZGSM, XF, YF, ZF)
	call gsm_to_mag_ll(XF, YF, ZF, THETA,PHI)
	if (XF**2+YF**2+ZF**2 .eq. 0.) then
	   print *, 'error skip'
	else
	   write (2,*)  theta/3.14159*180, phi/3.14159*180-180
	   call get_cgm_from_gsm(XF, YF, ZF, LAT, LONG)
	   print *, 'new point', XGSM,YGSM,ZGSM,  XF, YF, ZF
	end if


	call get_pitch_angle(XGSM,YGSM,ZGSM,pa)
	print *, 'pa', pa
	! output pitch angle only if line is closed
	if (pa.ne.0) then
	  print *,'ok', tf1_min, tf1_max, tf2_min, tf2_max
	  write (3, '(6f15.6)') XGSM,YGSM,ZGSM, 
     _      theta/3.14159*180, phi/3.14159*180-180, pa
	end if


c	stop
	end do

35    print *, 'error L=', L
	stop 1
34    print *, 'End of file L=', L

	end program

	subroutine get_footprint_gsm(XGSM,YGSM,ZGSM, XF, YF, ZF)
	dimension parmod(10)	! -- dummy
	external dip, zero, igrf_gsm ! declare dip, zero as subroutine names
	real :: XX(1000),YY(1000),ZZ(1000) ! array containing all poins along field line
	RLIM = 60.0
	R0 = 1.
	IOPT = 1

	dir = -1.
	call TRACE (XGSM,YGSM,ZGSM, DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	r = sqrt(Xf**2+Yf**2+Zf**2)
	if (r.gt.2.) then ! field line going to tail. 
	   ! I don't know how to handle that, so we will skip it
	   print *, 'error', XGSM,YGSM,ZGSM, XF,YF,ZF
	   XF = 0.;YF = 0.;ZF = 0.; !mark skiped points
c	   stop
	end if
	end subroutine get_footprint_gsm

	subroutine get_cgm_from_gsm(XGSM,YGSM,ZGSM, LAT, LONG)
	dimension parmod(10)	! -- dummy
	external dip, zero, igrf_gsm ! declare dip, zero, igrf_gsm as subroutine names
	real :: XX(1000),YY(1000),ZZ(1000) ! array containing all poins along field line
	RLIM = 6.0 ! we dont need to go further, because in this area igrf=dip
	R0 = 1.0
	IOPT = 1

	dir = 1.
	call TRACE (XGSM,YGSM,ZGSM, DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF1,YF1,ZF1,XX,YY,ZZ,L)
	r = sqrt(Xf1**2+Yf1**2+Zf1**2)
	if (r.lt.5.9) then ! if final point closer than RLIM that means
	   ! field line is closed and we must find point from trajectory
	   ! that lies on equatorial plane (it's point have max distant 
	   ! from Earth)
	   do i = 1, L		! find most distant point from XX,YY,ZZ
	      r_curr = sqrt(XX(i)**2+YY(i)**2+ZZ(i)**2)
	      if (r_curr .gt. r) then ! is more distant
		 r = r_curr 
		 XF1=XX(i);YF1=YY(i);ZF1=ZZ(i)
	      end if
	   end do
	   print *, 'error2', XGSM,YGSM,ZGSM, XF1,YF1,ZF1, l
	end if
	dir = -1.
	call TRACE (XF1,YF1,ZF1, DIR,RLIM+2.,R0,IOPT,PARMOD,ZERO,DIP,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	r = sqrt(Xf**2+Yf**2+Zf**2)
	if (r.gt.2.) then
	   print *, 'error3', XF1,YF1,ZF1, XF,YF,ZF, l
	   stop
	end if

	call gsm_to_mag_ll(XF,YF,ZF, THETA,PHI)
	end subroutine

	subroutine gsm_to_mag_ll(XGSM,YGSM,ZGSM, THETA,PHI)
	! convert gsm to geo
	call GEOGSM (XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,-1)
	print *, 'geo', XGEO,YGEO,ZGEO
	! convert geo to mag
	call GEOMAG (XGEO,YGEO,ZGEO,XMAG,YMAG,ZMAG,1)
	! convert mag to spherical
	call SPHCAR (R,THETA,PHI,Xmag,Ymag,Zmag,-1)
	print *, R,THETA,PHI
	end subroutine gsm_to_mag_ll

	subroutine get_pitch_angle(XI,YI,ZI,pa)
        dimension parmod(10) ! -- dummy
	external dip, zero ! declare dip, zero as subroutine names
	real :: XX(1000),YY(1000),ZZ(1000) ! array containing all poins along field line

	RLIM = 30.0
	R0 = 1.+100./6371.
	IOPT = 1

	dir = 1.
	call TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,ZERO,DIP,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	call get_fields(xx,yy,zz,l, tf1_min, tf1_max)
	dir = -1.
	call TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,ZERO,DIP,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	call get_fields(xx,yy,zz,l, tf2_min, tf2_max)

	tf_min = min(tf1_min,tf2_min)
	tf_max = max(tf1_max,tf2_max)

	pa = asin(sqrt(tf_min/tf_max))
	print *, 'pitch', pa, tf_max, tf_min

c	stop
	
	end subroutine get_pitch_angle



	subroutine get_fields(xx,yy,zz,l,tf_min,tf_max)
	real :: xx(l), yy(l), zz(l)
c	move along field line
	tf_max = 0.
	tf_min = 1e10
	do i = 1, l
	! calculate field module
	  call IGRF_GSM (xx(i),yy(i),zz(i),BXGSM,BYGSM,BZGSM)
	  tf = sqrt(bxgsm**2+bygsm**2+bzgsm**2)
	  if (tf.gt.tf_max) then
	    tf_max = tf
	  end if
	  if (tf.lt.tf_min) then
            tf_min = tf
	  end if
c	  print *, tf, xx(i),yy(i),zz(i)
	end do
	! mark cases when we going from the Earth
	if (sqrt(xx(i-1)**2+yy(i-1)**2+zz(i-1)**2).gt.1.1) then
	  tf_min = 0.
	end if
	end subroutine

	SUBROUTINE ZERO(IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
	 bx=0.;by=0.;bz=0.;
	end subroutine zero
