      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C  **FORKOD--SO  DATE OF LAST REVISION:  02/17/09
C----------
C
C     TRANSLATES FOREST CODE INTO A SUBSCRIPT, IFOR, AND IF
C     KODFOR IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
C  NATIONAL FORESTS:
C  601 = DESCHUTES
C  602 = FREMONT
C  620 = WINEMA
C  505 = KLAMATH
C  506 = LASSEN
C  509 = MODOC
C  511 = PLUMAS
C  701 = INDUSTRY LANDS
C  514 = SHASTA-TRINITY (MAPPED TO KLAMATH)
C----------
      INTEGER JFOR(10),KFOR(10),NUMFOR,I
      DATA JFOR/601,602,620,505,506,509,511,701,514, 0/, NUMFOR /9/
      DATA KFOR/10*1/
C
      IF (KODFOR .EQ. 0) GOTO 30
      DO 10 I=1,NUMFOR
      IF (KODFOR .EQ. JFOR(I)) GOTO 20
   10 CONTINUE
      CALL ERRGRO (.TRUE.,3)
      WRITE(JOSTND,11) JFOR(IFOR)
   11 FORMAT(T12,'FOREST CODE USED FOR THIS PROJECTION IS',I4)
      GOTO 30
   20 CONTINUE
      IF(I .EQ. 9)THEN
        WRITE(JOSTND,21)
   21   FORMAT(T12,'SHASTA NF (514) BEING MAPPED TO KLAMATH ',
     &  '(505) FOR FURTHER PROCESSING.')
        I=4
      ENDIF
      IFOR=I
      IGL=KFOR(I)
   30 CONTINUE
      KODFOR=JFOR(IFOR)
      RETURN
      END
