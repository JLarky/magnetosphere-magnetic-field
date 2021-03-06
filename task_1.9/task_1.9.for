      program task9
        call convert("C1_CP_FGM_SPIN_6145.dat", "cluster1.dat")
        call convert("C3_CP_FGM_SPIN_6145.dat", "cluster3.dat")
      end program

      subroutine convert(input, output)
        character input*(*), output*(*)
        external t96_01
        real parmod(10),nx,ny,nz,nr,mx,my,mz,mr,lx,ly,lz,hours
        common /geopack1/ps
		
        open(1,file=input)
        open(2,file=output)
	
        l=0
        do
123       format(i2,1x,i2,1x,i4,1x, i2,1x,i2,1x,i2,4x,6f23.8)
          read (1,123,end=34,err=35) iday,mon,iyear,ihour,min,isec,
     *         bxgse,bygse,bzgse, xkm,ykm,zkm
          l=l+1
          re=6400
          xgse=xkm/re
          ygse=ykm/re
          zgse=zkm/re
          
          xn_pd=2.
          byimf=0.
          bzimf=0.
          dst=-15.
          hours=ihour+(min/60.)+(isec/3600.)
          iday = iday + 59      ! march
          
          call recalc(iyear,iday,ihour,min,isec)
          call gsmgse(xgsm,ygsm,zgsm,xgse,ygse,zgse,-1)
          call gsmgse(bxgsm,bygsm,bzgsm,bxgse,bygse,bzgse,-1)
          
          call shuetal_mgnp(xn_pd,-1.,bzimf,xgsm,ygsm,zgsm,
     *         xmgnp,ymgnp,zmgnp,dist,id) ! {xmgnp,ymgnp,zmgnp} magnetopause nearest point
        ! should we go into magnetosphere?
        ! xmgnp = xmgnp*0.99
        ! ymgnp = ymgnp*0.99
        ! zmgnp = zmgnp*0.99
          
          call dip(xmgnp,ymgnp,zmgnp,bxgsm_dip,bygsm_dip,bzgsm_dip)
          iopt=1.
          parmod(1)=xn_pd
          parmod(2)=dst
          parmod(3)=byimf
          parmod(4)=bzimf
          call t96_01(iopt,parmod,ps,xmgnp,ymgnp,zmgnp,bx,by,bz)
        
          bxmgnp=bxgsm_dip+bx
          bymgnp=bygsm_dip+by
          bzmgnp=bzgsm_dip+bz

        ! magnetopause normal vector (n)
          nx=xmgnp-xgsm
          ny=ymgnp-ygsm
          nz=zmgnp-zgsm
        ! normalization
          nr = sqrt(nx**2+ny**2+nz**2)
          nx = nx/nr
          ny = ny/nr
          nz = nz/nr
          
        ! vector multiplication of B and n (m)
          mx = ny*bzmgnp-nz*bymgnp
          my = nz*bxmgnp-nx*bzmgnp
          mz = nx*bymgnp-ny*bxmgnp
        ! normalization
          mr = sqrt(mx**2+my**2+mz**2)
          mx = mx/mr
          my = my/mr
          mz = mz/mr

        ! vector parallel to B (l)
          lx = my*nz-mz*ny
          ly = mz*nx-mx*nz
          lz = mx*ny-my*nx

        ! vector B in (lmn) coordinates
          bl = lx*bxgsm+ly*bygsm+lz*bzgsm
          bm = mx*bxgsm+my*bygsm+mz*bzgsm
          bn = nx*bxgsm+ny*bygsm+nz*bzgsm
        
          br = sqrt(bl**2+bm**2+bn**2)
          brgse = sqrt(bxgsm**2+bygsm**2+bzgsm**2)

          write (2,*) hours,bl,bm,bn,br,bxgse,bygse,bzgse,brgse
          
        end do
 35     print *, 'error l=', l
        stop 5
 34     print *, 'end of file l=', l
        
        close (1)
        close (2)
      end subroutine
