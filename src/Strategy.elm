module Strategy exposing (checkSingleLineForMatches)

import Array exposing (get)
import Board exposing (Board)
import Dict
import Player exposing (Player(..))


type Strategy
    = Win
    | Block
    | Fork
    | BlockFork
    | Center
    | OppositeCorner
    | EmptyCorner
    | EmptySide


winningLines : List (List Int)
winningLines =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 2, 4, 6 ]
    , [ 0, 4, 8 ]
    ]



-- Win
-- get a list of all the positions claimed and unclaimed
-- go through that list and check whether there are individual lines which have 2 out of 3 places claimed
-- for those with 2 out of 3 places claimed get the positions which are claimed and the positions which aren't
-- then check whether the two claimed places have the same mark
-- if they do get the third position and return it as the best move


checkSingleLineForMatches : List Int -> Int -> Player -> Board -> Bool
checkSingleLineForMatches lines numberOfMatches player board =
    lines
        |> List.map (\index -> get index (Array.fromList (Dict.values board)) |> Maybe.withDefault Unclaimed)
        |> List.filter (\x -> x == player)
        |> List.length
        |> (==) numberOfMatches
