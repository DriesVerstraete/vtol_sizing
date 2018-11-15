      SUBROUTINE ZHEFA (H,LDH,N,IPVT,INFO)
      INTEGER LDH,N,IPVT(N),INFO
      DOUBLE COMPLEX H(LDH,N)
C
C     *** PURPOSE:
C
C     ZHEFA FACTORS A COMPLEX UPPER HESSENBERG MATRIX BY GAUSSIAN
C     ELIMINATION.  THE LINPACK ANALOGUE OF ZHEFA IS ZGEFA.
C
C     ZHEFA IS USUALLY CALLED BY ZHECO, BUT IT CAN BE CALLED DIRECTLY
C     WITH A SUBSTANTIAL SAVING IN TIME IF RCOND IS NOT NEEDED.
C
C     ON ENTRY:
C
C        H    DOUBLE COMPLEX(LDH,N)
C             THE MATRIX TO BE FACTORED.
C
C        LDH  INTEGER
C             THE LEADING OR ROW DIMENSION OF THE ARRAY H AS DECLARED
C             IN THE MAIN CALLING PROGRAM.
C
C        N    INTEGER
C             THE ORDER OF THE MATRIX H.
C
C     ON RETURN:
C
C        H    AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS WHICH
C             WERE USED TO OBTAIN IT.
C             THE FACTORIZATION CAN BE WRITTEN  H = L*U  WHERE L IS
C             A PRODUCT OF PERMUTATION AND UNIT LOWER BIDIAGONAL
C             MATRICES AND U IS UPPER TRIANGULAR.
C
C        IPVT INTEGER(N)
C             AN INTEGER VECTOR OF PIVOT INDICES.
C
C        INFO INTEGER
C             = 0  NORMAL VALUE
C             = K  IF  U(K,K) .EQ. (0.0,0.0)  THIS IS NOT AN ERROR
C                  CONDITION FOR THIS SUBROUTINE, BUT IT DOES INDICATE
C                  THAT ZHESL WILL ATTEMPT TO DIVIDE BY ZERO IF CALLED.
C                  USE RCOND IN ZHECO FOR A RELIABLE INDICATION OF
C                  SINGULARITY.
C
C     THIS VERSION DATED MAY 1980.
C     ALAN J. LAUB, UNIVERSITY OF SOUTHERN CALIFORNIA.
C
C     SUBROUTINES AND FUNCTIONS CALLED:
C
C     DCL1
C
      DOUBLE PRECISION DCL1
C
C     INTERNAL VARIABLES:
C
      INTEGER J,K,KP1,L,NM1
      DOUBLE COMPLEX T
C
C     FORTRAN FUNCTIONS CALLED:
C
C     NONE
C
C     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
C
      INFO = 0
      NM1 = N-1
      IF (NM1 .LT. 1) GO TO 70
      DO 60 K = 1,NM1
         KP1 = K+1
C
C        FIND L = PIVOT INDEX
C
         L = K
         IF (DCL1(H(K+1,K)) .GT. DCL1(H(K,K))) L = KP1
         IPVT(K) = L
C
C        ZERO PIVOT IMPLIES THIS COLUMN ALREADY TRIANGULARIZED
C
         IF (DCL1(H(L,K)) .EQ. 0.0D0) GO TO 40
C
C        INTERCHANGE IF NECESSARY
C
         IF (L .EQ. K) GO TO 10
         T = H(L,K)
         H(L,K) = H(K,K)
         H(K,K) = T
   10    CONTINUE
C
C        COMPUTE MULTIPLIERS (NOTE: LINPACK COMPUTES NEGATIVE OF
C        WHAT IS COMPUTED HERE)
C
         T = (1.0D0,0.0D0)/H(K,K)
         H(KP1,K) = T*H(KP1,K)
C
C        ROW ELIMINATION WITH COLUMN INDEXING
C
         DO 30 J = KP1,N
              T = H(L,J)
              IF (L .EQ. K) GO TO 20
              H(L,J) = H(K,J)
              H(K,J) = T
   20         CONTINUE
              H(KP1,J) = H(KP1,J)-T*H(KP1,K)
   30    CONTINUE
         GO TO 50
   40    CONTINUE
         INFO = K
   50    CONTINUE
   60 CONTINUE
   70 CONTINUE
      IPVT(N) = N
      IF (DCL1(H(N,N)) .EQ. 0.0D0) INFO = N
      RETURN
      END
