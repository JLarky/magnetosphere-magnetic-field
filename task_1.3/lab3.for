	open(1,file='polar.dat',status='old')
	open(2,file='cgm.dat')
	open(3,file='pa.dat')

33	read(1,*,end=22,err=88) IDAY,MON,IYEAR,IHOUR,MIN,ISEC,milisec,
     *					XSGSM,YSGSM,ZSYGSM,bx,by,bz,bxi,byi,bzi
	call recalc(IYEAR,IDAY,IHOUR,MIN,ISEC)
	call defineDIR(XSGSM,YSGSM,ZSGSM,DIR)
	call checkline(DIR,XSGSM,YSGSM,ZSGSM,XF,YF,ZF)
	if (XF**2+YF**2+ZF**2.eq.0) then
		goto 33
	endif
	call gsmcgm(DIR,XSGSM,YSGSM,ZSGSM,XCGSM,YCGSM,ZCGSM,Mpar)
	if (Mpar.eq.0) then
		goto 33
	endif
	call gsmmagll(XCGSM,YCGSM,ZCGSM,TLAT,TLON)
	write(2,102) TLAT,TLON
102	format(F7.2,1x,F7.2)
	call pitch(DIR,XSGSM,YSGSM,ZSGSM,PA)
	if (PA.eq.0.) then
		goto 33
	else
	write(3,106) TLAT,TLON,PA
106	format(F7.2,1x,F7.2,1x,F9.6)	
	endif
	goto 33
22	continue
	close(1)
	close(2)
	close(3)

88	write(2,104)
104	format('error reading')

	stop
	end
************************************************************
	subroutine defineDIR(XGSM,YGSM,ZGSM,DIR)

			if (ZGSM.gt.0) then
				DIR=-1.
			else
				DIR= 1.
			endif

	end subroutine defineDIR
************************************************************
	subroutine checkline(DIR,XGSM,YGSM,ZGSM,XF,YF,ZF)
		
		external IGRF_GSM,EXMODEL
		dimension PARMOD(10)
		real XX(1000),YY(1000),ZZ(1000)
		R0=1.
		RLIM=60.
		IOPT=1
		call trace(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,EXMODEL,
     *		IGRF_GSM,XF,YF,ZF,XX,YY,ZZ,L)
		r=sqrt(XF**2+YF**2+ZF**2)
		if (r.gt.2.) then
			XF=0;
			YF=0;
			ZF=0
		endif

	end subroutine checkline
************************************************************
	subroutine gsmcgm(DIR,XGSM,YGSM,ZGSM,XCGSM,YCGSM,ZCGSM,Mpar)
		
		dimension PARMOD(10)
		external IGRF_GSM,DIP,EXMODEL
		real XX(1000),YY(1000),ZZ(1000)
		R0=1.
		RLIM=8.
		IOPT=1
		call trace(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,EXMODEL,
     *			IGRF_GSM,XFGSM,YFGSM,ZFGSM,XX,YY,ZZ,L)
		r=sqrt(XFGSM**2+YFGSM**2+ZFGSM**2)
		if (r.lt.7.) then
			do i=1,L
				rc=sqrt(XX(i)**2+YY(i)**2+ZZ(i)**2)
				if (rc.gt.r) then
					r=rc
					XFGSM=XX(i);
					YFGSM=YY(i);
					ZFGSM=ZZ(i)
				endif
			enddo
		endif
		call trace(XFGSM,YFGSM,ZFGSM,-DIR,RLIM+1.,R0,IOPT,PARMOD,
     *			EXMODEL,DIP,XCGSM,YCGSM,ZCGSM,XX,YY,ZZ,L)
		r = sqrt(XCGSM**2+YCGSM**2+ZCGSM**2)
		Mpar=1
		if (r.gt.2.) then
			Mpar=0	
		endif

	end subroutine gsmcgm
************************************************************
	subroutine gsmmagll(XGSM,YGSM,ZGSM,TLAT,TLON)

		call geogsm(XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,-1.)
		call geomag(XGEO,YGEO,ZGEO,XMAG,YMAG,ZMAG,1.)
		call sphcar(R,THETA,PHI,XMAG,YMAG,ZMAG,-1.)
		TLAT=180*THETA/3.14159265
		TLON=180*PHI/3.14159265-180

	end subroutine gsmmagll
************************************************************
	subroutine pitch(DIR,XGSM,YGSM,ZGSM,PA)
		
		dimension PARMOD(10)
		external IGRF_GSM,EXMODEL
		real XX(1000),YY(1000),ZZ(1000)
		R0=1.+100./6371.
		RLIM=60.
		IOPT=1
		call trace(XGSM,YGSM,ZGSM,-DIR,RLIM,R0,IOPT,PARMOD,EXMODEL,
     *			IGRF_GSM,XGSM1,YGSM1,ZGSM1,XX,YY,ZZ,L)
		call trace(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,EXMODEL,
     *			IGRF_GSM,XGSM2,YGSM2,ZGSM2,XX,YY,ZZ,L)
		call IGRF_GSM(XGSM1,YGSM1,ZGSM1,HXGSM1,HYGSM1,HZGSM1)
		H1=sqrt(HXGSM1**2+HYGSM1**2+HZGSM1**2)
		H=1e10
		do i=1,L
			call IGRF_GSM(XX(i),YY(i),ZZ(i),HXGSM2,HYGSM2,HZGSM2)
			H2=sqrt(HXGSM2**2+HYGSM2**2+HZGSM2**2)
			if (H.gt.H2) then
				H=H2
			endif
		enddo
		if (H1.lt.H) then
			PA=0.
		else
			PA=asin(sqrt(H/H1))
		endif

	end subroutine pitch
************************************************************	
	subroutine EXMODEL(IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
	
		BX=0;
		BY=0;
		BZ=0;

	end subroutine EXMODEL
************************************************************