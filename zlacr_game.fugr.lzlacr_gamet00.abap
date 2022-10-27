*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLACR_GAME_PARAM................................*
DATA:  BEGIN OF STATUS_ZLACR_GAME_PARAM              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLACR_GAME_PARAM              .
CONTROLS: TCTRL_ZLACR_GAME_PARAM
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZLACR_GAME_PARAM              .
TABLES: ZLACR_GAME_PARAM               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
