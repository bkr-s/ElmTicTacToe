module PlayerTest exposing (suite)

import Array
import Expect
import Player
import Test exposing (Test, describe, test)


nought =
    Player.O


cross =
    Player.X


suite : Test
suite =
    describe "the Player module"
        [ test "gets opponent mark" <|
            \() ->
                nought
                    |> Expect.equal (Player.getOpponent cross)
        , test "shows mark as string" <|
            \() ->
                "X"
                    |> Expect.equal (Player.showPlayer cross)
        , test "shows values" <|
            \() ->
                "O"
                    |> Expect.equal (Player.value (Array.fromList [ "X", "O" ]) 1)
        ]
