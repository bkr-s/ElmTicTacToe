module Player exposing (..)

import Array exposing (Array)


type Player
    = X
    | O
    | Unclaimed


getOpponent : Player -> Player
getOpponent player =
    case player of
        X ->
            O

        O ->
            X

        Unclaimed ->
            Unclaimed


showPlayer : Player -> String
showPlayer player =
    case player of
        X ->
            "X"

        O ->
            "O"

        Unclaimed ->
            ""


value : Array String -> Int -> String
value grid index =
    Array.get index grid |> Maybe.withDefault ""
