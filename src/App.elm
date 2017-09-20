module App exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket as WS


-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    {} ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WS.listen "ws://localhost:8000" WSMessageReceived



-- UPDATE


type Msg
    = WSMessageReceived String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WSMessageReceived message ->
            handleWSMessage model message


handleWSMessage : Model -> String -> ( Model, Cmd Msg )
handleWSMessage model message =
    model ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text "Hello world" ]
