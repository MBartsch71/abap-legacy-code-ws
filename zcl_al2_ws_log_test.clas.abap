CLASS zcl_al2_ws_log_test DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_log_table TYPE STANDARD TABLE OF char256 WITH EMPTY KEY.
    INTERFACES zif_al2_ws_log.

    METHODS get_log RETURNING VALUE(rt_result) TYPE tt_log_table.

  PRIVATE SECTION.
    DATA mt_log TYPE tt_log_table.

ENDCLASS.

CLASS zcl_al2_ws_log_test IMPLEMENTATION.


  METHOD get_log.
    rt_result = mt_log.
  ENDMETHOD.


  METHOD zif_al2_ws_log~log_msg.
    mt_log = VALUE #( BASE mt_log ( iv_message ) ).
  ENDMETHOD.
ENDCLASS.
