module Board exposing (Board, availableMoves, hasPlayerWon, initBoard, isATie, isFull, isValidMove, marksBoardIfValidMove)

import Array exposing (..)
import Dict exposing (Dict)
import List
import Player exposing (Player)


type alias Board =
    Dict Int (Maybe Player)


initBoard : Dict Int (Maybe Player)
initBoard =
    initGrid
        |> List.foldl (\index dict -> Dict.insert index Nothing dict) Dict.empty



-- GRID INITIALISERS


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


marksBoardIfValidMove : Int -> Player -> Dict Int (Maybe Player) -> Dict Int (Maybe Player)
marksBoardIfValidMove position player board =
    if isValidMove position board then
        markBoard position player board

    else
        board


isValidMove : Int -> Dict Int (Maybe Player) -> Bool
isValidMove position board =
    List.member position (availableMoves board)


markBoard : Int -> Player -> Dict Int (Maybe Player) -> Dict Int (Maybe Player)
markBoard position player board =
    Dict.update position (player |> Just |> Just |> always) board


availableMoves : Dict Int (Maybe Player) -> List Int
availableMoves board =
    Dict.keys board
        |> List.filter (\x -> Dict.get x board /= Nothing)


isFull : Dict Int (Maybe Player) -> Bool
isFull board =
    Dict.values board
        |> List.all (\x -> x /= Nothing || x /= Nothing)


hasPlayerWon : Player -> Dict Int (Maybe Player) -> Bool
hasPlayerWon player board =
    checkAllLines player board


checkAllLines : Player -> Dict Int (Maybe Player) -> Bool
checkAllLines player board =
    winningLines
        |> List.map (\lines -> checkSingleLine player lines board)
        |> List.filter ((==) True)
        |> List.isEmpty
        |> not


checkSingleLine : Player -> List Int -> Dict Int (Maybe Player) -> Bool
checkSingleLine player lines board =
    lines
        --    ?? needs case
        |> List.map (\index -> get index (Array.fromList (Dict.values board)) |> Maybe.withDefault Nothing)
        |> List.filter (\x -> x == player)
        |> List.length
        |> (==) gridSize


isATie : Dict Int (Maybe Player) -> Bool
isATie board =
    isFull board && not (hasPlayerWon Player.X board) && not (hasPlayerWon Player.O board)



--    set (position - 1) mark (Array.fromList board)
--        |> Array.toList
-- @private
--updateBoard : Int -> String -> List (Maybe Player) -> { grid : List String }
--updateBoard position mark board =
--    { grid = markBoard position mark board }
-- CURRENT GRID
--currentBoard : Dict Int (Maybe Player) -> Dict Int (Maybe Player)
--currentBoard board =
--    Board
-- ACTIONS ON BOARD
