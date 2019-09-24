module BoardTest exposing (..)

import Board
import Expect exposing (Expectation)
import Test exposing (..)


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
        ]
