module Main exposing (Model)

import Array exposing (Array)
import Board exposing (Board)
import Dict
import Html exposing (Attribute, Html, button, div, h1, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Player exposing (Player)



-- MODEL2


type alias Model =
    { board : Board, currentPlayer : Player, otherPlayer : Player, count : Int }


initModel : Model
initModel =
    { board = Board.initBoard, currentPlayer = Player.X, otherPlayer = Player.O, count = 0 }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ centreAlign ] [ text "Welcome To Tic Tac Toe" ]
        , div [ class "displayGrid", centreAlign ]
            [ displayGrid (List.map viewBoard (Dict.values model.board))
            ]
        ]


viewBoard : Player -> String
viewBoard player =
    case player of
        Player.X ->
            "X"

        Player.O ->
            "O"

        Player.Unclaimed ->
            "blank"


displayGrid : List String -> Html Msg
displayGrid grid =
    Array.fromList grid
        |> formatBoxes


formatBoxes : Array String -> Html Msg
formatBoxes allBoxes =
    div []
        [ p [ padRow ]
            [ button [ onClick Increment ] [ text (Array.get 0 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 1 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 2 allBoxes |> Maybe.withDefault "") ]
            ]
        , p [ padRow ]
            [ button [ onClick Increment ] [ text (Array.get 3 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 4 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 5 allBoxes |> Maybe.withDefault "") ]
            ]
        , p [ padRow ]
            [ button [ onClick Increment ] [ text (Array.get 6 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 7 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick Increment ] [ text (Array.get 8 allBoxes |> Maybe.withDefault "") ]
            ]
        ]


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 2 }

        Decrement ->
            { model | count = model.count - 3 }


padRow : Attribute a
padRow =
    style "padding" "0.5em"


centreAlign : Attribute a
centreAlign =
    style "text-align" "center"



-- UPDATE
-- MAIN


main : Html Msg
main =
    view
        initModel
