module Board exposing (..)


grid =
    List.range 1 (gridSize * gridSize)


gridSize =
    3


cells =
    List.map (\x -> String.fromInt x) grid
