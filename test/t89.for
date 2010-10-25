      program t89_test
c--------------------------------------------------------------------------------
c
c  The small main program below is an example of how to compute field
c   components with T89C.
c    See GEOPACK.DOC for an example of field line tracing.
c

      dimension parmod(10)
      do
       print *, '  enter x,y,z,ps,iopt'
       read*, x,y,z,ps,iopt
       call t89c(iopt,parmod,ps,x,y,z,bx,by,bz)
       print *, bx,by,bz
      end do

c--------------------------------------------------------------------------------
      end program
