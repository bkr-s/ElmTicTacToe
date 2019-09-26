module BoardTest exposing (suite)

import Board as Board
import Dict exposing (values)
import Expect exposing (Expectation)
import List
import Player
import Test exposing (Test, describe, test)


boardGrid =
    Board.initBoard


nought =
    Player.O


cross =
    Player.X


fullBoardWithNoWinners =
    Board.markBoardIfValidMove 7 cross <|
        Board.markBoardIfValidMove 9 nought <|
            Board.markBoardIfValidMove 6 cross <|
                Board.markBoardIfValidMove 8 nought <|
                    Board.markBoardIfValidMove 5 cross <|
                        Board.markBoardIfValidMove 4 nought <|
                            Board.markBoardIfValidMove 2 cross <|
                                Board.markBoardIfValidMove 3 nought <|
                                    Board.markBoardIfValidMove 1 cross boardGrid


boardWithXAsTheWinner =
    Board.markBoardIfValidMove 3 cross <|
        Board.markBoardIfValidMove 5 nought <|
            Board.markBoardIfValidMove 2 cross <|
                Board.markBoardIfValidMove 4 nought <|
                    Board.markBoardIfValidMove 1 cross boardGrid


boardWithOAsTheWinner =
    Board.markBoardIfValidMove 7 nought <|
        Board.markBoardIfValidMove 5 cross <|
            Board.markBoardIfValidMove 4 nought <|
                Board.markBoardIfValidMove 2 cross <|
                    Board.markBoardIfValidMove 1 nought boardGrid


suite : Test
suite =
    describe "The Board module"
        [ test "marks the board if the move is valid" <|
            \() ->
                True
                    |> Expect.equal (List.member cross (Dict.values (Board.markBoardIfValidMove 1 cross boardGrid)))
        , test "does not mark the board if the move is not valid" <|
            \() ->
                False
                    |> Expect.equal (List.member nought (values (Board.markBoardIfValidMove 1 nought <| Board.markBoardIfValidMove 1 cross boardGrid)))
        , test "knows the available moves" <|
            \() ->
                Expect.false "Exp: position 1 is unavailable" (List.member 1 <| Board.availableMoves <| Board.markBoardIfValidMove 1 cross boardGrid)
        , test "knows when a move is valid" <|
            \() ->
                Expect.true "Exp: valid move" (Board.isValidMove 1 boardGrid)
        , test "knows when a move is not valid" <|
            \() ->
                Expect.false "Exp: invalid move" (Board.isValidMove 2 <| Board.markBoardIfValidMove 2 nought boardGrid)
        , test "knows that the board is full" <|
            \() ->
                Expect.true "Exp: board is full" (Board.isFull fullBoardWithNoWinners)
        , test "knows that 'X' has won" <|
            \() ->
                Expect.true "Exp: player 'X' has won" (Board.hasPlayerWon cross boardWithXAsTheWinner)
        , test "knows that 'O' has won" <|
            \() ->
                Expect.true "Exp: player 'O' has won" (Board.hasPlayerWon nought boardWithOAsTheWinner)
        , test "knows the board is full and nobody has won" <|
            \() ->
                Expect.true "Exp: a tied board" (Board.isATie fullBoardWithNoWinners)
        ]
