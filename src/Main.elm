module Main exposing (main)

import Html
import App
    exposing
        ( Model
        , Msg
        , init
        , subscriptions
        , update
        , view
        )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
