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
    METHODS roll_a_die_once FOR TESTING.
    METHODS roll_a_number_and_win FOR TESTING.

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

  METHOD roll_a_die_once.
    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| )
                                        ( |Johnny is the current player.'| )
                                        ( |They have rolled a 4.| )
                                        ( |Johnny's new location is 5| )
                                        ( |The category is Music| )
                                        ( |The category is Music| ) ).

    mo_cut->add( |Johnny| ).
    mo_cut->roll( 4 ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( )  ).
  ENDMETHOD.

  METHOD roll_a_number_and_win.
    DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                        ( |Johnny was added. They are player number 1| )
                                        ( |Johnny is the current player.'| )
                                        ( |They have rolled a 6.| )
                                        ( |Johnny's new location is 7| )
                                        ( |The category is Sport| )
                                        ( |The category is Sport| )
                                        ( |Answer was correct!!!!| )
                                        ( |Johnny now has 1 Gold Coins.| ) ).

    mo_cut->add( |Johnny| ).
    mo_cut->roll( 6 ).
    mo_cut->was_correctly_answered( ).

    cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( )  ).
  ENDMETHOD.

  ##TODO "Tests can be deleted afterwards
  METHOD die_gives_expected_numbers.
    DATA lt_expected_values TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    lt_expected_values = VALUE #( FOR i = 1 THEN i + 1 UNTIL i = 7
                                     ( i ) ).

    DATA(lo_die) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                          min  = 1
                                          max  = 6 ).

    cl_abap_unit_assert=>assert_table_contains( line  = lo_die->get_next( )
                                                table = lt_expected_values ).
  ENDMETHOD.

ENDCLASS.
