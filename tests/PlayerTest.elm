module PlayerTest exposing (suite)

import Expect
import Player exposing (Player)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "the Player module"
        [ test "selects a move" <|
            \() ->
                1
                    |> Expect.equal (Player.selectMove 1)
        ]
