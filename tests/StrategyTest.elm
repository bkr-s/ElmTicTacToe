module StrategyTest exposing (suite)

import Board as Board
import Expect
import Player
import Strategy as Strategy
import Test exposing (Test, describe, test)


blankDummyBoard =
    Board.initialBoard


nought =
    Player.O


cross =
    Player.X


boardWithTwoMoves =
    Board.markBoard 5 cross <|
        Board.markBoard 2 nought <|
            Board.markBoard 4 cross <|
                Board.markBoard 1 nought blankDummyBoard


suite : Test
suite =
    describe "the Strategy module"
        [ test "knows player can win on the next move" <|
            \() ->
                Expect.true "has two out of three moves" (Strategy.checkSingleLineForMatches [ 0, 1, 2 ] 2 nought boardWithTwoMoves)
        ]
