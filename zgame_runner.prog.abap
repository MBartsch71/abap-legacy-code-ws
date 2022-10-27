*&---------------------------------------------------------------------*
*& Report zgame_runner
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgame_runner.

DATA not_a_winner TYPE abap_bool.

DATA(game) = NEW zcl_game( ).

game->add( 'Johnny' ).
game->add( 'Dee Dee' ).
game->add( 'Joey' ).
game->add( 'Tommy' ).

DATA(die) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                        min  = 1
                                        max  = 6 ).
DATA(answer) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                           min  = 1
                                           max  = 9 ).

WHILE abap_true = abap_true.
  game->roll( die->get_next( ) ).

  IF answer->get_next( ) = 7.
    not_a_winner = game->wrong_answer( ).
  ELSE.
    not_a_winner = game->was_correctly_answered( ).
  ENDIF.

  IF NOT ( not_a_winner = abap_true ).
    EXIT.
  ENDIF.
ENDWHILE.

COMMIT WORK AND WAIT.
WRITE 'Game finished'.
