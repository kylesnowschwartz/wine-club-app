module App exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports exposing (ImagePortData, fileSelected, fileContentRead)
import Json.Decode as JD


-- MODEL


type alias Model =
    { wines : List Wine }


type alias Wine =
    { appellation : String
    , comments : String
    , dateTasted : String
    , name : String
    , image : Maybe Image
    , price : Float
    , variety : String
    , winery : String
    , id : Int
    }


type alias Image =
    { contents : String
    , filename : String
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
    , appellation = "Burgandy"
    , winery = "James' Winery"
    , image = Nothing
    , comments = "Great!"
    , dateTasted = "1/1/2001"
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    fileContentRead ImageRead



-- UPDATE


type Msg
    = WineAdded
    | WineNameEdited Wine String
    | WinePriceEdited Wine String
    | WineAppellationEdited Wine String
    | WineVarietyEdited Wine String
    | WineWineryEdited Wine String
    | WineCommentsEdited Wine String
    | WineDateEdited Wine String
    | ImageSelected Wine
    | ImageRead ImagePortData


replaceIfUpdated : { a | id : b } -> { a | id : b } -> { a | id : b }
replaceIfUpdated updated a =
    if a.id == updated.id then
        updated
    else
        a


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImageSelected wine ->
            ( model, fileSelected (toString wine.id) )

        ImageRead data ->
            let
                newImage =
                    Just
                        { contents = data.contents
                        , filename = data.filename
                        }
            in
                { model
                    | wines =
                        List.map
                            (\w ->
                                if w.id == data.wineId then
                                    { w | image = newImage }
                                else
                                    w
                            )
                            model.wines
                }
                    ! []

        WineAdded ->
            { model | wines = model.wines ++ [ createWineWithNewId model ] } ! []

        WineNameEdited wine newName ->
            let
                updatedWine =
                    { wine | name = newName }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WinePriceEdited wine newPrice ->
            let
                updatedWine =
                    { wine | price = Result.withDefault 0.0 (String.toFloat newPrice) }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WineAppellationEdited wine newAppellation ->
            let
                updatedWine =
                    { wine | appellation = newAppellation }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WineVarietyEdited wine newVariety ->
            let
                updatedWine =
                    { wine | variety = newVariety }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WineWineryEdited wine newWinery ->
            let
                updatedWine =
                    { wine | winery = newWinery }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WineCommentsEdited wine newComments ->
            let
                updatedWine =
                    { wine | comments = newComments }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []

        WineDateEdited wine newDate ->
            let
                updatedWine =
                    { wine | dateTasted = newDate }
            in
                { model | wines = List.map (replaceIfUpdated updatedWine) model.wines } ! []


createWineWithNewId : Model -> Wine
createWineWithNewId model =
    { wineExample | id = incrementWineId model }


incrementWineId : Model -> Int
incrementWineId model =
    Maybe.withDefault 0 (List.maximum (List.map .id model.wines)) + 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "section has-pink-stripey-background" ]
        [ viewPageTitle
        , viewWines model
        ]


viewPageTitle : Html Msg
viewPageTitle =
    nav [ class "level" ]
        [ div [ class "level-item has-text-centered" ]
            [ p [ class "title has-text-primary", style [ ( "background-color", "white" ) ] ] [ text "Welcome to Wine Club" ]
            ]
        ]


viewWines : Model -> Html Msg
viewWines model =
    div [ class "container" ]
        [ div [ class "columns" ]
            [ div [ class "column" ]
                [ button [ class "button is-small is-primary", onClick (WineAdded) ] [ text "add wine" ]
                ]
            ]
        , div [ class "columns is-multiline" ] (List.map viewWine model.wines)
        ]


viewWine : Wine -> Html Msg
viewWine wine =
    div [ class "column is-one-third-desktop" ]
        [ div [ class "box has-text-white" ]
            [ ul [ class "wine" ]
                [ li []
                    [ label []
                        [ text "name: "
                        , input
                            [ class "input"
                            , onInput (WineNameEdited wine)
                            , value wine.name
                            ]
                            []
                        ]
                    ]
                , li []
                    [ div [ class "imageWrapper" ]
                        [ input
                            [ type_ "file"
                            , Html.Attributes.id <| toString wine.id
                            , on "change" (JD.succeed <| ImageSelected wine)
                            ]
                            []
                        , viewImagePreview wine.image
                        ]
                    ]
                , li []
                    [ label []
                        [ text "price: "
                        , input
                            [ class "input"
                            , onInput (WinePriceEdited wine)
                            , value (toString wine.price)
                            ]
                            []
                        ]
                    ]
                , li []
                    [ label []
                        [ text "variety: "
                        , input
                            [ class "input"
                            , onInput (WineVarietyEdited wine)
                            , value wine.variety
                            ]
                            []
                        ]
                    ]
                , li []
                    [ label []
                        [ text "appellation: "
                        , input
                            [ class "input"
                            , onInput (WineAppellationEdited wine)
                            , value wine.appellation
                            ]
                            []
                        ]
                    ]
                , li []
                    [ label []
                        [ text "winery: "
                        , input
                            [ class "input"
                            , onInput (WineWineryEdited wine)
                            , value wine.winery
                            ]
                            []
                        ]
                    ]
                , li []
                    [ label []
                        [ text "comments: "
                        , input
                            [ class "input"
                            , onInput (WineCommentsEdited wine)
                            , value wine.comments
                            ]
                            []
                        ]
                    ]
                , li []
                    [ label []
                        [ text "tasted on: "
                        , input
                            [ class "input"
                            , onInput (WineDateEdited wine)
                            , value wine.dateTasted
                            ]
                            []
                        ]
                    ]
                ]
            ]
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


viewImagePreview : Maybe Image -> Html Msg
viewImagePreview image =
    case image of
        Nothing ->
            p [] [ text "add an image" ]

        Just image ->
            figure [ class "image is-128x128", style [ ( "display", "inline-block" ) ] ]
                [ img
                    [ src image.contents
                    , title image.filename
                    , style [ ( "display", "inline-block" ) ]
                    ]
                    []
                ]
