CLASS zcl_game DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS game_id TYPE string VALUE 'LACR_1'.

    METHODS constructor.
    METHODS add IMPORTING i_player_name   TYPE string
                RETURNING VALUE(r_result) TYPE abap_bool.
    METHODS roll IMPORTING i_roll TYPE i.
    METHODS was_correctly_answered
      RETURNING VALUE(r_did_win) TYPE abap_bool.
    METHODS wrong_answer
      RETURNING VALUE(r_result) TYPE abap_bool.

  PROTECTED SECTION.
    METHODS is_playable RETURNING VALUE(r_playable) TYPE abap_bool.
    METHODS how_many_players RETURNING VALUE(r_num_players) TYPE i.
    METHODS ask_question.

  PRIVATE SECTION.
    DATA gt_players TYPE TABLE OF string.
    DATA questions TYPE zlacr_s_game_questions.

    DATA gt_is_in_penalty_box TYPE TABLE OF abap_bool.
    DATA gt_purses TYPE TABLE OF i.
    DATA gt_places TYPE TABLE OF i.

    DATA current_player TYPE i.
    DATA is_getting_out_of_penalty_box TYPE abap_bool.

    DATA log TYPE balloghndl.
    data msg type char256.
    METHODS create_sport_question
      IMPORTING
        i_index           TYPE i
      RETURNING
        VALUE(r_question) TYPE string.
    METHODS get_current_category
      RETURNING
        VALUE(r_category) TYPE string.
    METHODS did_player_win
      RETURNING
        VALUE(r_result) TYPE abap_bool.

ENDCLASS.



CLASS zcl_game IMPLEMENTATION.


  METHOD add.
    FIELD-SYMBOLS <new_entry> LIKE LINE OF gt_players.
    APPEND INITIAL LINE TO gt_players ASSIGNING <new_entry>.
    <new_entry> = i_player_name.

    APPEND INITIAL LINE TO gt_places ASSIGNING FIELD-SYMBOL(<place>).
    <place> = 1.

    APPEND INITIAL LINE TO gt_purses.
    APPEND INITIAL LINE TO gt_is_in_penalty_box.

    msg = |{ i_player_name } was added. They are player number { lines( gt_players ) }|.
    log_msg msg.

    r_result = abap_true.
  ENDMETHOD.


  METHOD ask_question.
    data question like msg.
    IF get_current_category( ) = 'History'.
      question = questions-history_questions[ 1 ].
      DELETE questions-history_questions INDEX 1.
    ENDIF.
    IF get_current_category( ) = 'Music'.
      question = questions-music_questions[ 1 ].
      DELETE questions-music_questions INDEX 1.
    ENDIF.
    IF get_current_category( ) = 'Sport'.
      question = questions-sport_questions[ 1 ].
      DELETE questions-sport_questions INDEX 1.
    ENDIF.
    IF get_current_category( ) = 'Science'.
      question = questions-science_questions[ 1 ].
      DELETE questions-science_questions INDEX 1.
    ENDIF.

    log_msg question.

  ENDMETHOD.


  METHOD constructor.
    DATA lv_game_params type zlacr_game_param.
    DATA question TYPE string.
    DATA index TYPE n.

    SELECT SINGLE * FROM zlacr_game_param INTO lv_game_params
        WHERE game_id = 'LACR_1'.

    DO lv_game_params-num_of_questions TIMES.
      index = sy-index.

      question = ''.
      CONCATENATE 'Histroy Questions #' index INTO question.
      APPEND question TO questions-history_questions.

      question = ''.
      CONCATENATE 'Science Questions #' index INTO question.
      APPEND question TO questions-science_questions.

      question = ''.
      CONCATENATE 'Music Questions #' index INTO question.
      APPEND question TO questions-music_questions.

      APPEND INITIAL LINE TO questions-sport_questions
          ASSIGNING FIELD-SYMBOL(<sport_question>).
      <sport_question> = create_sport_question( i_index = sy-index ).
    ENDDO.

    me->current_player = 1.

    DATA(s_log) = VALUE bal_s_log( object = 'Z_LACR' subobject = 'Z_GAME' ).
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = s_log
      IMPORTING
        e_log_handle = log.
  ENDMETHOD.


  METHOD create_sport_question.
    r_question = |Music Questions # { i_index }|.
  ENDMETHOD.


  METHOD did_player_win.
    r_result = boolc( NOT ( gt_purses[ current_player ] = 6 ) ).
  ENDMETHOD.


  METHOD get_current_category.
    IF gt_places[ me->current_player ] = 1. r_category = 'Music'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 5. r_category = 'Music'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 9. r_category = 'Music'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 2. r_category = 'Science'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 6. r_category = 'Science'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 10. r_category = 'Science'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 3. r_category = 'Sport'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 7. r_category = 'Sport'. RETURN. ENDIF.
    IF gt_places[ me->current_player ] = 11. r_category = 'Sport'. RETURN. ENDIF.
    r_category = 'Histroy'.
  ENDMETHOD.


  METHOD how_many_players.
    r_num_players = lines( gt_players ).
  ENDMETHOD.


  METHOD is_playable.
    r_playable = boolc( me->how_many_players( ) >= 2 ).
  ENDMETHOD.


  METHOD roll.
    msg = |{ gt_players[ me->current_player ] } is the current player.'|.
    log_msg msg.
    msg = |They have rolled a { i_roll }.|.
    log_msg msg.

    IF gt_is_in_penalty_box[ current_player ] = abap_true.
      IF ( i_roll MOD 2 ) = 0.
        is_getting_out_of_penalty_box = abap_true.

        msg = |{ gt_players[ me->current_player ] } is getting out of the penalty box|.
        log_msg msg.
        gt_places[ me->current_player ] = gt_places[ me->current_player ] + i_roll.

        IF gt_places[ me->current_player ] > 12.
          gt_places[ me->current_player ] = gt_places[ me->current_player ] - 13.
        ENDIF.

        msg = |{ gt_players[ me->current_player ] }'s new location is { gt_places[ me->current_player ] }|.
        log_msg msg.
        msg = |The category is { get_current_category( ) }|.
        log_msg msg.
        ask_question( ).

      ELSE.
        msg = |{ gt_players[ me->current_player ] } is not getting out of the penalty box|.
        log_msg msg.

        is_getting_out_of_penalty_box = abap_true.
      ENDIF.
    ELSE.
      gt_places[ me->current_player ] = gt_places[ me->current_player ] + i_roll.
      IF gt_places[ me->current_player ] > 12.
        gt_places[ me->current_player ] = gt_places[ me->current_player ] - 13.
      ENDIF.

      msg = |{ gt_players[ me->current_player ] }'s new location is { gt_places[ me->current_player ] }|.
      log_msg msg.
      msg = |The category is { get_current_category( ) }|.
      log_msg msg.
      ask_question( ).
    ENDIF.


  ENDMETHOD.


  METHOD was_correctly_answered.
    IF gt_is_in_penalty_box[ current_player ] = abap_true.
      IF is_getting_out_of_penalty_box = abap_true.
        msg = 'Answer was correct!!!!'.
        log_msg msg.

        gt_purses[ current_player ] = gt_purses[ current_player ] + 1.
        msg = |{ gt_players[ me->current_player ] } now has { gt_purses[ me->current_player ] } Gold Coins.|.
        log_msg msg.

        DATA(winner) = did_player_win( ).
        current_player = current_player + 1.
        IF current_player > lines( gt_players ).
          current_player = 1.
        ENDIF.

        r_did_win = winner.
      ELSE.
        current_player = current_player + 1.
        IF current_player > lines( gt_players ).
          current_player = 1.
        ENDIF.
        r_did_win = abap_true.
      ENDIF.


    ELSE.

      msg = 'Answer was correct!!!!'.
      log_msg msg.

      gt_purses[ current_player ] = gt_purses[ current_player ] + 1.
      msg = |{ gt_players[ me->current_player ] } now has { gt_purses[ me->current_player ] } Gold Coins.|.
      log_msg msg.

      winner = did_player_win( ).
      current_player = current_player + 1.
      IF current_player > lines( gt_players ).
        current_player = 1.
      ENDIF.

      r_did_win = winner.
    ENDIF.
  ENDMETHOD.


  METHOD wrong_answer.
   msg = 'Question was incorrectly answered'.
   log_msg msg.

   msg = |{ gt_players[ me->current_player ] } was sent to the penalty box|.
   log_msg msg.

    gt_is_in_penalty_box[ me->current_player ] = abap_true.

    current_player = current_player + 1.
    IF current_player > lines( gt_players ).
      current_player = 1.
    ENDIF.

    r_result = abap_true.
  ENDMETHOD.
ENDCLASS.
