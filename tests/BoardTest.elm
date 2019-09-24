module BoardTest exposing (..)

import Board exposing (board)
import Expect exposing (Expectation)
import List
import Test exposing (..)


boardGrid =
    Board.cells board


markOne =
    "X"


markTwo =
    "O"


fullBoard =
    Board.makeMove 7 markOne <|
        Board.makeMove 9 markTwo <|
            Board.makeMove 6 markOne <|
                Board.makeMove 8 markTwo <|
                    Board.makeMove 5 markOne <|
                        Board.makeMove 4 markTwo <|
                            Board.makeMove 2 markOne <|
                                Board.makeMove 3 markTwo <|
                                    Board.makeMove 1 markOne boardGrid


suite : Test
suite =
    describe "The Board module"
        [ test "board takes a move" <|
            \() ->
                True
                    |> Expect.equal (List.member "X" (Board.makeMove 1 "X" boardGrid))
        , test "board knows the available moves" <|
            \() ->
                Expect.false "Exp: position 1 is unavailable" (List.member "1" <| Board.availableMoves <| Board.makeMove 1 "X" boardGrid)
        , test "board knows when a move is valid" <|
            \() ->
                Expect.true "Exp: valid move" (Board.isValidMove 1 boardGrid)
        , test "board knows when a move is not valid" <|
            \() ->
                Expect.false "Exp: invalid move" (Board.isValidMove 2 <| Board.makeMove 2 "O" boardGrid)
        , test "knows that the board is full" <|
            \() ->
                Expect.true "Exp: board is full" (Board.isFull fullBoard)
        ]
