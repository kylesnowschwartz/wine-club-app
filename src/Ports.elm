port module Ports exposing (..)


type alias ImagePortData =
    { wineId : Int
    , contents : String
    , filename : String
    }


port fileSelected : String -> Cmd msg


port fileContentRead : (ImagePortData -> msg) -> Sub msg
