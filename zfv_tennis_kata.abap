*&---------------------------------------------------------------------*
*& Report zmp_tennis_kata_start
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&   Tennis Game Requirements Specification
*&---------------------------------------------------------------------*
*&
*& Tennis has a rather quirky scoring system, and to newcomers it
*& can be a little difficult to keep track of. The local tennis club
*& has bought a new scoreboard that shows the new score when a player
*& scores a point. They now need you to develop a program to determine
*& that score (and to show it on the scoreboard, but that's not part
*& of this exercise).
*&
*& Summary of Tennis scoring:
*& 1. A game is won by the first player to have won at least four points
*&    in total and at least two points more than the opponent.
*& 2. The running score of each game is described in a manner peculiar
*&    to tennis: scores from zero to three points are described as “love”,
*&    “fifteen”, “thirty”, and “forty” respectively.
*& 3. If at least three points have been scored by each player, and the
*&    scores are equal, the score is reported as “deuce”.
*& 4. If at least three points have been scored by each side and a player
*&    has one more point than his opponent, the score of the game is
*&    “advantage” for the player in the lead.
*&
*& You need only report the current game score.
*& Sets and Matches are out of scope.
*&
*& Rules for modifying this starting point program (ie your copy of it):
*& 1. You can add other public (and of course private) methods to the
*&    production code.
*& 2. You may also create a constructor and add parameters to it.
*& 3. You can and should add test cases, in true TDD style
*& 4. The interface is fixed
*& 5. In the test fixtures you can and should use the point_won_by method
*&    repeatedly and afterwards the get_score method, then compare to
*&    expected result. Example test case just happens to have zero
*&    occurrences of the point_won_by method ;-).
*& 5. Refactoring test code is encouraged ;-)


*&---------------------------------------------------------------------*


PROGRAM zfv_tennis_kata.

*& Production Code
INTERFACE lif_tennis_game.
  METHODS:
    point_won_by
      IMPORTING iv_player_name TYPE string,
    get_score
      RETURNING VALUE(rv_score) TYPE string.
ENDINTERFACE.

CLASS lcl_tennis_game DEFINITION.

  PUBLIC SECTION.
    INTERFACES: lif_tennis_game.

    METHODS: constructor IMPORTING iv_1st_player TYPE string
                                   iv_2nd_player TYPE string.

  PRIVATE SECTION.

    DATA: mv_1st_player TYPE string,
          mv_2nd_player TYPE string,
          mv_score      TYPE string.

ENDCLASS.

CLASS lcl_tennis_game IMPLEMENTATION.


  METHOD lif_tennis_game~get_score.
    rv_score = mv_score.
  ENDMETHOD.

  METHOD lif_tennis_game~point_won_by.

    IF iv_player_name = mv_1st_player.
      mv_score = 'Fifteen, Love'.
    ELSEIF iv_player_name = mv_2nd_player.
      mv_score = 'Fifteen All'.
    ENDIF.

  ENDMETHOD.

  METHOD constructor.

    mv_1st_player = iv_1st_player.
    mv_2nd_player = iv_2nd_player.
    mv_score = 'Love all'.

  ENDMETHOD.

ENDCLASS.


*& Test code

CLASS ltc_tennis_game DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.

  PUBLIC SECTION.

    METHODS: new_game_yields_love_all FOR TESTING,
             player_1_wins_1st_pt_15_love FOR TESTING,
             both_players_win_once_15_all FOR TESTING,
             player_2_wins_1st_pt_love_15 FOR TESTING.


ENDCLASS.

CLASS ltc_tennis_game IMPLEMENTATION.

  METHOD new_game_yields_love_all.

    "arrange
    DATA(lo_tennis_game) = NEW lcl_tennis_game( iv_1st_player = 'dummy1' iv_2nd_player = 'dummy2' ).

    "act + assert
    cl_abap_unit_assert=>assert_equals( msg = 'New game should result in Love all' exp = 'Love all' act = lo_tennis_game->lif_tennis_game~get_score( ) ).

  ENDMETHOD.

*& Other test cases (not fully worked out, just to make sure you understand the requirements

*& Player one wins first point: score = 'Fifteen, Love'.
*& Player two wins first 2 points: score = 'Love, Thirty'.
*& Both players win 2 points: score = 'Thirty all'.
*& Both players win >= 3 points: score = 'Deuce'
*& After deuce, player one wins the next point: score = 'Advantage' + && <name_of_player_one>
*& Player two wins the game: score = <name_of_player_two> && 'wins!'




  METHOD player_1_wins_1st_pt_15_love.

    "arrange
    DATA(lo_tennis_game) = NEW lcl_tennis_game( iv_1st_player = 'Player One' iv_2nd_player = 'dummy2' ).
    lo_tennis_game->lif_tennis_game~point_won_by( iv_player_name = 'Player One' ).

    "act
    DATA(lv_score) = lo_tennis_game->lif_tennis_game~get_score( ).

    "assert
    cl_abap_unit_assert=>assert_equals( msg = 'Score should be \"Fifteen, Love\"' exp = 'Fifteen, Love' act = lv_score ).

  ENDMETHOD.

  METHOD both_players_win_once_15_all.

    "arrange
    DATA(lo_tennis_game) = NEW lcl_tennis_game( iv_1st_player = 'Player One' iv_2nd_player = 'Player Two' ).
    lo_tennis_game->lif_tennis_game~point_won_by( iv_player_name = 'Player One' ).
    lo_tennis_game->lif_tennis_game~point_won_by( iv_player_name = 'Player Two' ).

    "act
    DATA(lv_score) = lo_tennis_game->lif_tennis_game~get_score( ).

    "assert
    cl_abap_unit_assert=>assert_equals( msg = 'Score should be \"Fifteen All\"' exp = 'Fifteen All' act = lv_score ).

  ENDMETHOD.

  METHOD player_2_wins_1st_pt_love_15.

    "arrange
    DATA(lo_tennis_game) = NEW lcl_tennis_game( iv_1st_player = 'Player One' iv_2nd_player = 'Player Two' ).
    lo_tennis_game->lif_tennis_game~point_won_by( iv_player_name = 'Player Two' ).

    "act
    DATA(lv_score) = lo_tennis_game->lif_tennis_game~get_score( ).

    "assert
    cl_abap_unit_assert=>assert_equals( msg = 'Score should be \"Love, Fifteen\"' exp = 'Love, Fifteen' act = lv_score ).

  ENDMETHOD.

ENDCLASS.