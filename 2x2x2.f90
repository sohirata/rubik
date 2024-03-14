MODULE RUBIK

   INTEGER(4),PARAMETER :: N=7*6*5*4*3*2*1*(3**6)
   INTEGER(16) :: LIST(1:N),SUBLIST(1:N),NEWLIST(1:N)
   INTEGER(16) :: TURN(1:N),SUBTURN(1:N),NEWTURN(1:N)
   INTEGER(4)  :: DIST(1:N)
   INTEGER(4)  :: ILIST,ISUB,INEW
   INTEGER(4)  :: NTURN

END MODULE



PROGRAM RUBIK_2X2X2
! BLANKET ENUMERATION OF 2X2X2 RUBIK'S CUBE CONFIGURATIONS.
! SO HIRATA, UNIVERSITY OF ILLINOIS AT URBANA-CHAMPAIGN, JANUARY 2024.

   USE RUBIK

   IMPLICIT NONE

   INTERFACE
      INTEGER FUNCTION IEXIST(CONFIG)
         INTEGER(16) :: CONFIG
      END FUNCTION
   END INTERFACE

   INTEGER(4)  :: I,J,K,L
!  INTEGER(8)  :: JJ
!  INTEGER(16) :: JJJ
   REAL :: START,FINISH,S2,F2
   INTEGER(4),PARAMETER :: MAXSTEPS=50
   INTEGER(4)           :: ALGORITHM   ! 1 SORTED; 2 UNSORTED
!  INTEGER(4),PARAMETER :: ALGORITHM=2 ! 1 SORTED; 2 UNSORTED
   INTEGER(4)           :: METRIC   ! 1 QUARTER-TURN; 2 HALF-TURN; 3 SEMI-QUARTER-TURN; 4 TWO-QUARTER-TURN
!  INTEGER(4),PARAMETER :: METRIC=4 ! 1 QUARTER-TURN; 2 HALF-TURN; 3 SEMI-QUARTER-TURN; 4 TWO-QUARTER-TURN
   INTEGER(16) :: ICONFIG,JCONFIG,IROTATE,JROTATE
   INTEGER(4)  :: ICUBOID(1:21),JCUBOID(1:21),KCUBOID(1:21)
   INTEGER(4)  :: ISTEP,ITURN,JSTEP
   INTEGER(4)  :: IDIST,DISTSUM
   INTEGER(4)  :: IFOUND(0:MAXSTEPS),JFOUND
   INTEGER(4)  :: TURNSTAT(1:100,0:MAXSTEPS)

   WRITE(6,'(A)') "2X2X2 RUBIK'S CUBE CONFIGURATION GENERATION"
   WRITE(6,'(A)') '1: QUARTER-TURN METRIC; 2: HALF-TURN METRIC; 3: SEMI-QUARTER-TURN METRIC; 4: TWO-QUARTER-TURN METRIC'
   READ(5,*) METRIC
   IF (METRIC==1) THEN
    WRITE(6,'(A)') 'QUARTER-TURN METRIC'
   ELSE IF (METRIC==2) THEN
    WRITE(6,'(A)') 'HALF-TURN METRIC'
   ELSE IF (METRIC==3) THEN
    WRITE(6,'(A)') 'SEMI-QUARTER-TURN METRIC'
   ELSE IF (METRIC==4) THEN
    WRITE(6,'(A)') 'TWO-QUARTER-TURN METRIC'
   ELSE
    WRITE(6,'(A)') 'ILLEGAL METRIC'
    STOP
   ENDIF
   WRITE(6,'(A)') '1: BISECTION SEARCH IN SORTED LIST; 2: SEQUENTIAL SEARCH IN UNSORTED LIST'
   READ(5,*) ALGORITHM
   IF (ALGORITHM==1) THEN
    WRITE(6,'(A)') 'BISECTION SEARCH IN SORTED LIST'
   ELSE IF (ALGORITHM==2) THEN
    WRITE(6,'(A)') 'SEQUENTIAL SEARCH IN UNSORTED LIST'
   ELSE
    WRITE(6,'(A)') 'ILLEGAL ALGORITHM'
    STOP
   ENDIF
!  WRITE(6,'(A)') 'INTEGER(4), (8), (16) CHECK'
!  J=1
!  JJ=1
!  JJJ=1
!  DO I=1,50
!   J=J*10
!   JJ=JJ*10
!   JJJ=JJJ*10
!   WRITE(6,*) J,JJ,JJJ
!  ENDDO

   WRITE(6,'(A,I0)') 'TOTAL NUMBER OF CONFIGURATIONS = ',N

   ! TEST SPLIT
!  ICONFIG=111222333444455556666
!  CALL SPLIT(ICONFIG,ICUBOID)
!  WRITE(6,'(I0,A,21(I2))') ICONFIG,'SPLIT',(ICUBOID(I),I=1,21)
!  ! TEST COMBINE
!  CALL COMBINE(JCONFIG,ICUBOID)
!  WRITE(6,'(A,I0)') 'COMBINED',JCONFIG
!  ! TEST R
!  CALL R(ICUBOID,JCUBOID,.TRUE.)
!  CALL COMBINE(JCONFIG,JCUBOID)
!  WRITE(6,'(I0,A,I0)') ICONFIG,' R ',JCONFIG
!  ! TEST R'
!  CALL R(JCUBOID,ICUBOID,.FALSE.)
!  CALL COMBINE(ICONFIG,ICUBOID)
!  WRITE(6,'(I0,A,I0)') JCONFIG,' R^PRIME ',ICONFIG

   LIST=0
   DIST=0
   SUBLIST=0
   SUBTURN=0
   TURN=0

   ! INITIAL CONFIGURATION
   ISTEP=0
   ICONFIG=111222333444455556666
   IROTATE=0
   LIST(1)=ICONFIG
   DIST(1)=0
   ILIST=1
   SUBLIST(1)=ICONFIG
   SUBTURN(1)=IROTATE
   ISUB=1
   INEW=0
   WRITE(6,'(3(A,I10))') 'STEP ',ISTEP,' NEW CONFIGS ',1,' CUMMULATIVE CONFIGS ',ILIST

   DO ISTEP=1,MAXSTEPS
    CALL CPU_TIME(START)
    CALL CPU_TIME(S2)
    NEWLIST=0
    NEWTURN=0
    INEW=0
    IFOUND=0
    DO I=1,ISUB
!    IF (ISUB > 100000) THEN
!     IF (MOD(I,10000)==0) THEN
!      CALL CPU_TIME(F2)
!      WRITE(6,'(A,I8,A,F20.3)') '    SEED CONFIGS ',I,' CPU TIME ',F2-S2
!      CALL CPU_TIME(S2)
!     ENDIF
!    ENDIF
     ICONFIG=SUBLIST(I)
     IROTATE=SUBTURN(I)
     CALL SPLIT(ICONFIG,ICUBOID)
!    QUARTER-TURN METRIC
     IF (METRIC==1) THEN
      NTURN=6
      DO ITURN=1,NTURN
       IF (ITURN==1) CALL R(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==2) CALL R(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==3) CALL D(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==4) CALL D(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==5) CALL B(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==6) CALL B(ICUBOID,JCUBOID,.FALSE.)
       CALL COMBINE(JCONFIG,JCUBOID)
       CALL ROTATE(IROTATE,JROTATE,ITURN)
       IF (ALGORITHM==1) THEN
        IDIST=ISTEP
        CALL BISECTION(JCONFIG,IDIST,JROTATE)
        IF (IDIST==-1) THEN
         INEW=INEW+1
         IF (INEW > N) THEN 
          WRITE(6,'(A)') 'ERROR 1'
          STOP
         ENDIF
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(IDIST)=IFOUND(IDIST)+1
        ENDIF 
       ELSE IF (ALGORITHM==2) THEN
        JFOUND=IEXIST(JCONFIG)
        IF (JFOUND==0) THEN
         ILIST=ILIST+1
         IF (ILIST > N) THEN
          WRITE(6,'(A)') 'ERROR 2'
          STOP
         ENDIF
         LIST(ILIST)=JCONFIG
         DIST(ILIST)=ISTEP
         TURN(ILIST)=JROTATE
         INEW=INEW+1
         IF (INEW > N) THEN
          WRITE(6,'(A)') 'ERROR 3'
          STOP
         ENDIF
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(DIST(JFOUND))=IFOUND(DIST(JFOUND))+1
        ENDIF 
       ENDIF 
      ENDDO
!    HALF-TURN METRIC
     ELSE IF (METRIC==2) THEN
      NTURN=9
      DO ITURN=1,NTURN
       IF (ITURN==1) CALL R(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==2) THEN
        CALL R(ICUBOID,KCUBOID,.TRUE.)
        CALL R(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==3) CALL R(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==4) CALL D(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==5) THEN
        CALL D(ICUBOID,KCUBOID,.TRUE.)
        CALL D(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==6) CALL D(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==7) CALL B(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==8) THEN
        CALL B(ICUBOID,KCUBOID,.TRUE.)
        CALL B(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==9) CALL B(ICUBOID,JCUBOID,.FALSE.)
       CALL COMBINE(JCONFIG,JCUBOID)
       CALL ROTATE(IROTATE,JROTATE,ITURN)
       IF (ALGORITHM==1) THEN
        IDIST=ISTEP
        CALL BISECTION(JCONFIG,IDIST,JROTATE)
        IF (IDIST==-1) THEN
         INEW=INEW+1
         IF (INEW > N) THEN 
          WRITE(6,'(A)') 'ERROR 1'
          STOP 
         ENDIF 
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(IDIST)=IFOUND(IDIST)+1
        ENDIF  
       ELSE IF (ALGORITHM==2) THEN
        JFOUND=IEXIST(JCONFIG)
        IF (JFOUND==0) THEN
         ILIST=ILIST+1
         IF (ILIST > N) THEN
          WRITE(6,'(A)') 'ERROR 5'
          STOP
         ENDIF
         LIST(ILIST)=JCONFIG
         DIST(ILIST)=ISTEP
         TURN(ILIST)=JROTATE
         INEW=INEW+1
         IF (INEW > N) THEN
          WRITE(6,'(A)') 'ERROR 6'
          STOP
         ENDIF
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(DIST(JFOUND))=IFOUND(DIST(JFOUND))+1
        ENDIF 
       ENDIF
      ENDDO
     ! SEMI-QUARTER-TURN METRIC
     ELSE IF (METRIC==3) THEN
      NTURN=3
      DO ITURN=1,NTURN
       IF (ITURN==1) CALL R(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==2) CALL D(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==3) CALL B(ICUBOID,JCUBOID,.TRUE.)
       CALL COMBINE(JCONFIG,JCUBOID)
       CALL ROTATE(IROTATE,JROTATE,ITURN)
       IF (ALGORITHM==1) THEN
        IDIST=ISTEP
        CALL BISECTION(JCONFIG,IDIST,JROTATE)
        IF (IDIST==-1) THEN
         INEW=INEW+1
         IF (INEW > N) THEN 
          WRITE(6,'(A)') 'ERROR 1'
          STOP 
         ENDIF 
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(IDIST)=IFOUND(IDIST)+1
        ENDIF  
       ELSE IF (ALGORITHM==2) THEN
        JFOUND=IEXIST(JCONFIG)
        IF (JFOUND==0) THEN
         ILIST=ILIST+1
         IF (ILIST > N) THEN
          WRITE(6,'(A)') 'ERROR 8'
          STOP
         ENDIF
         LIST(ILIST)=JCONFIG
         DIST(ILIST)=ISTEP
         TURN(ILIST)=JROTATE
         INEW=INEW+1
         IF (INEW > N) THEN
          WRITE(6,'(A)') 'ERROR 9'
          STOP
         ENDIF
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(DIST(JFOUND))=IFOUND(DIST(JFOUND))+1
        ENDIF 
       ENDIF
      ENDDO
     ! TWO-QUARTER-TURN METRIC
     ELSE IF (METRIC==4) THEN
      NTURN=15
      DO ITURN=1,NTURN
       IF (ITURN==1) THEN
        CALL R(ICUBOID,KCUBOID,.TRUE.)
        CALL R(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==2) THEN
        CALL D(ICUBOID,KCUBOID,.TRUE.)
        CALL D(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==3) THEN
        CALL B(ICUBOID,KCUBOID,.TRUE.)
        CALL B(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==4) THEN
        CALL R(ICUBOID,KCUBOID,.TRUE.)
        CALL D(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==5) THEN
        CALL R(ICUBOID,KCUBOID,.FALSE.)
        CALL D(KCUBOID,JCUBOID,.FALSE.)
       ENDIF
       IF (ITURN==6) THEN
        CALL D(ICUBOID,KCUBOID,.TRUE.)
        CALL B(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==7) THEN
        CALL D(ICUBOID,KCUBOID,.FALSE.)
        CALL B(KCUBOID,JCUBOID,.FALSE.)
       ENDIF
       IF (ITURN==8) THEN
        CALL B(ICUBOID,KCUBOID,.TRUE.)
        CALL R(KCUBOID,JCUBOID,.TRUE.)
       ENDIF
       IF (ITURN==9) THEN
        CALL B(ICUBOID,KCUBOID,.FALSE.)
        CALL R(KCUBOID,JCUBOID,.FALSE.)
       ENDIF
       IF (ITURN==10) CALL R(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==11) CALL R(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==12) CALL D(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==13) CALL D(ICUBOID,JCUBOID,.FALSE.)
       IF (ITURN==14) CALL B(ICUBOID,JCUBOID,.TRUE.)
       IF (ITURN==15) CALL B(ICUBOID,JCUBOID,.FALSE.)
       CALL COMBINE(JCONFIG,JCUBOID)
       CALL ROTATE(IROTATE,JROTATE,ITURN)
       IF (ALGORITHM==1) THEN
        IDIST=ISTEP
        CALL BISECTION(JCONFIG,IDIST,JROTATE)
        IF (IDIST==-1) THEN
         INEW=INEW+1
         IF (INEW > N) THEN 
          WRITE(6,'(A)') 'ERROR 1'
          STOP 
         ENDIF 
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(IDIST)=IFOUND(IDIST)+1
        ENDIF  
       ELSE IF (ALGORITHM==2) THEN
        JFOUND=IEXIST(JCONFIG)
        IF (JFOUND==0) THEN
         ILIST=ILIST+1
         IF (ILIST > N) THEN
          WRITE(6,'(A)') 'ERROR 11'
          STOP
         ENDIF
         LIST(ILIST)=JCONFIG
         DIST(ILIST)=ISTEP
         TURN(ILIST)=JROTATE
         INEW=INEW+1
         IF (INEW > N) THEN
          WRITE(6,'(A)') 'ERROR 6'
          STOP
         ENDIF
         NEWLIST(INEW)=JCONFIG
         NEWTURN(INEW)=JROTATE
        ELSE
         IFOUND(DIST(JFOUND))=IFOUND(DIST(JFOUND))+1
        ENDIF
       ENDIF
      ENDDO
     ENDIF
    ENDDO
    IF (INEW==0) THEN
     IF (ILIST==N) THEN
      EXIT
     ELSE
      WRITE(6,'(A,I0)') 'ILLEGAL TERMINATION WITH CUMMULATIVE CONFIGURATIONS ',ILIST
      EXIT
     ENDIF
    ENDIF
    CALL CPU_TIME(FINISH)
    WRITE(6,'(3(A,I10),A,F20.3)') 'STEP ',ISTEP,' NEW CONFIGS ',INEW,' CUMMULATIVE CONFIGS ',ILIST,' CPU TIME ',FINISH-START
    DISTSUM=INEW
    DO JSTEP=0,ISTEP
     WRITE(6,'(A,I0,A,I0)') 'DISTANCE ',JSTEP,' FOUND ',IFOUND(JSTEP)
     DISTSUM=DISTSUM+IFOUND(JSTEP)
    ENDDO
    IF (DISTSUM/=ISUB*NTURN) THEN
     WRITE(6,*) 'ERROR IN DISTANCE CALC',DISTSUM,ISUB*NTURN
    ELSE
     WRITE(6,'(A,I0,A,I0,A,I0)') 'SUM ',DISTSUM,' = ',NTURN,' X ',ISUB
    ENDIF
    ISUB=INEW
    SUBLIST=NEWLIST
    SUBTURN=NEWTURN
   ENDDO
   CALL CPU_TIME(FINISH)

   WRITE(6,'(A)') 'POST-ENUMERATION ANALYSIS'
   IF (ILIST/=N) THEN
    WRITE(6,'(A,I0,A,I0)') 'ILLEGAL COMPLETION:',ILIST,'/=',N
    WRITE(6,'(A)') 'RADIUS NOT DETERMINED'
   ELSE
    WRITE(6,'(A,I0)') 'RADIUS = ',ISTEP-1
   ENDIF
   TURNSTAT=0
   DO I=1,ILIST
    DO J=1,ISTEP-1
     IF (TURN(I)==0) THEN
      CYCLE
     ELSE
      ITURN=TURN(I)-(TURN(I)/(NTURN+1))*(NTURN+1)
      IF ((ITURN < 1).OR.(ITURN > NTURN)) THEN
       WRITE(6,'(A,I0)') 'ERROR:',ITURN
       STOP
      ENDIF
     ENDIF
     TURNSTAT(ITURN,DIST(I))=TURNSTAT(ITURN,DIST(I))+1
     TURN(I)=TURN(I)/(NTURN+1)
    ENDDO
   ENDDO
   L=0
   DO I=0,ISTEP-1
    WRITE(6,'(A,I0)') 'DISTANCE ',I
    K=0
    DO J=1,NTURN
     WRITE(6,'(3X,I0,A,I0)') J,'-TURN ',TURNSTAT(J,I)
     K=K+TURNSTAT(J,I)
    ENDDO 
    WRITE(6,'(3X,A,I0)') 'SUM ',K
    L=L+K
   ENDDO
   WRITE(6,'(A,I0)') 'SUM ',L
   WRITE(6,'(A)') 'TOTAL'
   L=0
   DO J=1,NTURN
    K=0
    DO I=0,ISTEP-1
     K=K+TURNSTAT(J,I)
    ENDDO 
    WRITE(6,'(3X,I0,A,I0)') J,'-TURN ',K
    L=L+K
   ENDDO
   WRITE(6,'(A,I0)') 'SUM ',L
   L=0
   DO J=1,ILIST
    L=L+DIST(J)
   ENDDO
   WRITE(6,'(A,I0)') 'SUM ',L

   J=METRIC*10+ALGORITHM
   WRITE(6,'(A,I2,A)') 'fort.',J,' CONTAINS I,LIST(I),DIST(I),TURN(I)'
   WRITE(J,'(A,I0)') 'N = ',N
   WRITE(J,'(A,I0)') 'NTURN = ',NTURN
   WRITE(J,'(A,I0)') 'RADIUS = ',ISTEP-1
   DO I=1,ILIST
    WRITE(J,'(4I0)') I,LIST(I),DIST(I),TURN(I)
   ENDDO

END PROGRAM



SUBROUTINE SPLIT(CONFIG,CUBOID)
! SPLIT INTEGER16 COLOR STRING INTO INDIVIDUAL CUBOID COLORS

   IMPLICIT NONE
   INTEGER(16) :: CONFIG,CONFIG_TMP
   INTEGER(4)  :: CUBOID(1:21)
   INTEGER(4)  :: I,J

   CONFIG_TMP=CONFIG
   DO I=21,1,-1
    CUBOID(I)=CONFIG_TMP-CONFIG_TMP/10*10
    CONFIG_TMP=CONFIG_TMP/10
   ENDDO
   RETURN

END SUBROUTINE



SUBROUTINE COMBINE(CONFIG,CUBOID)
! COMBINE INDIVIDUAL CUBOID COLORS TO INTEGER16 COLOR STRING

   IMPLICIT NONE
   INTEGER(16) :: CONFIG
   INTEGER(4)  :: CUBOID(1:21)
   INTEGER(4)  :: I,J

   CONFIG=0
   DO I=1,21
    CONFIG=CONFIG*10
    CONFIG=CONFIG+CUBOID(I)
   ENDDO
   RETURN

END SUBROUTINE



SUBROUTINE R(ICUBOID,JCUBOID,LPRIME)
! PERFORM RIGHT LAYER ROTATE BY 90 DEGREES
!        4  5
!        U  6
!  7  L  F  1 10 11 18 19
!  9  8  2  3 13 12 21 20
!       14 15
!       17 16
!
! 1->5;3->6;5->20;6->19;19->16;20->15;15->1;16->3;10->11;11->12;12->13;13->10 

   IMPLICIT NONE
   INTEGER(4)  :: ICUBOID(1:21)
   INTEGER(4)  :: JCUBOID(1:21)
   LOGICAL     :: LPRIME ! TRUE CLOCKWISE; FALSE COUNTERCLOCKWISE

   JCUBOID=ICUBOID

   IF (LPRIME) THEN
    JCUBOID( 5)=ICUBOID( 1)
    JCUBOID( 6)=ICUBOID( 3)
    JCUBOID(21)=ICUBOID( 5)
    JCUBOID(18)=ICUBOID( 6)
    JCUBOID(16)=ICUBOID(18)
    JCUBOID(15)=ICUBOID(21)
    JCUBOID( 1)=ICUBOID(15)
    JCUBOID( 3)=ICUBOID(16)
    JCUBOID(11)=ICUBOID(10)
    JCUBOID(12)=ICUBOID(11)
    JCUBOID(13)=ICUBOID(12)
    JCUBOID(10)=ICUBOID(13)
   ELSE
    JCUBOID( 1)=ICUBOID( 5)
    JCUBOID( 3)=ICUBOID( 6)
    JCUBOID( 5)=ICUBOID(21)
    JCUBOID( 6)=ICUBOID(18)
    JCUBOID(18)=ICUBOID(16)
    JCUBOID(21)=ICUBOID(15)
    JCUBOID(15)=ICUBOID( 1)
    JCUBOID(16)=ICUBOID( 3)
    JCUBOID(10)=ICUBOID(11)
    JCUBOID(11)=ICUBOID(12)
    JCUBOID(12)=ICUBOID(13)
    JCUBOID(13)=ICUBOID(10)
   ENDIF
   RETURN

END SUBROUTINE



SUBROUTINE D(ICUBOID,JCUBOID,LPRIME)
! PERFORM DOWN LAYER ROTATE BY 90 DEGREES
!        4  5
!        U  6
!  7  L  F  1 10 11 18 19
!  9  8  2  3 13 12 21 20
!       14 15
!       17 16
!
! 2->13;3->12;13->21;12->20;21->9;20->8;9->2;8->3;14->15;15->16;16->17;17->14 

   IMPLICIT NONE
   INTEGER(4)  :: ICUBOID(1:21)
   INTEGER(4)  :: JCUBOID(1:21)
   LOGICAL     :: LPRIME ! TRUE CLOCKWISE; FALSE COUNTERCLOCKWISE

   JCUBOID=ICUBOID

   IF (LPRIME) THEN
    JCUBOID(13)=ICUBOID( 2)
    JCUBOID(12)=ICUBOID( 3)
    JCUBOID(21)=ICUBOID(13)
    JCUBOID(20)=ICUBOID(12)
    JCUBOID( 9)=ICUBOID(21)
    JCUBOID( 8)=ICUBOID(20)
    JCUBOID( 2)=ICUBOID( 9)
    JCUBOID( 3)=ICUBOID( 8)
    JCUBOID(15)=ICUBOID(14)
    JCUBOID(16)=ICUBOID(15)
    JCUBOID(17)=ICUBOID(16)
    JCUBOID(14)=ICUBOID(17)
   ELSE
    JCUBOID( 2)=ICUBOID(13)
    JCUBOID( 3)=ICUBOID(12)
    JCUBOID(13)=ICUBOID(21)
    JCUBOID(12)=ICUBOID(20)
    JCUBOID(21)=ICUBOID( 9)
    JCUBOID(20)=ICUBOID( 8)
    JCUBOID( 9)=ICUBOID( 2)
    JCUBOID( 8)=ICUBOID( 3)
    JCUBOID(14)=ICUBOID(15)
    JCUBOID(15)=ICUBOID(16)
    JCUBOID(16)=ICUBOID(17)
    JCUBOID(17)=ICUBOID(14)
   ENDIF
   RETURN

END SUBROUTINE



SUBROUTINE B(ICUBOID,JCUBOID,LPRIME)
! PERFORM BACK LAYER ROTATE BY 90 DEGREES
!        4  5
!        U  6
!  7  L  F  1 10 11 18 19
!  9  8  2  3 13 12 21 20
!       14 15
!       17 16
!
! 5->7;4->9;7->17;9->16;17->12;16->11;12->5;11->4;18->19;19->20;20->21;21->18

   IMPLICIT NONE
   INTEGER(4)  :: ICUBOID(1:21)
   INTEGER(4)  :: JCUBOID(1:21)
   LOGICAL     :: LPRIME ! TRUE CLOCKWISE; FALSE COUNTERCLOCKWISE

   JCUBOID=ICUBOID

   IF (LPRIME) THEN
    JCUBOID( 7)=ICUBOID( 5)
    JCUBOID( 9)=ICUBOID( 4)
    JCUBOID(17)=ICUBOID( 7)
    JCUBOID(16)=ICUBOID( 9)
    JCUBOID(12)=ICUBOID(17)
    JCUBOID(11)=ICUBOID(16)
    JCUBOID( 5)=ICUBOID(12)
    JCUBOID( 4)=ICUBOID(11)
    JCUBOID(19)=ICUBOID(18)
    JCUBOID(20)=ICUBOID(19)
    JCUBOID(21)=ICUBOID(20)
    JCUBOID(18)=ICUBOID(21)
   ELSE
    JCUBOID( 5)=ICUBOID( 7)
    JCUBOID( 4)=ICUBOID( 9)
    JCUBOID( 7)=ICUBOID(17)
    JCUBOID( 9)=ICUBOID(16)
    JCUBOID(17)=ICUBOID(12)
    JCUBOID(16)=ICUBOID(11)
    JCUBOID(12)=ICUBOID( 5)
    JCUBOID(11)=ICUBOID( 4)
    JCUBOID(18)=ICUBOID(19)
    JCUBOID(19)=ICUBOID(20)
    JCUBOID(20)=ICUBOID(21)
    JCUBOID(21)=ICUBOID(18)
   ENDIF
   RETURN

END SUBROUTINE



SUBROUTINE ROTATE(IROTATE,JROTATE,ITURN)

   USE RUBIK

   IMPLICIT NONE
   INTEGER(16) :: IROTATE
   INTEGER(16) :: JROTATE
   INTEGER(4)  :: ITURN

   JROTATE=IROTATE*(NTURN+1)+ITURN

   RETURN

END SUBROUTINE



INTEGER FUNCTION IEXIST(CONFIG)
! RETURN TRUE IF CONFIG EXISTS IN THE LIST

   USE RUBIK

   INTEGER(16) :: CONFIG
   INTEGER(4)  :: I

   ! DEBUG
!  IF (ILIST < 40) THEN
!   WRITE(6,*) 'CONFIG  =',CONFIG
!   WRITE(6,*) 'LIST=',ILIST
!   DO I=1,ILIST
!    WRITE(6,*) LIST(I),(CONFIG==LIST(I))
!   ENDDO
!  ENDIF

   IEXIST=0
   IF (ILIST==0) RETURN
   DO I=1,ILIST
    IF (CONFIG==LIST(I)) THEN
     IEXIST=I
     EXIT
    ENDIF
   ENDDO
   RETURN

END FUNCTION



SUBROUTINE BISECTION(CONFIG,IDIST,ROTATION)
! SEARCH CONFIG IN THE SORTED LIST AND IF NOT FOUND INSERT CONFIG IN THE LIST

   USE RUBIK

   INTEGER(16) :: CONFIG,ROTATION
   INTEGER(4)  :: IDIST
   INTEGER(4)  :: I,J
   INTEGER(4)  :: IMIN,IMAX,IMID
   INTEGER(4)  :: JDIST

   ! DEBUG
!  WRITE(6,*) 'BISECTION-SEARCH-SORTED-INSERTION TO'
!  DO I=1,ILIST
!   WRITE(6,*) I,LIST(I)
!  ENDDO
!  WRITE(6,*) 'CONFIG ',CONFIG

   JDIST=IDIST

   IF (ILIST==1) THEN
    IF (CONFIG==LIST(1)) THEN
     IDIST=DIST(1)
    ELSE
     IDIST=-1
     ILIST=ILIST+1
     LIST(ILIST)=CONFIG
     DIST(ILIST)=JDIST
     TURN(ILIST)=ROTATION
    ENDIF
    RETURN
   ENDIF

   IMIN=1
   IMAX=ILIST
   IMID=(IMIN+IMAX)/2

   DO WHILE(.TRUE.)
    IF (CONFIG==LIST(IMAX)) THEN
     IDIST=DIST(IMAX)
     EXIT
    ELSE IF (CONFIG > LIST(IMAX)) THEN
     IDIST=-1
     ILIST=ILIST+1
     LIST(ILIST)=CONFIG
     DIST(ILIST)=JDIST
     TURN(ILIST)=ROTATION
     EXIT
    ELSE IF (CONFIG==LIST(IMID)) THEN
     IDIST=DIST(IMID)
     EXIT
    ELSE IF (CONFIG > LIST(IMID)) THEN
     IF (IMID+1==IMAX) THEN
      IDIST=-1
      DO I=ILIST,IMAX,-1
       LIST(I+1)=LIST(I)
       DIST(I+1)=DIST(I)
       TURN(I+1)=TURN(I)
      ENDDO
      LIST(IMID+1)=CONFIG
      DIST(IMID+1)=JDIST
      TURN(IMID+1)=ROTATION
      ILIST=ILIST+1
      EXIT
     ELSE
      IMIN=IMID
      IMID=(IMIN+IMAX)/2
     ENDIF
    ELSE IF (CONFIG==LIST(IMIN)) THEN
     IDIST=DIST(IMIN)
     EXIT
    ELSE IF (IMIN+1==IMID) THEN
     IDIST=-1
     DO I=ILIST,IMID,-1
      LIST(I+1)=LIST(I)
      DIST(I+1)=DIST(I)
      TURN(I+1)=TURN(I)
     ENDDO
     LIST(IMIN+1)=CONFIG
     DIST(IMIN+1)=JDIST
     TURN(IMIN+1)=ROTATION
     ILIST=ILIST+1
     EXIT
    ELSE
     IMAX=IMID
     IMID=(IMIN+IMAX)/2
    ENDIF
   ENDDO

   RETURN

END SUBROUTINE
