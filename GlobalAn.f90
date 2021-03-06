!     SUBROUTINE        G  L  O  B  A  N       SUTRA-MS VERSION 2004.1
!                                                                       
! *** PURPOSE :                                                         
! ***  TO ASSEMBLE RESULTS OF ELEMENTWISE INTEGRATIONS INTO             
! ***  A GLOBAL BANDED MATRIX AND GLOBAL VECTOR FOR BOTH                
! ***  FLOW AND TRANSPORT EQUATIONS.                                    
!                                                                       
      SUBROUTINE GLOBAN (L, ML, VOLE, BFLOWE, DFLOWE, BTRANE, DTRANE)
      USE CONTRL 
      USE PARAMS 
      USE DIMS
      USE DIMX
      USE SutraStorage, ONLY : IN,VOL,PMAT,PVEC,UMAT,UVEC
      use SutraMSPrecision
      implicit none
      integer (I4B) :: &
        L, ML
      real (DP) :: &
        BFLOWE (8, 8), DFLOWE (8), BTRANE (8, 8), DTRANE (8, 8), VOLE (8)                                                          
      !locals
      integer (I4B) :: &
        IB, IE, II,  &
        JB, JE, JJ,  &
        N1, N8
!                                                                       
      N1 = (L - 1) * N48 + 1 
      N8 = N1 + N48 - 1 
!                                                                       
!.....ADD RESULTS OF INTEGRATIONS OVER ELEMENT L TO GLOBAL              
!        P-MATRIX AND P-VECTOR                                          
      IF (ML - 1) 9050, 9050, 9150 
 9050 IE = 0 
      DO 9100 II = N1, N8 
         IE = IE+1 
         IB = IN (II) 
         VOL (IB) = VOL (IB) + VOLE (IE) 
         PVEC (IB) = PVEC (IB) + DFLOWE (IE) 
         JE = 0 
         DO 9100 JJ = N1, N8 
            JE = JE+1 
            JB = IN (JJ) - IB + NBHALF 
 9100 PMAT (IB, JB) = PMAT (IB, JB) + BFLOWE (IE, JE) 
      IF (ML - 1) 9150, 9300, 9150 
!                                                                       
!.....ADD RESULTS OF INTEGRATIONS OVER ELEMENT L TO GLOBAL              
!        U-MATRIX                                                       
 9150 IF (NOUMAT.EQ.1) GOTO 9300 
      IE = 0 
      DO 9200 II = N1, N8 
         IE = IE+1 
         IB = IN (II) 
!.....POSITION FOR ADDITION TO U-VECTOR                                 
!     UVEC(IB,KSP)=UVEC(IB,KSP)+ ((   ))                                
         JE = 0 
         DO 9200 JJ = N1, N8 
            JE = JE+1 
            JB = IN (JJ) - IB + NBHALF 
 9200 UMAT (IB, JB) = UMAT (IB, JB) + DTRANE (IE, JE) + BTRANE (IE, JE) 
!                                                                       
 9300 CONTINUE 
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
!                                                                       
!                                                                       
      RETURN 
      END SUBROUTINE GLOBAN                         
