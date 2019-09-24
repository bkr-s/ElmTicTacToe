module BoardTest exposing (..)

import Board
import Expect exposing (Expectation)
import Test exposing (..)


boardGrid =
    Board.cells


suite : Test
suite =
    describe "The Board module"
        [ test "board takes a move" <|
            \() ->
                True
                    |> Expect.equal (List.member "X" (Board.makeMove 1 "X"))
        , test "board knows the available moves" <|
            \() ->
                Expect.false "Expected position 1 is unavailable" (List.member "1" <| Board.availableMoves <| Board.makeMove 1 "X")
        , test "board knows when a move is valid" <|
            \() ->
                Expect.true "Expected move is valid" (Board.isValidMove "1" boardGrid)
        , test "board knows when a move is not valid" <|
            \() ->
                Expect.false "Expected move is invalid" (Board.isValidMove "2" <| Board.makeMove 2 "O")
        ]
