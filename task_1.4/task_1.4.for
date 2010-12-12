	program task4
	external igrf_gsm, t89c
        open (unit=1, file='field.dat')

	R0=1.+100./6371.
	RLIM=60.0
	IOPT=1	  
	
	call recalc(2000,90,1,1,1)
	do long = -179, 180
	do lat = -63,63
	  print *, long, lat
	  THETA = (90-lat)*3.14/180.0
	  PHI = long*3.14/180.0
c	  call sphcar(R0,THETA,PHI,XMAG,YMAG,ZMAG,1)
c	  call geomag(XGEO,YGEO,ZGEO,XMAG,YMAG,ZMAG,-1)
	  call sphcar(R0,THETA,PHI,XGEO,YGEO,ZGEO,1)
	  call geogsm(XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,1)
	  if (lat.lt.0) then
	    dir = -1.
	  else
	    dir = 1.
	  end if
          call igrf_gsm(XGSM,YGSM,ZGSM,HX,HY,HZ)
	  call trace(XGSM,YGSM,ZGSM,dir,RLIM,R0,IOPT,PARMOD,T89C,
     _					IGRF_GSM,XF,YF,ZF,XX,YY,ZZ,L)
	  if (sqrt(xf**2+yf**2+zf**2).gt.2.) then
	     print *, 'Error: line from ', lat, long, ' isn''t closed'
	     print *, sqrt(xf**2+yf**2+zf**2)
	     stop 1
	  end if
	  call igrf_gsm(xf,yf,zf,HXf,HYf,HZf)
	  field = sqrt(HX**2+HY**2+HZ**2)
	  field_delta = field - sqrt(HXf**2+HYf**2+HZf**2)
	  write (1, '(2i8,2f10.2)') long, lat, field, field_delta
!	  write (1, '(2i8,10g18.3)') long, lat, XGSM,YGSM,ZGSM, HX,HY,HZ
	end do
	  write (1, *) ''
	end do
	end program
