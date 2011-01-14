	program task6
	external igrf_gsm, t89c
	real :: xx(1000), yy(1000), zz(1000), len, len_d
        open (unit=1, file='lines.dat')

	R0=1.+300./6371.
	Rll= 1.
	RLIM=60.0
	IOPT=1	  
	
	call recalc(2000,90,1,1,1)
	do long = -179, 180
	do lat = -63,63
	  print *, long, lat
	  THETA = (90-lat)*3.14/180.0
	  PHI = long*3.14/180.0
	  call sphcar(R0,THETA,PHI,XGEO,YGEO,ZGEO,1)
	  call geogsm(XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,1)
	  if (lat.lt.0) then
	    dir = -1.
	  else
	    dir = 1.
	  end if
          call igrf_gsm(XGSM,YGSM,ZGSM,HX,HY,HZ)
	  call trace(XGSM,YGSM,ZGSM,dir,RLIM,Rll,IOPT,PARMOD,T89C,
     _					IGRF_GSM,XF,YF,ZF,XX,YY,ZZ,L)
	  if (sqrt(xf**2+yf**2+zf**2).gt.2.) then
	     print *, 'Error: line from ', lat, long, ' isn''t closed'
	     print *, sqrt(xf**2+yf**2+zf**2)
	     stop 1
	  end if
	  call igrf_gsm(xf,yf,zf,HXf,HYf,HZf)
	  field = sqrt(HX**2+HY**2+HZ**2)
	  field_delta = field - sqrt(HXf**2+HYf**2+HZf**2)

	  len = 0.; !! length of line?
	  do i=1, L-1
	     len = len + sqrt((xx(i)-xx(i+1))**2+(yy(i)-yy(i+1))**2+
     _            (zz(i)-zz(i+1))**2)
	  end do

	  !! length in latitude?
	  call geogsm(XfGEO,YfGEO,ZfGEO,xf,yf,zf,-1)
	  call sphcar(R0f,THETAf,PHIf,XfGEO,YfGEO,ZfGEO,-1)
	  len_d = 90-(THETAf)/3.14*180.0 - lat

	  do i=1, L-1
	     call igrf_gsm(xx(i),yy(i),zz(i),Hxx,Hyy,Hzz)
	  end do
	  print *, field - sqrt(Hxx**2+Hyy**2+Hzz**2)

	  print *, R0f, R0
	  
	  write (1, '(2i8,4f10.2)') long, lat, field, field_delta, len, len_d
!	  write (1, '(2i8,10g18.3)') long, lat, XGSM,YGSM,ZGSM, HX,HY,HZ
	end do
	  write (1, *) ''
	end do
	end program
