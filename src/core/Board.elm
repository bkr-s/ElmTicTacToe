module Board exposing (availableMoves, getGrid, hasPlayerWon, initBoard, isATie, isFull, isValidMove, marksBoardIfValidMove)

import Array exposing (..)
import List
import String


type alias Board =
    { grid : List String }


initBoard : Board
initBoard =
    { grid = initGrid }



-- GRID INITIALISERS


initGrid : List String
initGrid =
    List.range 1 (gridSize * gridSize)
        |> List.map (\x -> String.fromInt x)


gridSize : Int
gridSize =
    3



-- WINNING COMBINATIONS
-- @private


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



-- CURRENT GRID


getGrid : { grid : List String } -> List String
getGrid boardRecord =
    List.map (\x -> x) boardRecord.grid



-- ACTIONS ON BOARD


marksBoardIfValidMove : Int -> String -> List String -> List String
marksBoardIfValidMove position mark currentBoard =
    if isValidMove position currentBoard then
        getGrid <| updateGrid position mark currentBoard

    else
        currentBoard


isValidMove : Int -> List String -> Bool
isValidMove move currentBoard =
    List.member (String.fromInt move) (availableMoves currentBoard)



--@private


markBoard : Int -> String -> List String -> List String
markBoard position mark currentBoard =
    set (position - 1) mark (Array.fromList currentBoard)
        |> Array.toList



-- @private


updateGrid : Int -> String -> List String -> { grid : List String }
updateGrid position mark currentBoard =
    { grid = markBoard position mark currentBoard }


availableMoves : List String -> List String
availableMoves currentBoard =
    List.filter (\x -> x /= "X" && x /= "O") currentBoard


isFull : List String -> Bool
isFull currentBoard =
    List.all (\x -> x == "X" || x == "O") currentBoard


hasPlayerWon : String -> List String -> Bool
hasPlayerWon mark currentBoard =
    checkAllLines mark currentBoard



-- @private


checkAllLines : String -> List String -> Bool
checkAllLines mark currentBoard =
    winningLines
        |> List.map (\lines -> checkSingleLine mark lines currentBoard)
        |> List.filter ((==) True)
        |> List.isEmpty
        |> not



-- @private


checkSingleLine : String -> List Int -> List String -> Bool
checkSingleLine mark lines currentBoard =
    lines
        |> List.map (\index -> get index (Array.fromList currentBoard) |> Maybe.withDefault "")
        |> List.filter (\x -> x == mark)
        |> List.length
        |> (==) 3


isATie : List String -> Bool
isATie currentBoard =
    isFull currentBoard && not (hasPlayerWon "X" currentBoard) && not (hasPlayerWon "O" currentBoard)
