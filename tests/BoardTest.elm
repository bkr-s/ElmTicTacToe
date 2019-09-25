module BoardTest exposing (..)

import Board exposing (board)
import Expect exposing (Expectation)
import List
import Test exposing (..)


boardGrid =
    Board.getGrid { grid = board.grid }


naught =
    "O"


cross =
    "X"


fullBoard =
    Board.marksBoardIfValidMove 7 cross <|
        Board.marksBoardIfValidMove 9 naught <|
            Board.marksBoardIfValidMove 6 cross <|
                Board.marksBoardIfValidMove 8 naught <|
                    Board.marksBoardIfValidMove 5 cross <|
                        Board.marksBoardIfValidMove 4 naught <|
                            Board.marksBoardIfValidMove 2 cross <|
                                Board.marksBoardIfValidMove 3 naught <|
                                    Board.marksBoardIfValidMove 1 cross boardGrid


boardWithXAsTheWinner =
    Board.marksBoardIfValidMove 3 cross <|
        Board.marksBoardIfValidMove 5 naught <|
            Board.marksBoardIfValidMove 2 cross <|
                Board.marksBoardIfValidMove 4 naught <|
                    Board.marksBoardIfValidMove 1 cross boardGrid


suite : Test
suite =
    describe "The Board module"
        [ test "marks the board" <|
            \() ->
                True
                    |> Expect.equal (List.member "X" (Board.marksBoardIfValidMove 1 "X" boardGrid))
        , test "knows the available moves" <|
            \() ->
                Expect.false "Exp: position 1 is unavailable" (List.member "1" <| Board.availableMoves <| Board.marksBoardIfValidMove 1 "X" boardGrid)
        , test "knows when a move is valid" <|
            \() ->
                Expect.true "Exp: valid move" (Board.isValidMove 1 boardGrid)
        , test "knows when a move is not valid" <|
            \() ->
                Expect.false "Exp: invalid move" (Board.isValidMove 2 <| Board.marksBoardIfValidMove 2 "O" boardGrid)
        , test "knows that the board is full" <|
            \() ->
                Expect.true "Exp: board is full" (Board.isFull fullBoard)
        , test "knows that 'X' has won" <|
            \() ->
                Expect.true "Exp: player 'X' has won" (Board.hasPlayerWon cross boardWithXAsTheWinner)
        ]
