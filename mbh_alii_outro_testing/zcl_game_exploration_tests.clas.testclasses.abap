CLASS tc_explorative_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut      TYPE REF TO zcl_game.
    DATA mo_test_log TYPE REF TO zcl_al2_ws_log_test.

    METHODS setup.

    METHODS add_one_player  FOR TESTING.
    METHODS add_two_players FOR TESTING.
    METHODS log_impacted_by_die_creation FOR TESTING.
    METHODS log_impacted_by_anwsr_creation FOR TESTING.

    METHODS die_gives_expected_numbers FOR TESTING.

ENDCLASS.

CLASS tc_explorative_test IMPLEMENTATION.

  METHOD setup.
    mo_test_log = NEW zcl_al2_ws_log_test( ).
    mo_cut = NEW zcl_game( mo_test_log ).
  ENDMETHOD.

  METHOD add_one_player.
    mo_cut->add( |Johnny| ).

    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| ) ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( ) ).
  ENDMETHOD.

  METHOD add_two_players.
    mo_cut->add( |Johnny| ).
    mo_cut->add( |Dee Dee| ).

    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| )
                                        ( |Dee Dee was added. They are player number 2| ) ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( ) ).
  ENDMETHOD.

  METHOD log_impacted_by_die_creation.
    mo_cut->add( |Johnny| ).

    DATA(die) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                         min  = 1
                                         max  = 6 ).


    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| ) ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( ) ).
  ENDMETHOD.

  METHOD log_impacted_by_anwsr_creation.
    mo_cut->add( |Johnny| ).

    DATA(die) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                         min  = 1
                                         max  = 6 ).

    DATA(answer) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                               min  = 1
                                               max  = 9 ).



    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| ) ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( ) ).
  ENDMETHOD.

  ##TODO "Tests can be deleted afterwards
  METHOD die_gives_expected_numbers.
    DATA lt_expected_values TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    lt_expected_values = VALUE #( FOR i = 1 THEN i + 1 UNTIL i = 6
                                     ( i ) ).

    DATA(lo_die) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                          min  = 1
                                          max  = 6 ).

    cl_abap_unit_assert=>assert_table_contains( line  = lo_die->get_next( )
                                                table = lt_expected_values ).
  ENDMETHOD.

ENDCLASS.
