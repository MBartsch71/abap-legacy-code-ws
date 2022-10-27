*"* use this source file for any macro definitions you need
*"* in the implementation part of the class
DEFINE log_msg.
  CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
        EXPORTING
          i_log_handle = log
          i_msgty      = 'I'
          i_text       = &1.

  CALL FUNCTION 'BAL_DB_SAVE'
        EXPORTING
          i_save_all = abap_true.

END-OF-DEFINITION.
