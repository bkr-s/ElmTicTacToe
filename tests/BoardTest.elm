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
    Board.marksBoardIfValidMove 7 cross <|
        Board.marksBoardIfValidMove 9 nought <|
            Board.marksBoardIfValidMove 6 cross <|
                Board.marksBoardIfValidMove 8 nought <|
                    Board.marksBoardIfValidMove 5 cross <|
                        Board.marksBoardIfValidMove 4 nought <|
                            Board.marksBoardIfValidMove 2 cross <|
                                Board.marksBoardIfValidMove 3 nought <|
                                    Board.marksBoardIfValidMove 1 cross boardGrid


boardWithXAsTheWinner =
    Board.marksBoardIfValidMove 3 cross <|
        Board.marksBoardIfValidMove 5 nought <|
            Board.marksBoardIfValidMove 2 cross <|
                Board.marksBoardIfValidMove 4 nought <|
                    Board.marksBoardIfValidMove 1 cross boardGrid


boardWithOAsTheWinner =
    Board.marksBoardIfValidMove 7 nought <|
        Board.marksBoardIfValidMove 5 cross <|
            Board.marksBoardIfValidMove 4 nought <|
                Board.marksBoardIfValidMove 2 cross <|
                    Board.marksBoardIfValidMove 1 nought boardGrid


suite : Test
suite =
    describe "The Board module"
        [ test "marks the board if the move is valid" <|
            \() ->
                True
                    |> Expect.equal (List.member "X" (values (Board.marksBoardIfValidMove 1 cross boardGrid))
        , test "does not mark the board if the move is not valid" <|
            \() ->
                False
                    |> Expect.equal (List.member nought (Board.marksBoardIfValidMove 1 nought <| Board.marksBoardIfValidMove 1 cross boardGrid))
        , test "knows the available moves" <|
            \() ->
                Expect.false "Exp: position 1 is unavailable" (List.member 1 <| Board.availableMoves <| Board.marksBoardIfValidMove 1 cross boardGrid)
        , test "knows when a move is valid" <|
            \() ->
                Expect.true "Exp: valid move" (Board.isValidMove 1 boardGrid)
        , test "knows when a move is not valid" <|
            \() ->
                Expect.false "Exp: invalid move" (Board.isValidMove 2 <| Board.marksBoardIfValidMove 2 nought boardGrid)
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
