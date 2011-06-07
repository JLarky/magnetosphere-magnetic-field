	program task10
	external igrf_gsm, t89c
	real*4 :: xx(1000), yy(1000), zz(1000)
	COMMON /GEOPACK1/ AB(10),SPS,CPS,ABB(3),PS,CD(18) ! call recalc_08

        open (unit=1, file='field.dat')

	R0=1.+100./6371.
	RLIM=60.0
	IOPT=1	  
	

	call recalc(2000,90,1,1,1)

	! take point from geostationary orbit (approx)
	Xgsm = -6.!Re
	Ygsm = 0.
	Zgsm = 0.

	r = sqrt(Xgsm**2+Ygsm**2+Zgsm**2)

	if (xgsm.gt.0.) then
	   print *, 'noon R=', r
	else
	   print *, 'midnight R=', r
	end if

	! find Earth projection
	dir = 1.
	call trace(XGSM,YGSM,ZGSM,dir,RLIM,R0,IOPT,PARMOD,T89C,
     _	       IGRF_GSM,XF,YF,ZF,XX,YY,ZZ,L)

!	print *, L, XF,YF,ZF
!	do i = 1, l; print *, xx(i), yy(i), zz(i); end do

	! find line from Earth surface
	Xgsm = XF
	Ygsm = YF
	Zgsm = ZF
	dir = -dir
	call trace(XGSM,YGSM,ZGSM,dir,RLIM,R0,IOPT,PARMOD,T89C,
     _	       IGRF_GSM,XF,YF,ZF,XX,YY,ZZ,L)

	V_full = 0.
	V_close = 0.
	do i = 1, l-1
	   rh = 1.+1000./6400. ! distance from Earth to 1000km
	   r = sqrt(xx(i)**2+yy(i)**2+zz(i)**2)
	   dl = sqrt((xx(i)-xx(i+1))**2+(yy(i)-yy(i+1))**2+(zz(i)-zz(i+1))**2)
	   call t89c(iopt,parmod,ps,xx(i),yy(i),zz(i),bx,by,bz)
	   call IGRF_GSM (xx(i),yy(i),zz(i),HXGSM,HYGSM,HZGSM)
	   B = sqrt((bx+HXGSM)**2+(by+HYGSM)**2+(bz+HZGSM)**2)
	   dv = dl/B
	   V_full = V_full+dv
	   if (rh > r) then
	      V_close = V_close+dv
	   end if
	   print *, xx(i), yy(i), zz(i), r, rh < r, dl, b, dv
	end do
	
	print *, V_full, V_close, V_close/V_full*100., '%'

	end program
