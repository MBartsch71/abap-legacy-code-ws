  CLASS tc_explorative_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

    PRIVATE SECTION.
      DATA mo_cut      TYPE REF TO zcl_game.
      DATA mo_test_log TYPE REF TO zcl_al2_ws_log_test.

      METHODS setup.

      METHODS add_one_player                 FOR TESTING.
      METHODS add_two_players                FOR TESTING.

      METHODS log_impacted_by_die_creation   FOR TESTING.
      METHODS log_impacted_by_anwsr_creation FOR TESTING.

      METHODS roll_a_die_once                FOR TESTING.

      METHODS a_right_answer_is_given        FOR TESTING.
      METHODS a_wrong_answer_is_given        FOR TESTING.

      METHODS get_out_of_the_penalty_box     FOR TESTING.
      METHODS be_a_winner                    FOR TESTING.

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

    METHOD a_right_answer_is_given.
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

    METHOD a_wrong_answer_is_given.
      DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                          ( |Johnny was added. They are player number 1| )
                                          ( |Johnny is the current player.'| )
                                          ( |They have rolled a 6.| )
                                          ( |Johnny's new location is 7| )
                                          ( |The category is Sport| )
                                          ( |The category is Sport| )
                                          ( |Question was incorrectly answered| )
                                          ( |Johnny was sent to the penalty box| ) ).

      mo_cut->add( |Johnny| ).
      mo_cut->roll( 6 ).
      mo_cut->wrong_answer( ).

      cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( )  ).
    ENDMETHOD.

    METHOD get_out_of_the_penalty_box.
      DATA(lt_expected_values) = VALUE zcl_al2_ws_log_test=>tt_log_table(
                                          ( |Johnny was added. They are player number 1| )
                                          ( |Johnny is the current player.'| )
                                          ( |They have rolled a 6.| )
                                          ( |Johnny's new location is 7| )
                                          ( |The category is Sport| )
                                          ( |The category is Sport| )
                                          ( |Question was incorrectly answered| )
                                          ( |Johnny was sent to the penalty box| )
                                          ( |Johnny is the current player.'| )
                                          ( |They have rolled a 6.| )
                                          ( |Johnny is getting out of the penalty box| )
                                          ( |Johnny's new location is 0| )
                                          ( |The category is Histroy| )
                                          ( |The category is Histroy| )
                                          ( |Answer was correct!!!!| )
                                          ( |Johnny now has 1 Gold Coins.| ) ).

      mo_cut->add( |Johnny| ).
      mo_cut->roll( 6 ).
      mo_cut->wrong_answer( ).
      mo_cut->roll( 6 ).
      mo_cut->was_correctly_answered( ).

      cl_abap_unit_assert=>assert_equals( exp = lt_expected_values act = mo_test_log->get_log( )  ).
    ENDMETHOD.

    METHOD be_a_winner.
      mo_cut->add( |Johnny| ).

      DO 6 TIMES.
        DATA(not_a_winner) = mo_cut->was_correctly_answered(  ).
      ENDDO.

      IF NOT ( not_a_winner = abap_true ).
        data(win) = abap_true.
      ENDIF.

      cl_abap_unit_assert=>assert_true( act = win ).
    ENDMETHOD.

  ENDCLASS.
