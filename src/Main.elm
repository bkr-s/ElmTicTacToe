module Main exposing (Model)

import Array exposing (Array)
import Board exposing (Board)
import Browser
import Dict
import Html exposing (Attribute, Html, button, div, h1, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Player exposing (Player)



-- MODEL


type alias Model =
    { board : Board, currentPlayer : Player, computerPlayer : Maybe Player, status : GameStatus }


initialModel : Model
initialModel =
    { board = Board.initBoard, currentPlayer = Player.X, computerPlayer = Nothing, status = NewGame }


type GameStatus
    = NewGame
    | Playing
    | Winner Player
    | Drawn


type Msg
    = HumanVsHuman
    | HumanVsEasyComputer
    | TakeTurn Int
    | ResetGame
    | NoOp



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ centreAlign, font ] [ text "Welcome To Tic Tac Toe" ]
        , displayGameMenu model
        , div [ class "displayGrid", centreAlign ]
            [ displayGrid (List.map showPlayerAtPosition (Dict.values model.board))
            ]
        ]


displayGameMenu : Model -> Html Msg
displayGameMenu model =
    let
        newGameButtons =
            case model.status of
                Playing ->
                    text ""

                _ ->
                    div [ centreAlign ]
                        [ text "Start new game: "
                        , buttonNewGame "2 Player" HumanVsHuman
                        , buttonNewGame "1 Player (Easy)" HumanVsEasyComputer
                        ]
    in
    div [ class "gameMenu" ] [ newGameButtons ]


showPlayerAtPosition : Player -> String
showPlayerAtPosition player =
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
            [ button [ onClick (TakeTurn 1) ] [ text (currentPlayerValue allBoxes 0) ]
            , button [ onClick (TakeTurn 2) ] [ text (currentPlayerValue allBoxes 1) ]
            , button [ onClick (TakeTurn 3) ] [ text (currentPlayerValue allBoxes 2) ]
            ]
        , div [ padRow ]
            [ button [ onClick (TakeTurn 4) ] [ text (currentPlayerValue allBoxes 3) ]
            , button [ onClick (TakeTurn 5) ] [ text (currentPlayerValue allBoxes 4) ]
            , button [ onClick (TakeTurn 6) ] [ text (currentPlayerValue allBoxes 5) ]
            ]
        , div [ padRow ]
            [ button [ onClick (TakeTurn 7) ] [ text (currentPlayerValue allBoxes 6) ]
            , button [ onClick (TakeTurn 8) ] [ text (currentPlayerValue allBoxes 7) ]
            , button [ onClick (TakeTurn 9) ] [ text (currentPlayerValue allBoxes 8) ]
            ]
        ]


currentPlayerValue : Array String -> Int -> String
currentPlayerValue gridArray index =
    Array.get index gridArray |> Maybe.withDefault ""


font : Attribute a
font =
    style "font-family" "sans-serif"


centreAlign : Attribute a
centreAlign =
    style "text-align" "center"


padRow : Attribute a
padRow =
    style "padding" "0.5em"



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        HumanVsHuman ->
            { initialModel | status = Playing }

        HumanVsEasyComputer ->
            { initialModel | computerPlayer = Just Player.O, status = Playing }

        TakeTurn position ->
            let
                newModel =
                    if canContinue model && Board.isValidMove position model.board then
                        { model | board = Board.markBoard position model.currentPlayer model.board }
                            |> checkGameStatus

                    else
                        model

                addComputerMoveIfRelevant =
                    if isComputerTurn newModel && canContinue newModel then
                        getComputerMove newModel
                            |> checkGameStatus

                    else
                        newModel
            in
            addComputerMoveIfRelevant

        ResetGame ->
            initialModel

        NoOp ->
            model


buttonNewGame : String -> Msg -> Html Msg
buttonNewGame buttonText msg =
    button [ class "newGame", onClick msg ] [ text buttonText ]


canContinue : Model -> Bool
canContinue model =
    model.status == Playing || model.status == NewGame


checkGameStatus : Model -> Model
checkGameStatus ({ board, currentPlayer } as model) =
    let
        isWinningPlayer =
            Board.hasPlayerWon currentPlayer board

        isDrawnGame =
            Board.isATie board

        ( newStatus, newCurrent ) =
            case ( isWinningPlayer, isDrawnGame ) of
                ( True, False ) ->
                    ( Winner currentPlayer, currentPlayer )

                ( False, True ) ->
                    ( Drawn, currentPlayer )

                ( False, False ) ->
                    ( Playing, getOpponent currentPlayer )

                ( _, _ ) ->
                    ( NewGame, Player.X )
    in
    { model | status = newStatus, currentPlayer = newCurrent }


getOpponent : Player -> Player
getOpponent player =
    case player of
        Player.X ->
            Player.O

        Player.O ->
            Player.X

        Player.Unclaimed ->
            Player.Unclaimed


isComputerTurn : Model -> Bool
isComputerTurn ({ board, currentPlayer, computerPlayer } as model) =
    if isComputerPlayer currentPlayer model && (model.status == Playing) then
        True

    else
        False


isComputerPlayer : Player -> Model -> Bool
isComputerPlayer currentPlayer model =
    case model.computerPlayer of
        Just computerPlayer ->
            currentPlayer == computerPlayer

        _ ->
            False


getComputerMove : Model -> Model
getComputerMove model =
    case computerSelectsRandomMove (Board.availableMoves model.board) of
        Just move ->
            { model | board = Board.markBoard move model.currentPlayer model.board }

        Nothing ->
            model


computerSelectsRandomMove : List Int -> Maybe Int
computerSelectsRandomMove availablePositions =
    List.head availablePositions



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
