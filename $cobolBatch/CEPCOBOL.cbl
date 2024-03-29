       IDENTIFICATION DIVISION.                                         00000100
       PROGRAM-ID. CEPCOBOL.                                            00000200
      ******************************************************************00000300
      * Valter Siqueira - Systems      c                                00000400
      * Laboratoratório de uso particular ......                        00000500
      * ----------------------------------------------------------------00000600
      * Sistema .............. CEP                                      00000700
      * Programa.............. CEPBLOAD                                 00000800
      * Tipo    .............. BATCH                                    00000900
      * Finalidade ........... Realizar a carga do arquivos VSAM        00001000
      *                        "CEPVSA01" a partir do arquivo           00001100
      *                        sequencial "CEPSEQ01".                   00001200
      *                        O arquivo sequencial esta em formato     00001356
      *                        CSV. As virgulas sao retiradas e os      00001456
      *                        campos ajustados antes de inseridos      00001500
      *                        no arquivo VSAM.                         00001600
      * DSnames .............. B090290.CEPVSA01                         00001700
      *                        B090290.CEPSEQ01                         00001800
      * JOB def cluster ...... B090290.LIB.JCL(CEPDFCLU)                00001900
      *                                                                 00002000
      ******************************************************************00002100
       ENVIRONMENT DIVISION.                                            00002200
       INPUT-OUTPUT SECTION.                                            00002300
       FILE-CONTROL.                                                    00002400
      *INPUT-OUTPUT FILE                                                00002500
           SELECT CEPV0001 ASSIGN TO 'CEPV0001'                         00002600
           ORGANIZATION IS INDEXED                                      00002700
           ACCESS MODE IS RANDOM                                        00002800
           RECORD KEY IS CEPV0001-CEP                                   00002900
           FILE STATUS WK-VSAM-FILE-STATUS.                             00003000
      *                                                                 00003100
                                                                        00003400
           SELECT CEPS0001 ASSIGN TO 'CEPS0001'                         00003500
           ORGANIZATION SEQUENTIAL.                                     00003600
      *                                                                 00003700
       DATA DIVISION.                                                   00003800
       FILE SECTION.                                                    00003900
                                                                        00004000
       FD CEPS0001                                                      00004100
            RECORDING MODE IS F                                         00004200
            RECORD CONTAINS 120 CHARACTERS.                             00004300
       01 CEPS0001-REC                  PIC  X(120) VALUE SPACES.       00004400
      *                                                                 00004500
       FD CEPV0001.                                                     00004600
       01 CEPV0001-REC.                                                 00004700
          05 CEPV0001-CEP               PIC  X(008).                    00004800
          05 CEPV0001-UF                PIC  X(002).                    00004900
          05 CEPV0001-CIDADE            PIC  X(030).                    00005000
          05 CEPV0001-BAIRRO            PIC  X(030).                    00005100
          05 CEPV0001-LOGRADOURO        PIC  X(030).                    00005200
      *                                                                 00005300
       WORKING-STORAGE SECTION.                                         00005400
        01 WORKING-AREAS.                                               00005500
           03 WK-CEP-REC                PIC  X(120) VALUE SPACES.       00005600
           03 WK-CEP-REC-RED  REDEFINES WK-CEP-REC.                     00005700
              05 WK-CEP-REC-BYTE        PIC  X(001) OCCURS 120 TIMES.   00005800
           03 WK-CEP-FILL               PIC  X(030) VALUE SPACES.       00005900
           03 WK-CEP-FILL-RED REDEFINES WK-CEP-FILL.                    00006000
              05 WK-CEP-FILL-BYTE       PIC  X(001) OCCURS 030 TIMES.   00006100
           03 WK-CONT-BYTE-REC          PIC  9(010) VALUE ZEROS.        00006200
           03 WK-CONT-BYTE-FILL         PIC  9(010) VALUE ZEROS.        00006300
           03 WK-CONT-FILL              PIC  9(010) VALUE 1.            00006400
           03 WK-CONT-REC               PIC  9(010) VALUE ZEROS.        00006500
           03 WK-EOF                    PIC  X(001) VALUE 'N'.          00006600
           03 WK-VSAM-FILE-STATUS       PIC  X(002) VALUE SPACES.       00006700
           03 WK-DIV                    PIC  9(010) VALUE ZEROES.       00006800
           03 WK-DIV-RESTO              PIC  9(010) VALUE ZEROES.       00006900
                                                                        00007000
       PROCEDURE DIVISION.                                              00007100
      *                                                                 00007200
       MAIN-PARA.                                                       00007300
           PERFORM OPEN-FILES                                           00007400
           PERFORM READ-FILE UNTIL WK-EOF EQUAL 'Y'                     00007500
                                                                        00007600
           DISPLAY '---------------------------------------------'      00007700
           DISPLAY 'FINAL DO PROCESSAMENTO - TOTAL DE REGISTROS  '      00007857
           DISPLAY WK-CONT-REC                                          00007900
           DISPLAY '---------------------------------------------'      00008000
                                                                        00008100
           PERFORM CLOSE-FILES                                          00008200
           STOP RUN                                                     00008300
           .                                                            00008400
       OPEN-FILES.                                                      00008500
           OPEN INPUT  CEPS0001                                         00008600
           OPEN OUTPUT CEPV0001                                         00008700
           .                                                            00008800
       READ-FILE.                                                       00008900
                                                                        00009000
           MOVE 0            TO  WK-CONT-BYTE-REC                       00009100
           MOVE 0            TO  WK-CONT-BYTE-FILL                      00009200
           MOVE SPACES       TO  WK-CEP-REC                             00009300
           MOVE SPACES       TO  WK-CEP-FILL                            00009400
           ADD  1            TO  WK-CONT-REC                            00009500
                                                                        00009600
           READ CEPS0001 RECORD AT END MOVE 'Y' TO WK-EOF.              00009700
                                                                        00009800
           IF WK-EOF NOT = 'Y'                                          00009900
              DIVIDE WK-CONT-REC BY 50000                               00010000
              GIVING WK-DIV REMAINDER WK-DIV-RESTO                      00010100
                                                                        00010200
              IF WK-DIV-RESTO = 0                                       00010300
                 DISPLAY '---------------------------------------------'00010400
                 DISPLAY ' TOTAL PARCIAL REGISTORS '                    00010500
                 DISPLAY WK-CONT-REC                                    00010600
                 DISPLAY '---------------------------------------------'00010700
              END-IF                                                    00010800
                                                                        00010900
              PERFORM PROCESSA-REGISTRO                                 00011000
           END-IF                                                       00011100
           .                                                            00011200
       PROCESSA-REGISTRO.                                               00011300
           MOVE SPACES       TO  CEPV0001-REC                           00011400
           MOVE CEPS0001-REC TO  WK-CEP-REC                             00011500
           MOVE SPACES       TO  WK-CEP-FILL                            00011600
                                                                        00011700
           PERFORM MONTA-REGISTRO UNTIL WK-CONT-BYTE-REC = 120          00011800
                                                                        00011900
           PERFORM GRAVA-REGISTRO                                       00012000
                                                                        00012100
           MOVE 0            TO WK-CONT-BYTE-REC                        00012200
           MOVE 0            TO WK-CONT-BYTE-FILL                       00012300
           MOVE SPACES       TO WK-CEP-FILL                             00012400
           .                                                            00012500
       MONTA-REGISTRO.                                                  00012600
                                                                        00012700
           ADD 1             TO  WK-CONT-BYTE-REC                       00012800
           ADD 1             TO  WK-CONT-BYTE-FILL                      00012900
                                                                        00013000
           IF WK-CEP-REC-BYTE(WK-CONT-BYTE-REC) NOT =  ','              00013100
              AND WK-CONT-BYTE-FILL < 30                                00013200
              MOVE WK-CEP-REC-BYTE (WK-CONT-BYTE-REC)                   00013300
              TO   WK-CEP-FILL-BYTE (WK-CONT-BYTE-FILL)                 00013400
           ELSE                                                         00013500
              EVALUATE WK-CONT-FILL                                     00013600
               WHEN 1                                                   00013700
                   ADD  1                TO WK-CONT-FILL                00013800
                   MOVE WK-CEP-FILL      TO CEPV0001-CEP                00013900
               WHEN 2                                                   00014000
                   ADD  1                TO WK-CONT-FILL                00014100
                   MOVE WK-CEP-FILL      TO CEPV0001-UF                 00014200
               WHEN 3                                                   00014300
                   ADD  1                TO WK-CONT-FILL                00014400
                   MOVE WK-CEP-FILL      TO CEPV0001-CIDADE             00014500
               WHEN 4                                                   00014600
                   ADD  1                TO WK-CONT-FILL                00014700
                   MOVE WK-CEP-FILL      TO CEPV0001-BAIRRO             00014800
               WHEN 5                                                   00014900
                   MOVE WK-CEP-FILL      TO CEPV0001-LOGRADOURO         00015000
                   MOVE 120              TO WK-CONT-BYTE-REC            00015100
                   MOVE 1                TO WK-CONT-FILL                00015200
               END-EVALUATE                                             00015300
               MOVE SPACES               TO WK-CEP-FILL                 00015400
               MOVE 0                    TO WK-CONT-BYTE-FILL           00015500
           END-IF                                                       00015600
           .                                                            00015700
       GRAVA-REGISTRO.                                                  00015800
           MOVE 0            TO WK-CONT-BYTE-REC                        00015900
           MOVE 0            TO WK-CONT-BYTE-FILL                       00016000
           MOVE SPACES       TO WK-CEP-FILL                             00016100
                                                                        00016200
           WRITE CEPV0001-REC                                           00016300
                                                                        00016400
           IF WK-VSAM-FILE-STATUS NOT = '00'                            00016500
              DISPLAY "-----ERRO VSAM -----"                            00016600
              DISPLAY WK-VSAM-FILE-STATUS                               00016700
              PERFORM CLOSE-FILES                                       00016800
              STOP RUN                                                  00016900
           END-IF                                                       00017000
                                                                        00017100
           MOVE SPACES TO CEPV0001-REC                                  00017200
           .                                                            00017300
       CLOSE-FILES.                                                     00017400
           CLOSE CEPV0001                                               00017500
           CLOSE CEPS0001                                               00017600
           .                                                            00017700
