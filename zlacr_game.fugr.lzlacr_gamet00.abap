*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 13.05.2018 at 23:16:17
*   view maintenance generator version: #001407#
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
