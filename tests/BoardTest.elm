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
    Board.markBoard 7 cross <|
        Board.markBoard 9 nought <|
            Board.markBoard 6 cross <|
                Board.markBoard 8 nought <|
                    Board.markBoard 5 cross <|
                        Board.markBoard 4 nought <|
                            Board.markBoard 2 cross <|
                                Board.markBoard 3 nought <|
                                    Board.markBoard 1 cross boardGrid


boardWithXAsTheWinner =
    Board.markBoard 3 cross <|
        Board.markBoard 5 nought <|
            Board.markBoard 2 cross <|
                Board.markBoard 4 nought <|
                    Board.markBoard 1 cross boardGrid


boardWithOAsTheWinner =
    Board.markBoard 7 nought <|
        Board.markBoard 5 cross <|
            Board.markBoard 4 nought <|
                Board.markBoard 2 cross <|
                    Board.markBoard 1 nought boardGrid


suite : Test
suite =
    describe "The Board module"
        [ test "marks the board" <|
            \() ->
                True
                    |> Expect.equal (List.member cross (Dict.values (Board.markBoard 1 cross boardGrid)))
        , test "knows the available moves" <|
            \() ->
                Expect.false "Exp: position 1 is unavailable" (List.member 1 <| Board.availableMoves <| Board.markBoard 1 cross boardGrid)
        , test "knows when a move is valid" <|
            \() ->
                Expect.true "Exp: valid move" (Board.isValidMove 1 boardGrid)
        , test "knows when a move is not valid" <|
            \() ->
                Expect.false "Exp: invalid move" (Board.isValidMove 2 <| Board.markBoard 2 nought boardGrid)
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
