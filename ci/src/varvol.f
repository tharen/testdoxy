        SUBROUTINE VARVOL
        IMPLICIT NONE
C----------
C  **VARVOL--CI    DATE OF LAST REVISION:   08/05/11
C----------
C
C  THIS SUBROUTINE CALLS THE APPROPRIATE VOLUME CALCULATION ROUTINE
C  FROM THE NATIONAL CRUISE SYSTEM VOLUME LIBRARY FOR METHB OR METHC
C  EQUAL TO 6.  IT ALSO CONTAINS ANY OTHER SPECIAL VOLUME CALCULATION
C  METHOD SPECIFIC TO A VARIANT (METHB OR METHC = 8)
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
COMMONS
C
C----------
      LOGICAL DEBUG,TKILL,CTKFLG,BTKFLG,LCONE
      CHARACTER*10 NZPEQN(MAXSP),BOIEQN(MAXSP),CHAEQN(MAXSP),
     &             PAYEQN(MAXSP),SALEQN(MAXSP),SAWEQN(MAXSP),R1EQN
      CHARACTER CTYPE*1,FORST*2,HTTYPE,PROD*2,LIVE*1
      CHARACTER*10 VOLEQ
      CHARACTER*10 EQNC,EQNB
      INTEGER IR,I1,I2,IFIASP,IFC,IREGN,I02,I03,I04,I05,ISPC,INTFOR
      INTEGER IERR,IZERO,I01,IT,ITRNC,I0
      INTEGER ERRFLAG,IREG
      REAL LOGLEN(20),BOLHT(21),TVOL(15)
      REAL NLOGS,NLOGSS
      REAL BBFV,VM,VN,DBT,X01,X02,X03,X04,X05,X06,X07,X08,X09,X010
      REAL X011,X012,FC,DBTBH,TVOL1,TVOL4,X0,TDIBB,TDIBC,BRATIO
      REAL VMAX,BARK,H,D,TOPDIB,DRC,TDIB
C----------
C     SPECIES LIST FOR CENTRAL IDAHO VARIANT.
C
C     1 = WESTERN WHITE PINE (WP)          PINUS MONTICOLA
C     2 = WESTERN LARCH (WL)               LARIX OCCIDENTALIS
C     3 = DOUGLAS-FIR (DF)                 PSEUDOTSUGA MENZIESII
C     4 = GRAND FIR (GF)                   ABIES GRANDIS
C     5 = WESTERN HEMLOCK (WH)             TSUGA HETEROPHYLLA
C     6 = WESTERN REDCEDAR (RC)            THUJA PLICATA
C     7 = LODGEPOLE PINE (LP)              PINUS CONTORTA
C     8 = ENGLEMANN SPRUCE (ES)            PICEA ENGELMANNII
C     9 = SUBALPINE FIR (AF)               ABIES LASIOCARPA
C    10 = PONDEROSA PINE (PP)              PINUS PONDEROSA
C    11 = WHITEBARK PINE (WB)              PINUS ALBICAULIS
C    12 = PACIFIC YEW (PY)                 TAXUS BREVIFOLIA
C    13 = QUAKING ASPEN (AS)               POPULUS TREMULOIDES
C    14 = WESTERN JUNIPER (WJ)             JUNIPERUS OCCIDENTALIS
C    15 = CURLLEAF MOUNTAIN-MAHOGANY (MC)  CERCOCARPUS LEDIFOLIUS
C    16 = LIMBER PINE (LM)                 PINUS FLEXILIS
C    17 = BLACK COTTONWOOD (CW)            POPULUS BALSAMIFERA VAR. TRICHOCARPA
C    18 = OTHER SOFTWOODS (OS)
C    19 = OTHER HARDWOODS (OH)
C
C  SURROGATE EQUATION ASSIGNMENT:
C
C  FROM THE IE VARIANT:
C      USE 17(PY) FOR 12(PY)             (IE17 IS REALLY TT2=LM)
C      USE 18(AS) FOR 13(AS)             (IE18 IS REALLY UT6=AS)
C      USE 13(LM) FOR 11(WB) AND 16(LM)  (IE13 IS REALLY TT2=LM)
C      USE 19(CO) FOR 17(CW) AND 19(OH)  (IE19 IS REALLY CR38=OH)
C
C  FROM THE UT VARIANT:
C      USE 12(WJ) FOR 14(WJ)
C      USE 20(MC) FOR 15(MC)             (UT20 = SO30=MC, WHICH IS
C                                                  REALLY WC39=OT)
C----------
C  NATIONAL CRUISE SYSTEM ROUTINES (METHOD = 0)
C----------
      ENTRY NATCRS (VN,VM,BBFV,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,
     1              CTKFLG,BTKFLG,IT)
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'VARVOL',6,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE VARVOL CYCLE =',I5)
C
C----------
C  SET PARAMETERS
C----------
      INTFOR = KODFOR - (KODFOR/100)*100
      WRITE(FORST,'(I2)')INTFOR
      IF(INTFOR.LT.10)FORST(1:1)='0'
      HTTYPE='F'
      IERR=0
      DBT = D*(1-BARK)
C----------
C  BRANCH TO R1 NATCRS LOGIC, OR R4 NATCRS LOGIC.
C----------
      IF(IFOR.NE.1) GO TO 100
C----------
C  REGION 1 NATCRS SEQUENCE
C----------
      DO 10 IZERO=1,15
      TVOL(IZERO)=0.
   10 CONTINUE
      TOPDIB=TOPD(ISPC)*BARK
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS
C----------
      I01=0
      I02=0
      I03=0
      I04=0
      I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS
C----------
      X01=0.
      X02=0.
      X03=0.
      X04=0.
      X05=0.
      X06=0.
      X07=0.
      X08=0.
      X09=0.
      X010=0.
      X011=0.
      X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS  --  CF FT SECTION
C----------
      CTYPE=' '
C----------
C  CONSTANT INTEGER ARGUMENTS
C----------
      I1= 1
      IREGN= 1
      PROD='01'
      LIVE='L'
C
      IF(VEQNNC(ISPC)(4:6).EQ.'FW2')THEN
        IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE CF ISPC,ARGS = ',
     &    ISPC,IREGN,FORST,VEQNNC(ISPC),TOPD(ISPC),STMP(ISPC),D,H,
     &    DBT,BARK
C
        CALL PROFILE (IREGN,FORST,VEQNNC(ISPC),TOPDIB,X01,STMP(ISPC),D,
     &  HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,X08,X09,I02,DBT,BARK*100.,
     &  LOGDIA,BOLHT,LOGLEN,LOGVOL,TVOL,I03,X010,X011,I1,I1,I1,I04,
     &  I05,X012,CTYPE,I01,PROD,IERR)
C
        IF(D.GE.BFMIND(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,1)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,1)=0.
        ENDIF
        IF(D.GE.DBHMIN(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,2)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,2)=0.
        ENDIF        
C
        IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE CF TVOL= ',TVOL
      ELSE
        DRC=0.
        CALL FORMCL(ISPC,INTFOR,D,FC)
        IFC=IFIX(FC)
        IF(DEBUG)WRITE(JOSTND,*)' CALLING DVEST CF ISPC,ARGS = ',
     &  ISPC,VEQNNC(ISPC),D,H,TOPDIB,IFC,FORST,BARK,HTTYPE
C
        CALL DVEST(VEQNNC(ISPC),D,DRC,H,TOPDIB,IFC,I01,X01,X02,
     &  FORST,BARK*100.,TVOL,I1,I1,I1,I02,I03,
     &  PROD,HTTYPE,I04,X09,LIVE,NINT(BA),NINT(SITEAR(ISPC)),
     &  CTYPE,IERR)
C
        IF(DEBUG)WRITE(JOSTND,*)' AFTER DVEST CF TVOL= ',TVOL
      ENDIF
C----------
C  IF TOP DIAMETER IS DIFFERENT FOR BF CALCULATIONS, STORE APPROPRIATE
C  VOLUMES AND CALL PROFILE AGAIN.
C----------
      IF((BFTOPD(ISPC).NE.TOPD(ISPC)).OR.
     &   (BFSTMP(ISPC).NE.STMP(ISPC)).OR.
     &   (VEQNNB(ISPC).NE.VEQNNC(ISPC)))THEN
        TVOL1=TVOL(1)
        TVOL4=TVOL(4)
        DO 20 IZERO=1,15
        TVOL(IZERO)=0.
   20   CONTINUE
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS
C----------
        I01=0
        I02=0
        I03=0
        I04=0
        I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS
C----------
        X01=0.
        X02=0.
        X03=0.
        X04=0.
        X05=0.
        X06=0.
        X07=0.
        X08=0.
        X09=0.
        X010=0.
        X011=0.
        X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS  --  BOARD FT SECTION
C----------
        CTYPE=' '
C----------
C  CONSTANT INTEGER ARGUMENTS
C----------
        I1= 1
        IREGN= 1
        PROD='01'
        LIVE='L'
C
        IF(VEQNNB(ISPC)(4:6).EQ.'FW2')THEN
          IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE BF ISPC,ARGS = ',
     &     ISPC,IREGN,FORST,VEQNNB(ISPC),BFTOPD(ISPC),BFSTMP(ISPC),D,H,
     &     DBT,BARK
         
          CALL PROFILE (IREGN,FORST,VEQNNB(ISPC),TOPDIB,X01,BFSTMP(ISPC)
     &    ,D,HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,X08,X09,I02,DBT,
     &    BARK*100.,LOGDIA,BOLHT,LOGLEN,LOGVOL,TVOL,I03,X010,X011,I1,I1,
     &    I1,I04,I05,X012,CTYPE,I01,PROD,IERR)
C 
          IF(D.GE.BFMIND(ISPC))THEN
            IF(IT.GT.0)HT2TD(IT,1)=X02
          ELSE
            IF(IT.GT.0)HT2TD(IT,1)=0.
          ENDIF
C
          IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE BF TVOL= ',TVOL
        ELSE
          DRC=0.
          CALL FORMCL(ISPC,INTFOR,D,FC)
          IFC=IFIX(FC)
          IF(DEBUG)WRITE(JOSTND,*)' CALLING DVEST CF ISPC,ARGS = ',
     &    ISPC,VEQNNB(ISPC),D,H,TOPDIB,IFC,FORST,BARK,HTTYPE
C        
          CALL DVEST(VEQNNB(ISPC),D,DRC,H,TOPDIB,IFC,I01,X01,X02,
     &    FORST,BARK*100.,TVOL,I1,I1,I1,I02,I03,
     &    PROD,HTTYPE,I04,X09,LIVE,NINT(BA),NINT(SITEAR(ISPC)),
     &    CTYPE,IERR)
C        
          IF(DEBUG)WRITE(JOSTND,*)' AFTER DVEST CF TVOL= ',TVOL
        ENDIF
        TVOL(1)=TVOL1
        TVOL(4)=TVOL4
      ENDIF
C----------
C  SET RETURN VALUES.
C----------
      VN=TVOL(1)
      IF(VN.LT.0.)VN=0.
      VMAX=VN
      IF(D .LT. DBHMIN(ISPC))THEN
        VM = 0.
      ELSE
        VM=TVOL(4)
        IF(VM.LT.0.)VM=0.
      ENDIF
      IF(D.LT.BFMIND(ISPC))THEN
        BBFV=0.
      ELSE
        IF(METHB(ISPC).EQ.9) THEN
          BBFV=TVOL(10)
        ELSE
          BBFV=TVOL(2)
        ENDIF
        IF(BBFV.LT.0.)BBFV=0.
      ENDIF
      CTKFLG = .TRUE.
      BTKFLG = .TRUE.
      RETURN
C
C
C----------
C  REGION 4 VOLUME SECTION
C  BRANCH TO THE APPROPRIATE EQUATION ROUTINE
C----------
  100 CONTINUE
      DO 103 IZERO=1,15
      TVOL(IZERO)=0.
  103 CONTINUE
      TOPDIB=TOPD(ISPC)*BARK
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS
C----------
      I01=0
      I02=0
      I03=0
      I04=0
      I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS
C----------
      X01=0.
      X02=0.
      X03=0.
      X04=0.
      X05=0.
      X06=0.
      X07=0.
      X08=0.
      X09=0.
      X010=0.
      X011=0.
      X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS
C----------
      CTYPE=' '
C----------
C  CONSTANT INTEGER ARGUMENTS
C----------
      I1= 1
      IREGN= 4
C
      PROD='01'
      LIVE='L'
C
      IF(VEQNNC(ISPC)(4:6).EQ.'FW2')THEN
        IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE CF ISPC,ARGS = ',
     &  ISPC,IREGN,FORST,VEQNNC(ISPC),BFTOPD(ISPC),STMP(ISPC),D,H,
     &  DBT,BARK
C
        CALL PROFILE (IREGN,FORST,VEQNNC(ISPC),TOPDIB,X01,STMP(ISPC),
     &  D,HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,X08,X09,I02,DBT,
     &  BARK*100.,LOGDIA,BOLHT,LOGLEN,LOGVOL,TVOL,I03,X010,X011,
     &  I1,I1,I1,I04,I05,X012,CTYPE,I01,PROD,IERR)
C
        IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE CF TVOL= ',TVOL
C
        IF(D.GE.BFMIND(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,1)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,1)=0.
        ENDIF
        IF(D.GE.DBHMIN(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,2)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,2)=0.
        ENDIF        
C
      ELSEIF(VEQNNC(ISPC)(4:6).EQ.'DVE')THEN
        DRC=0.
        CALL FORMCL(ISPC,INTFOR,D,FC)
        IFC=IFIX(FC)
        IF(DEBUG)WRITE(JOSTND,*)' CALLING DVEST CF ISPC,ARGS = ',
     &  ISPC,VEQNNC(ISPC),D,H,TOPDIB,IFC,FORST,BARK,HTTYPE
C
        CALL DVEST(VEQNNC(ISPC),D,DRC,H,TOPDIB,IFC,I01,X01,X02,
     &  FORST,BARK*100.,TVOL,I1,I1,I1,I02,I03,
     &  PROD,HTTYPE,I04,X09,LIVE,NINT(BA),NINT(SITEAR(ISPC)),
     &  CTYPE,IERR)
C
        IF(DEBUG)WRITE(JOSTND,*)' AFTER DVEST CF TVOL= ',TVOL
      ELSE
        NLOGS = 0.
        NLOGSS = 0.
        IERR=0
        I0=0
        I1=1
        X01=0.
        IF(DEBUG)WRITE(JOSTND,*)' 113 BEFORE ARGS VEQNNC(ISPC),TDIB,H,D,
     &  TVOL','NLOGS,NLOGSS= ',VEQNNC(ISPC),TOPDIB,H,D,TVOL,NLOGS,NLOGSS
        CALL R4VOL(IREGN,VEQNNC(ISPC),TOPDIB,H,D,X01,TVOL,NLOGS,NLOGSS,
     &             I1,I1,I1,I0,I0,IERR)
        IF(DEBUG)WRITE(JOSTND,*)' 113 AFTER R4VOL - TVOL= ',TVOL
      ENDIF
C----------
C  IF TOP DIAMETER IS DIFFERENT FOR BF CALCULATIONS, STORE APPROPRIATE
C  VOLUMES AND CALL PROFILE AGAIN.
C----------
      IF((BFTOPD(ISPC).NE.TOPD(ISPC)).OR.
     &   (BFSTMP(ISPC).NE.STMP(ISPC)).OR.
     &   (VEQNNB(ISPC).NE.VEQNNC(ISPC)))THEN
        TVOL1=TVOL(1)
        TVOL4=TVOL(4)
        DO 101 IZERO=1,15
        TVOL(IZERO)=0.
  101   CONTINUE
        TOPDIB=BFTOPD(ISPC)*BARK
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS
C----------
        I01=0
        I02=0
        I03=0
        I04=0
        I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS
C----------
        X01=0.
        X02=0.
        X03=0.
        X04=0.
        X05=0.
        X06=0.
        X07=0.
        X08=0.
        X09=0.
        X010=0.
        X011=0.
        X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS
C----------
        CTYPE=' '
C----------
C  CONSTANT INTEGER ARGUMENTS - BOARD FOOT SECTION
C----------
        I1= 1
        IREGN= 4
C
        PROD='01'
        LIVE='L'

        IF(VEQNNB(ISPC)(4:6).EQ.'FW2')THEN
          IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE BF ISPC,ARGS = ',
     &     ISPC,IREGN,FORST,VEQNNB(ISPC),BFTOPD(ISPC),BFSTMP(ISPC),D,H,
     &     DBT,BARK
C
          CALL PROFILE (IREGN,FORST,VEQNNB(ISPC),TOPDIB,X01,
     &    BFSTMP(ISPC),D,HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,X08,
     &    X09,I02,DBT,BARK*100.,LOGDIA,BOLHT,LOGLEN,LOGVOL,TVOL,I03,
     &    X010,X011,I1,I1,I1,I04,I05,X012,CTYPE,I01,PROD,IERR)
C
          IF(D.GE.BFMIND(ISPC))THEN
            IF(IT.GT.0)HT2TD(IT,1)=X02
          ELSE
            IF(IT.GT.0)HT2TD(IT,1)=0.
          ENDIF
C
          IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE BF TVOL= ',TVOL
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
        ELSEIF(VEQNNB(ISPC)(4:6).EQ.'DVE')THEN
          DRC=0.
          CALL FORMCL(ISPC,INTFOR,D,FC)
          IFC=IFIX(FC)
          IF(DEBUG)WRITE(JOSTND,*)' CALLING DVEST BF ISPC,ARGS = ',
     &    ISPC,VEQNNB(ISPC),D,H,TOPDIB,IFC,FORST,BARK,HTTYPE
C        
          CALL DVEST(VEQNNB(ISPC),D,DRC,H,TOPDIB,IFC,I01,X01,X02,
     &    FORST,BARK*100.,TVOL,I1,I1,I1,I02,I03,
     &    PROD,HTTYPE,I04,X09,LIVE,NINT(BA),NINT(SITEAR(ISPC)),
     &    CTYPE,IERR)
C        
          IF(DEBUG)WRITE(JOSTND,*)' AFTER DVEST BF TVOL= ',TVOL
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
        ELSE
          NLOGS = 0.
          NLOGSS = 0.
          IF(DEBUG)WRITE(JOSTND,*)' 114 BEFORE ARGS VEQNNB,TDIB,H,D,',
     &    'TVOL,NLOGS,NLOGSS= ',VEQNNB(ISPC),TDIB,H,D,TVOL,NLOGS,NLOGSS
          CALL R4VOL(IREGN,VEQNNB(ISPC),TDIB,H,D,X01,TVOL,NLOGS,NLOGSS,
     &               I1,I1,I1,I0,I0,IERR)
          IF(DEBUG)WRITE(JOSTND,*)' 114 AFTER R4VOL - TVOL= ',TVOL
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
        ENDIF
      ENDIF
C----------
C  SET RETURN VALUES.
C----------
      VN=TVOL(1)
      IF(VN.LT.0.)VN=0.
      VMAX=VN
      IF(D .LT. DBHMIN(ISPC))THEN
        VM = 0.
      ELSE
        VM=TVOL(4)
        IF(VM.LT.0.)VM=0.
      ENDIF
      IF(D.LT.BFMIND(ISPC))THEN
        BBFV=0.
      ELSE
        IF(METHB(ISPC).EQ.9) THEN
          BBFV=TVOL(10)
        ELSE
          BBFV=TVOL(2)
        ENDIF
        IF(BBFV.LT.0.)BBFV=0.
      ENDIF
      CTKFLG = .TRUE.
      BTKFLG = .TRUE.
C
      RETURN
C
C
C----------
C  ENTER ANY OTHER CUBIC HERE
C----------
      ENTRY OCFVOL (VN,VM,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,LCONE,
     1              CTKFLG,IT)
      VN=0.
      VMAX=0.
      VM=0.
      CTKFLG = .FALSE.
      RETURN
C
C
C----------
C  ENTER ANY OTHER BOARD HERE.
C----------
      ENTRY OBFVOL (BBFV,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,LCONE,
     1              BTKFLG,IT)
      BBFV=0.
      BTKFLG = .FALSE.
      RETURN
C
C
C----------
C  ENTRY POINT FOR SENDING VOLUME EQN NUMBER TO THE FVS-TO-NATCRZ ROUTINE
C----------
      ENTRY GETEQN(ISPC,D,H,EQNC,EQNB,TDIBC,TDIBB)
      EQNC=VEQNNC(ISPC)
      EQNB=VEQNNB(ISPC)
      TDIBC=TOPD(ISPC)*BRATIO(ISPC,D,H)
      TDIBB=BFTOPD(ISPC)*BRATIO(ISPC,D,H)
      RETURN
C
      END
