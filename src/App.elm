module App exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket as WS


-- MODEL


type alias Model =
    { wines : List Wine }


type alias Wine =
    { id : Int
    , name : String
    , price : Float
    , variety : String
    , appellation : String
    , winery : String
    , photoUrl : String
    , comments : List String
    , dateTasted : String
    }


init : ( Model, Cmd Msg )
init =
    { wines = [ wineExample ] } ! []


wineExample : Wine
wineExample =
    { id = 1
    , name = "James' sweet wine"
    , price = 15.0
    , variety = "Pinot Noir"
    , appellation = "Bordeaux"
    , winery = "James' Winery"
    , photoUrl = "http://pngimg.com/uploads/wine/wine_PNG9479.png"
    , comments = [ "Great!" ]
    , dateTasted = "1/1/2001"
    }


blankWine : Wine
blankWine =
    { id = 0
    , name = "bloop!"
    , price = 0
    , variety = ""
    , appellation = ""
    , winery = ""
    , photoUrl = ""
    , comments = [ "" ]
    , dateTasted = ""
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WS.listen "ws://localhost:8000" WSMessageReceived



-- UPDATE


type Msg
    = WSMessageReceived String
    | WineAdded


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WSMessageReceived message ->
            handleWSMessage model message

        WineAdded ->
            { model | wines = model.wines ++ [ createWineWithNewId model ] } ! []


handleWSMessage : Model -> String -> ( Model, Cmd Msg )
handleWSMessage model message =
    model ! []


createWineWithNewId : Model -> Wine
createWineWithNewId model =
    { blankWine | id = incrementWineId model }


incrementWineId : Model -> Int
incrementWineId model =
    Maybe.withDefault 0 (List.maximum (List.map .id model.wines)) + 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewPageTitle
        , viewWines model
        ]


viewPageTitle : Html Msg
viewPageTitle =
    div [ class "title h1" ] [ text "Welcome to Wine Club" ]


viewWines : Model -> Html Msg
viewWines model =
    div [] (List.map viewWine model.wines)


viewWine : Wine -> Html Msg
viewWine wine =
    ul [ class "wine" ]
        [ li [] [ text wine.name ]
        , li [] [ img [ src wine.photoUrl ] [] ]
        , li [] [ text (toString wine.price) ]
        , li [] [ text wine.variety ]
        , li [] [ text wine.appellation ]
        , li [] [ text wine.winery ]
        , li [] [ text (String.join " " wine.comments) ]
        , li [] [ text wine.dateTasted ]
        , button [ class "button is-small", onClick (WineAdded) ] [ text "add wine" ]
        ]


viewWineEdited : Wine -> Html Msg
viewWineEdited wine =
    div [ class "form" ]
        [ input
            [ class "input"
            , placeholder "Wine name"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine price"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine variety"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine appellation"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine winery"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine comments"
            ]
            []
        , input
            [ class "input"
            , placeholder "date tasted"
            ]
            []
        , input
            [ class "input"
            , placeholder "Wine photo url"
            ]
            []
        ]
