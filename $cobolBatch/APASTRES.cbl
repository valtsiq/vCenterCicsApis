      *****************************************************************
      * PoT para Tivit / Cielo
      *****************************************************************
       identification division.
       program-id.    APASTRES.
       environment    division.
       configuration  section.
       data           division.
       working-storage section.
      *----------------------------------------------------------------*
      *----------------------------------------------------------------*
      *   GENERIC WORK VARIABLES                                       *
      *----------------------------------------------------------------*
      *----------------------------------------------------------------*
       01 work-storage.
          03 filler                   pic x(0010) value 'work-initi'.
          03 wk-cont                  pic 9(0015) value zeroes.
          03 wk-random                pic 9(0004) value zeroes.
          03 wk-loop                  pic 9(0004) value zeroes.
          03 wk-num-cp3               pic s9(004) comp-3 value zeroes.
          03 wk-sqr-cp3            pic s9(4)v9(4) comp-3 value zeroes.
          03 wk-num-cp5               pic s9(004) comp-5 value zeroes.
          03 wk-exp-cp5               pic s9(015) comp-5 value zeroes.
          03 wk-print-sqr      pic 999.999,999999999 value zeroes.

      ******************************************************************
      *    L I N K A G E   S E C T I O N
      ******************************************************************
       linkage section.

      ******************************************************************
      *    P R O C E D U R E S
      ******************************************************************
       procedure division.

      *----------------------------------------------------------------*
       mainline section.

      *----------------------------------------------------------------*
      * Common code                                                    *
      *----------------------------------------------------------------*
           perform until wk-cont > 1000000
                   perform controlled-loop
                   add 1 to wk-cont
           end-perform
           stop run.
       controlled-loop.
           compute wk-random = function random * 1000
           movo wk-random to wk-num-cp3
           move wk-random to wk-num-cp5
           move wk-exp-cp5 to wk-num-cp5
           compute wk-exp-cp5 = wk-random ** 3
           compute wk-sqr-cp3 = function sqrt(wk-exp-cp5)
           if wk-random = 500
              move    wk-sqr-cp3 to wk-print-sqr
              display '---------------------------'
              display wk-random
              display wk-print-sqr
           end-if
           .