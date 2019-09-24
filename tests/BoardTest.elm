module BoardTest exposing (..)

import Board
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "The Board module"
        [ test "board has a grid" <|
            \() ->
                [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
                    |> Expect.equal Board.cells
        , test "board takes a move" <|
            \() ->
                True
                    |> Expect.equal (List.member "X" (Board.makeMove 1 "X"))
        ]
