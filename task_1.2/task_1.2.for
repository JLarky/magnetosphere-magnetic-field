	program task2
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

        call DIP (xgsm,ygsm,zgsm,dbx,dby,dbz)
	call IGRF_GSM (XGSM,YGSM,ZGSM,HXGSM,HYGSM,HZGSM)

        diff=SQRT((dbx-HXGSM)**2+(dby-HYGSM)**2+(dbz-HZGSM)**2)
        ratio=diff/SQRT((dbx)**2+(dby)**2+(dbz)**2)
	r=SQRT((XGSM)**2+(YGSM)**2+(ZGSM)**2)
	ratio_percent = 100.0 * ratio
	write(2,*) r, diff, ratio_percent

	end do

35    print *, 'error L=', L
	stop 1
34    print *, 'End of file L=', L

	end program