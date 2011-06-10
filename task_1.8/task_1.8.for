	program task8
	real::lat,long,day,kev1,kev2,kev3,kev4,kev5,kev6
	CHARACTER(100) :: filename

	filename = 'NOAA14_MEPED1MIN_05-07-2011.dat'
!	filename = 'NOAA14_MEPED1MIN_08-07-2011.dat'
        open (unit=1, file=filename,status='OLD')
        open (unit=2, file='data.dat')

	L=0;
123    format(i2,1x,i2,1x,i4,1x,i2,1x,i2,1x,f6.3,3f14.5,15f23.6)
	do
	read (1,123,end=34,err=35) IDAY,MON,IYEAR,IHOUR,MIN,ISEC,DAY,
     _		lat,long,notusable,kev1,kev2,kev3,kev4,notusable,kev5,kev6
	print *, IDAY,MON,IYEAR,IHOUR,MIN,ISEC,day,lat,long,
     _		kev1,kev2,kev3,kev4,kev5,kev6

        L=L+1
	if (long.gt.180) then
	   long = long - 360
	end if
	write (2,*) DAY,lat,long,kev1,kev2,kev3,kev4,kev5,kev6
	end do

35    print *, 'error L=', L
	stop 1
34    print *, 'End of file L=', L

	end program

