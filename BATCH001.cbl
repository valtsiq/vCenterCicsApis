000100 IDENTIFICATION DIVISION.                                         00010015
000200 PROGRAM-ID. BATCH001.                                            00020015
000300                                                                  00030015
000400 ENVIRONMENT DIVISION.                                            00040015
000500                                                                  00050015
000600 INPUT-OUTPUT SECTION.                                            00060015
000700   FILE-CONTROL.                                                  00070015
000800        SELECT BINCARD1 ASSIGN TO 'BIN00001'                      00080015
000900        ORGANIZATION SEQUENTIAL.                                  00090015
001000*-------------------------------------------------
001100 DATA DIVISION.                                                   00110015
001200   FILE SECTION.                                                  00120015
001300                                                                  00130015
001400   FD BINCARD1                                                    00140015
001500        RECORDING MODE IS F                                       00150015
001600        RECORD CONTAINS 256 CHARACTERS.                           00160015
001700                                                                  00170015
001800   01 FD-BINCARD1.                                                00180015
001900      05 FD-BINCARD1-CODIGO                  PIC 9(006).          00190015
002000      05 FD-BINCARD1-BANDEIRA                PIC X(010).          00200015
002100      05 FILLER                              PIC X(002).          00210015
002200      05 FD-BINCARD1-EMISSOR                 PIC X(035).          00220015
002300      05 FILLER                              PIC X(199).          00230015
002400                                                                  00240015
002500   WORKING-STORAGE SECTION.                                       00250015
002600   01 WS-BINCARD1.                                                00260015
002700      05 WS-BINCARD1-CODIGO       PIC 9(006).                     00270015
002800      05 FILLER                   PIC X(004) VALUE SPACES.        00280015
002900      05 WS-BINCARD1-BANDEIRA     PIC X(010).                     00290015
003000      05 FILLER                   PIC X(004) VALUE SPACES.        00300015
003100      05 WS-BINCARD1-EMISSOR      PIC X(035).                     00310015
003200                                                                  00320015
003300   01 WS-EOF                                 PIC X(001).          00330015
003400                                                                  00340015
003500 PROCEDURE DIVISION.                                              00350015
003600     OPEN INPUT BINCARD1                                          00360015
003700        PERFORM UNTIL WS-EOF = 'Y'                                00370015
003800           READ BINCARD1 AT END MOVE 'Y' TO WS-EOF                00380015
003900           NOT AT END PERFORM 000-PRINT-REGISTRO                  00390015
004000           END-READ                                               00400015
004100        END-PERFORM.                                              00410015
004200     CLOSE BINCARD1.                                              00420015
004300     STOP RUN.                                                    00430015
004400* --------------------------------                                00440015
004500 000-PRINT-REGISTRO.                                              00450015
004600*                                                                 00460015
004700     MOVE FD-BINCARD1-CODIGO   TO WS-BINCARD1-CODIGO              00470015
004800     MOVE FD-BINCARD1-BANDEIRA TO WS-BINCARD1-BANDEIRA            00480015
004900     MOVE FD-BINCARD1-EMISSOR  TO WS-BINCARD1-EMISSOR             00490015
005000*                                                                 00500015
005100     IF WS-BINCARD1-BANDEIRA EQUAL 'MASTERCARD'                   00510015
005200        DISPLAY WS-BINCARD1                                       00520015
005300     END-IF                                                       00530015
005400     .                                                            00540015
