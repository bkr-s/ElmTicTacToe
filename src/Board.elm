module Board exposing (Board, availableMoves, hasPlayerWon, initBoard, isATie, isFull, isValidMove, markBoardIfValidMove)

import Array exposing (..)
import Dict exposing (Dict)
import List
import Player exposing (Player)



-- BOARD


type alias Board =
    Dict Int Player


initBoard : Dict Int Player
initBoard =
    initGrid
        |> List.foldl (\keyIndex valueDict -> Dict.insert keyIndex Player.Unclaimed valueDict) Dict.empty



--@PRIVATE FUNCTIONS
---- init board


initGrid : List Int
initGrid =
    List.range 1 (gridSize * gridSize)


gridSize : Int
gridSize =
    3


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



---- update
-- UPDATE


markBoardIfValidMove : Int -> Player -> Dict Int Player -> Dict Int Player
markBoardIfValidMove position player board =
    if isValidMove position board then
        markBoard position player board

    else
        board


isValidMove : Int -> Dict Int Player -> Bool
isValidMove position board =
    List.member position (availableMoves board)


availableMoves : Dict Int Player -> List Int
availableMoves board =
    Dict.keys board
        |> List.filter (\index -> Dict.get index board == Just Player.Unclaimed)



--@private


markBoard : Int -> Player -> Dict Int Player -> Dict Int Player
markBoard position player board =
    Dict.update position (\_ -> Just player) board


isFull : Dict Int Player -> Bool
isFull board =
    Dict.values board
        |> List.all (\x -> x /= Player.Unclaimed)


isATie : Dict Int Player -> Bool
isATie board =
    isFull board && not (hasPlayerWon Player.X board) && not (hasPlayerWon Player.O board)


hasPlayerWon : Player -> Dict Int Player -> Bool
hasPlayerWon player board =
    checkAllLines player board



--@private


checkAllLines : Player -> Dict Int Player -> Bool
checkAllLines player board =
    winningLines
        |> List.map (\lines -> checkSingleLine player lines board)
        |> List.filter ((==) True)
        |> List.isEmpty
        |> not



--@private


checkSingleLine : Player -> List Int -> Dict Int Player -> Bool
checkSingleLine player lines board =
    lines
        |> List.map (\index -> get index (Array.fromList (Dict.values board)) |> Maybe.withDefault Player.Unclaimed)
        |> List.filter (\x -> x == player)
        |> List.length
        |> (==) gridSize
