CODE SEGMENT CALCOM
C----------
C  **CALCOM DATE OF LAST REVISION:  02/29/07
C----------
      INTEGER ISPHAB,ISPFOR,ISPDSQ,ISPCCF,IRHHAB,ICRHAB,NCALHT
      REAL    REGCH,POTEN,HGHCH,REIN(2),GMULT(2),FNMIN
      COMMON / CALCOM /  ISPHAB,ISPFOR,ISPDSQ,ISPCCF,REGCH,IRHHAB,
     &                   POTEN,HGHCH,REIN,GMULT,ICRHAB,FNMIN,NCALHT
C----------
C  DEFINITIONS OF VARIABLES IN 'CALCOM' COMMON BLOCK:
C----------
C
C    FNMIN  -- MINIMUM DIA. GROWTH OBSERVATIONS PER SPECIES TO
C              CALIBRATE LARGE TREE DIAMETER INCREMENT MODEL FOR
C              LOCAL CONDITIONS - USED IN DGDRIV ROUTINES
C    NCALHT -- MINIMUM NUMBER OF HEIGHT GROWHT OBSERVATIONS TO
C              CALIBRATE THE SMALL TREE HEIGHT INCREMENT MODEL FOR
C              LOCAL CONDITIONS - USED IN REGENT ROUTINES
C-----END SEGMENT
