	program task3
        COMMON /GEOPACK1/ AAA(10),SPS,CPS,BBB(23)

        open (unit=1, file='../data/polar.dat',status='OLD')
        open (unit=2, file='compare.dat')
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

c       subroutine to get footprint in corrected coordinates
	call get_footprint(XGSM,YGSM,ZGSM, lat, long)
	r=SQRT((XGSM)**2+(YGSM)**2+(ZGSM)**2)
	print *, IDAY,MON,IYEAR, r, lat, long

c        call DIP (xgsm,ygsm,zgsm,dbx,dby,dbz)
c	call IGRF_GSM (XGSM,YGSM,ZGSM,HXGSM,HYGSM,HZGSM)

c        diff=SQRT((dbx-HXGSM)**2+(dby-HYGSM)**2+(dbz-HZGSM)**2)
c        ratio=diff/SQRT((dbx)**2+(dby)**2+(dbz)**2)
c	ratio_percent = 100.0 * ratio
c	write(2,*) r, diff, ratio_percent

	end do

35    print *, 'error L=', L
	stop 1
34    print *, 'End of file L=', L

	end program

	subroutine get_footprint(XI,YI,ZI, lat, long)
        dimension parmod(10) ! -- dummy
	external igrf_gsm, zero ! declare igrf_gsm, zero as subroutine names
	real :: XX(1000),YY(1000),ZZ(1000) ! array containing all poins along field line

	RLIM = 6.0 ! we dont need to go further, because in this area igrf=dip
	R0 = 1.0
	IOPT = 1

	if (.false.) then
c       * Move away from Earth
c	we must move along igrf field-line to sufficient distance from Earth.
c       we will use TRACE to do that, having EXNAME=zero and INNAME=IGRF.
	RLIM = 6.0 ! we dont need to go further, because in this area igrf=dip
	R0 = 1.0
	IOPT = 1
c       instead of determinating DIR we will stupidly go in both directions

	DIR = -1.
	call TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	r_0 = sqrt(XI**2+YI**2+ZI**2)
	r_c = sqrt(XX(2)**2+YY(2)**2+ZZ(2)**2)
	if (r_0.gt.r_c) then ! wrong direction (it's toward Earth)
	   DIR = 1.0
	   call TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF,YF,ZF,XX,YY,ZZ,L)
c	   call find_most_distinct(XX,YY,ZZ,L,r_m1,x_m1,y_m1,z_m1)
	   
	   print *, '-->', XI,YI,ZI,XX(2),YY(2),ZZ(2)
	   print *, '-->', r_0-r_c
	end if

	print *, '<> ', XF,YF,ZF, sqrt(XF**2+YF**2+ZF**2)

	call find_most_distinct(XX,YY,ZZ,L,r_m,x_m,y_m,z_m)
	if (r_m1.gt.r_m) then ! find right direction
c	   print *, '!=> ', dir, r_m,x_m,y_m,z_m
	   dir = 1.0 ! first assumption was right
	   r_m = r_m1;x_m=x_m1;y_m=y_m1;z_m=z_m1
	end if
	print *, 'm=> ', r_m,x_m,y_m,z_m
	end if

	x_m = XI;y_m=YI;z_m=ZI;
	dir = 1.
c       * Return
c	now we must return from point x_m,y_m,z_m to Earth
	RLIM = 20.0 ! we need all points
	call TRACE (X_m,Y_m,Z_m,DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	if (sqrt(XF**2+YF**2+ZF**2).gt.1.) then
	   DIR = -1.
	   call TRACE (X_m,Y_m,Z_m,DIR,RLIM,R0,IOPT,PARMOD,ZERO,IGRF_GSM,
     _       XF,YF,ZF,XX,YY,ZZ,L)
	end if
	

	end subroutine get_footprint

	subroutine find_most_distinct(XX,YY,ZZ,L,r_max,x_max,y_max,z_max)
c	find most distinct point in arrays XX,YY,ZZ
	  real :: XX(L),YY(L),ZZ(L) ! array containing all poins along field line
	  r_max = 0.
	  do I=1, L
	    XXX = XX(i)
	    YYY = YY(i)
	    ZZZ = ZZ(i)
	    r = sqrt(XXX**2+YYY**2+ZZZ**2)
	    if (r.gt.r_max) then
	      r_max = r
	      x_max = xxx
	      y_may = yyy
	      z_max = zzz
	    end if
c	    print *, '->', r, XXX, YYY, ZZZ
	  end do
c	  print *, '->', r_max, x_max, y_may, z_max
	end subroutine find_most_distinct

	SUBROUTINE ZERO(IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
	 bx=0.;by=0.;bz=0.;
	end subroutine zero
