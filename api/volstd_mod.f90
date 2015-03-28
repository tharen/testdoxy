module volstd_mod
    use prgprm_mod, only: maxsp
    implicit none
!ODE SEGMENT VOLSTD
!----------
!  **VOLSTD DATE OF LAST REVISION:  11/21/05
!----------
      LOGICAL LSTATS
      CHARACTER*10 VEQNNB(MAXSP),VEQNNC(MAXSP)
      INTEGER IBTRAN(MAXSP),ICTRAN(MAXSP)
      REAL    BFMIND(MAXSP),BFTOPD(MAXSP),BFSTMP(MAXSP),CFVEQL(7,MAXSP), &
              CFVEQS(7,MAXSP),BFVEQL(7,MAXSP),BFVEQS(7,MAXSP),           &
              CTRAN(MAXSP),BTRAN(MAXSP),ALPHA,LOGDIA(21,3),LOGVOL(7,20)
      COMMON /VOLCHR/ VEQNNB,VEQNNC
      COMMON /VOLSTD/ BFMIND,BFTOPD,BFSTMP,CFVEQL,CFVEQS,BFVEQL,     &
                      BFVEQS,CTRAN,BTRAN,IBTRAN,ICTRAN,LSTATS,ALPHA, &
                      LOGDIA,LOGVOL
!----------
!  DEFINITIONS OF VARIABLES IN 'VOLCHR' COMMON BLOCK:
!----------
!    VEQNNB -- NATIONAL CRUISE SYSTEM BOARD FOOT VOLUME EQUATION NUMBER
!              ENTERED WITH VOLEQNUM KEYWORD.
!    VEQNNC -- NATIONAL CRUISE SYSTEM CUBIC FOOT VOLUME EQUATION NUMBER
!              ENTERED WITH VOLEQNUM KEYWORD.
!----------
!  DEFINITIONS OF VARIABLES IN 'VOLSTD' COMMON BLOCK:
!----------
!    LOGDIA -- LOG-END DIAMETERS FOR UP TO 20 LOGS PER TREE: ( ,1)
!              SCALING DIA. INSIDE BARK,( ,2) ACTUAL PREDICTED DIA.
!              INSIDE BARK ( ,3) ACTUAL PREDICTED DIA. OUTSIDE BARK.
!              DIAMETERS ARE FROM LARGE TO SMALL. FIRST DIA. IS LARGE
!              DIA. OF BUTT END, SECOND DIA. IS SMALL END OF BUTT = LARGE
!              END OF SECOND LOG AND SO ON.
!    LOGVOL -- VOLUME OF UP TO 20 LOGS PER TREE: (1, ) GROSS SCRIBNER BF
!              (2, ) GROSS REMOVED SCRIBNER BF, (3, ) NET SCRIBNER BF
!              (4, ) GROSS CU, (5, ) GROSS REMOVED CU, (6, ) NET CU
!              (7, ) GROSS INTERNATIONAL 1/4 BF.
!-----END SEGMENT
end module volstd_mod
