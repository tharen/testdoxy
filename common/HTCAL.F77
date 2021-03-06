CODE SEGMENT HTCAL
C----------
C  **HTCAL  DATE OF LAST REVISION:  06/14/00
C----------
      LOGICAL LHCOR2,LHTCAL(MAXSP)
      REAL    FINTH,HCOR2(MAXSP),HSIG(MAXSP)
      INTEGER IFINTH,IHTG
      COMMON /HTCAL/ FINTH,HCOR2,HSIG,IFINTH,IHTG,LHCOR2,LHTCAL
C----------
C  HEIGHT GROWTH CALIBRATION COMMON /HTCAL/
C----------
C     FINTH = MEASURMENT PERIOD FOR SMALL TREE HEIGHT GROWTH.
C     HCOR2 = USER SUPPLIED CORRECTION TERMS...TO CORRECT THE
C             HEIGHT GROWTH MODELS PRIOR TO CALIBRATION.
C     HSIG  = DUMMY...MAY BE USED FOR SIGMAS.
C     IFINTH= INTEGER VERSION OF FINTH.
C     IHTG  = THE HEIGHT GROWTH VERSION OF IDG.
C     LHCOR2= TRUE IF HCOR2 IS TO BE USED TO MODIFY HEIGHT GROWTH
C             MODELS. SET FALSE IN GRINIT.
C     LHTCAL= TRUE IF HEIGHT GROWTH CALIBRATION IS TO BE DONE,
C             SET TRUE IN GRINIT.
C-----END SEGMENT
