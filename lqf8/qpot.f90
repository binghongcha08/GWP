      subroutine qpot(r0,Nb,ddv,c,am,p,x,w,u,du)
      use cdat
      implicit real*8(a-h,o-z)
      integer*4,intent(IN) :: Nb
      real*8, intent(OUT) :: du(Nb),u(Nb)      
      integer INFO
      real*8 :: w(Nb),x(Nb),c(nb),p(nb),u2(nb),du2(nb),r0(nb,nb)
      real*8 :: f(2),rx(Nb),ddv(nb),s(2,2),cr(2,1)


! defn = 0d0
      x1 = 0d0
      x2 = 0d0
      do i=1,nb
        an=an+w(i)
        x1=x1+w(i)*x(i)
        x2=x2+w(i)*x(i)**2
      enddo

      b1=-0.5d0*an*an/(an*x2-x1*x1)
      b2 = 0.5d0*x1*an/(an*x2-x1*x1)
      do i=1,Nb
        r=b1*x(i)+b2
        u(i) = -(r*r+b1)/2d0/am
        du(i) = -b1*r/am
      enddo
!ine c matrix 
!        cr(1,1)=-0.5d0
!        cr(2,1)=0d0
!
!! quantum force
!        s=0d0
!        do i=1,Ntraj
!          f=(/x(i),1d0/)
!        do m=1,2
!          do n=1,2
!            s(m,n)=w(i)*f(m)*f(n)+s(m,n)
!          end do
!        end do
!        end do
!
!! calculate matrix c(t)
!        call DPOSV('U',2,1,s,2,cr,2,INFO)
!        if(INFO/=0) then
!        print *, "info=",info
!        print *, "QPOT: matrix fails"
!        stop
!        end if
!
!! the momentum operator r=cf
!        do i=1,Ntraj
!          rx(i)=cr(1,1)*x(i)+cr(2,1)
!
!! calculate quantum potential
!          u(i)=-rx(i)**2/(2d0*am)-cr(1,1)/(2d0*am)
!          du(i)=-rx(i)*cr(1,1)/am
!        end do
!      u = 0d0
!      du = 0d0
      call rep(nb,w,r0,x,p,u2,du2)
      u2 = 0d0
      du2 = 0d0
      do i=1,nb
        u(i) = u(i)+u2(i)
        du(i) = du(i)+du2(i)
      enddo

      return
      end subroutine

!------------------------------------------------------
!------extra repulsion added like quantum potential
!----------------------------------------------------
      subroutine rep(nb,w,r0,x,p,u2,du2)
      use cdat
      implicit real*8(a-h,o-z)
      real*8 x(nb),p(nb),dxp(nb),r0(nb,nb),w(nb),u2(nb),du2(nb)
      ww = 0d0
      do i=1,nb
        ww = w(i)+ww
      enddo

      u2 = 0d0
      du2 = 0d0

      do i=1,nb
        do j=1,nb
!          if(j /= i) then
          r = x(j)-x(i)
          if(r .ne. 0d0) then
          r = r/abs(r0(i,j))
!          u2(i) = u2(i)+w(i)/abs(dr)
          du2(i) = du2(i)+dsign(1d0,r)*0.2d0*exp(-4d0*abs(r))/r**2*w(j)/ww
!          du2(i) = du2(i)-1d0/r**2
          endif
        enddo 
      enddo
      write(*,*) (du2(i),i=1,6)      
      return
      end subroutine