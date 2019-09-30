module Board exposing (Board, availableMoves, hasPlayerWon, initBoard, isATie, isFull, isValidMove, markBoard)

import Array exposing (..)
import Dict exposing (Dict)
import List
import Player exposing (Player)



-- BOARD


type alias Board =
    Dict Int Player


initBoard : Board
initBoard =
    initGrid
        |> List.foldl (\keyIndex valueDict -> Dict.insert keyIndex Player.Unclaimed valueDict) Dict.empty



---- INIT BOARD
--@private functions


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



-- UPDATE


isValidMove : Int -> Board -> Bool
isValidMove position board =
    List.member position (availableMoves board)


markBoard : Int -> Player -> Board -> Board
markBoard position player board =
    Dict.update position (\_ -> Just player) board


hasPlayerWon : Player -> Board -> Bool
hasPlayerWon player board =
    checkAllLines player board


isFull : Dict Int Player -> Bool
isFull board =
    Dict.values board
        |> List.all (\x -> x /= Player.Unclaimed)


isATie : Board -> Bool
isATie board =
    isFull board && not (hasPlayerWon Player.X board) && not (hasPlayerWon Player.O board)



--@private functions


availableMoves : Board -> List Int
availableMoves board =
    Dict.keys board
        |> List.filter (\index -> Dict.get index board == Just Player.Unclaimed)


checkAllLines : Player -> Board -> Bool
checkAllLines player board =
    winningLines
        |> List.map (\lines -> checkSingleLine player lines board)
        |> List.filter ((==) True)
        |> List.isEmpty
        |> not


checkSingleLine : Player -> List Int -> Board -> Bool
checkSingleLine player lines board =
    lines
        |> List.map (\index -> get index (Array.fromList (Dict.values board)) |> Maybe.withDefault Player.Unclaimed)
        |> List.filter (\x -> x == player)
        |> List.length
        |> (==) gridSize
