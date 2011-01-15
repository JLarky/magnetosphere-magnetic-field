	program task6
	external igrf_gsm, t89c
	real :: xx(1000), yy(1000), zz(1000), len
        open (unit=1, file='data.dat')

	R0=1.+100./6371.
	RLIM=60.0
	BM = 90*1000
	IOPT=1
	
	call recalc(2000,90,1,1,1)
	do long = -179, 180
	do lat = -63,63
	  print *, long, lat
	  THETA = (90-lat)*3.14/180.0
	  PHI = long*3.14/180.0
	  call sphcar(R0,THETA,PHI,XGEO,YGEO,ZGEO,1)
	  call geogsm(XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,1)
          call igrf_gsm(XGSM,YGSM,ZGSM,HX,HY,HZ)
	  if ((XGSM*hx+ygsm*hy+zgsm*hz).gt.0) then
	    dir = -1.
	  else
	    dir = 1.
	  end if
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

	  !! len = int (1-B/Bm)*ds
	  len = 0.
	  do i=1, L-1
	     ds = sqrt((xx(i)-xx(i+1))**2+(yy(i)-yy(i+1))**2+
     _            (zz(i)-zz(i+1))**2)
	     call igrf_gsm(xx(i),yy(i),zz(i),Hxx,Hyy,Hzz)
	     B = sqrt(Hxx**2+Hyy**2+Hzz**2)
	     if (B.lt.Bm) then
		len = len + sqrt(1-B/Bm)*ds
	     end if
	  end do
	  
	  write (1, '(2i8,4f10.2)') long, lat, field, field_delta, len
	end do
	end do
	end program
