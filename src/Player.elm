module Player exposing (..)


type Player
    = X
    | O
    | Unclaimed


selectMove : Int -> Int
selectMove move =
    move
