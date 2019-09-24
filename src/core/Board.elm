module Board exposing (..)

import Array exposing (..)


grid =
    List.range 1 (gridSize * gridSize)


gridSize =
    3


cells =
    List.map (\x -> String.fromInt x) grid


makeMove number mark =
    set (number - 1) mark (fromList cells)
        |> toList


availableMoves board =
    List.filter (\x -> x /= "X" && x /= "O") board
