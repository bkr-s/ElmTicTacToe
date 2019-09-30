module Main exposing (Model)

import Array exposing (Array)
import Board exposing (Board)
import Browser
import Dict
import Html exposing (Attribute, Html, button, div, h1, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Player exposing (Player)



-- MODEL2


type alias Model =
    { board : Board, currentPlayer : Player, otherPlayer : Player, tempBoard : Board, status : GameStatus }


initModel : Model
initModel =
    { board = Board.initBoard, currentPlayer = Player.X, otherPlayer = Player.O, tempBoard = Board.initBoard, status = NewGame }


type GameStatus
    = NewGame
    | InProgress
    | Winner Player
    | Drawn



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ centreAlign, font ] [ text "Welcome To Tic Tac Toe" ]
        , div [ class "displayGrid", centreAlign ]
            [ displayGrid (List.map getPlayer (Dict.values model.board))
            ]
        ]


getPlayer : Player -> String
getPlayer player =
    case player of
        Player.X ->
            "X"

        Player.O ->
            "O"

        Player.Unclaimed ->
            ""


displayGrid : List String -> Html Msg
displayGrid grid =
    Array.fromList grid
        |> formatBoxes


formatBoxes : Array String -> Html Msg
formatBoxes allBoxes =
    div []
        [ div [ padRow ]
            [ button [ onClick (TakeTurn 1) ] [ text (Array.get 0 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 2) ] [ text (Array.get 1 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 3) ] [ text (Array.get 2 allBoxes |> Maybe.withDefault "") ]
            ]
        , div [ padRow ]
            [ button [ onClick (TakeTurn 4) ] [ text (Array.get 3 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 5) ] [ text (Array.get 4 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 6) ] [ text (Array.get 5 allBoxes |> Maybe.withDefault "") ]
            ]
        , div [ padRow ]
            [ button [ onClick (TakeTurn 7) ] [ text (Array.get 6 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 8) ] [ text (Array.get 7 allBoxes |> Maybe.withDefault "") ]
            , button [ onClick (TakeTurn 9) ] [ text (Array.get 8 allBoxes |> Maybe.withDefault "") ]
            ]
        ]


padRow : Attribute a
padRow =
    style "padding" "0.5em"


centreAlign : Attribute a
centreAlign =
    style "text-align" "center"


font : Attribute a
font =
    style "font-family" "sans-serif"



-- UPDATE


type Msg
    = TakeTurn Int
    | ResetGame
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        TakeTurn position ->
            if (model.status == InProgress || model.status == NewGame) && Board.isValidMove position model.board then
                { model | board = Board.markBoard position model.currentPlayer model.board }
                    |> checkStatus

            else
                model

        ResetGame ->
            initModel

        NoOp ->
            model


checkStatus : Model -> Model
checkStatus ({ board, currentPlayer, otherPlayer } as model) =
    let
        isWinningPlayer =
            Board.hasPlayerWon currentPlayer board

        isDrawnGame =
            Board.isATie board

        ( newStatus, newCurrent, newOther ) =
            case ( isWinningPlayer, isDrawnGame ) of
                ( True, False ) ->
                    ( Winner currentPlayer, currentPlayer, otherPlayer )

                ( False, True ) ->
                    ( Drawn, currentPlayer, otherPlayer )

                ( False, False ) ->
                    ( InProgress, otherPlayer, currentPlayer )

                ( _, _ ) ->
                    ( NewGame, otherPlayer, currentPlayer )
    in
    { model | status = newStatus, currentPlayer = newCurrent, otherPlayer = newOther }



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
