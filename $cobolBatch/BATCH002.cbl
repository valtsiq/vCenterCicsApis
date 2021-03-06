       IDENTIFICATION DIVISION.
       PROGRAM-ID. BATCH002.

       ENVIRONMENT DIVISION.
      *--------------------------------------------
       INPUT-OUTPUT SECTION.
         FILE-CONTROL.
              SELECT BINCARD1 ASSIGN TO 'BIN00001'
              ORGANIZATION SEQUENTIAL.

       DATA DIVISION.
         FILE SECTION.

         FD BINCARD1
              RECORDING MODE IS F
              RECORD CONTAINS 256 CHARACTERS.

         01 FD-BINCARD1.
            05 FD-BINCARD1-CODIGO                  PIC 9(006).
            05 FD-BINCARD1-BANDEIRA                PIC X(010).
            05 FILLER                              PIC X(002).
            05 FD-BINCARD1-EMISSOR                 PIC X(035).
            05 FILLER                              PIC X(199).

         WORKING-STORAGE SECTION.
         01 WS-BINCARD1.
            05 WS-BINCARD1-CODIGO       PIC 9(006).
            05 FILLER                   PIC X(004) VALUE SPACES.
            05 WS-BINCARD1-BANDEIRA     PIC X(010).
            05 FILLER                   PIC X(004) VALUE SPACES.
            05 WS-BINCARD1-EMISSOR      PIC X(035).

         01 WS-EOF                                 PIC X(001).

       PROCEDURE DIVISION.
           OPEN INPUT BINCARD1
              PERFORM UNTIL WS-EOF = 'Y'
                 READ BINCARD1 AT END MOVE 'Y' TO WS-EOF
                 NOT AT END PERFORM 000-PRINT-REGISTRO
                 END-READ
              END-PERFORM.
           CLOSE BINCARD1.
           STOP RUN.
      *
       000-PRINT-REGISTRO.
      *
           MOVE FD-BINCARD1-CODIGO   TO WS-BINCARD1-CODIGO
           MOVE FD-BINCARD1-BANDEIRA TO WS-BINCARD1-BANDEIRA
           MOVE FD-BINCARD1-EMISSOR  TO WS-BINCARD1-EMISSOR
      *
           IF WS-BINCARD1-BANDEIRA EQUAL 'AMEX'
              DISPLAY WS-BINCARD1
           END-IF
           .