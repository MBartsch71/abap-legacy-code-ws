CLASS zcl_al2_ws_log_bal DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_al2_ws_log.

    METHODS constructor.

  PRIVATE SECTION.
    CONSTANTS mc_message_type_information   VALUE 'I' ##NO_TEXT.
    CONSTANTS mc_log_object_lacr TYPE bal_s_log-object VALUE 'Z_LACR' ##NO_TEXT.
    CONSTANTS mc_log_subobject_game TYPE bal_s_log-subobject VALUE 'Z_GAME' ##NO_TEXT.

    DATA mv_log TYPE balloghndl.

ENDCLASS.

CLASS ZCL_AL2_WS_LOG_BAL IMPLEMENTATION.

  METHOD constructor.
    DATA(ls_log) = VALUE bal_s_log( object    = mc_log_object_lacr
                                    subobject = mc_log_subobject_game ).
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = ls_log
      IMPORTING
        e_log_handle = mv_log.
  ENDMETHOD.

  METHOD zif_al2_ws_log~log_msg.
    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle = mv_log
        i_msgty      = mc_message_type_information
        i_text       = iv_message.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all = abap_true.
  ENDMETHOD.

ENDCLASS.
