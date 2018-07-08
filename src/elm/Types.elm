module Types exposing (..)

init : ( Model, Cmd Msg )
init =
    (
        {
            name = "Howard"
        }
    , Cmd.none )

-- MODEL
type alias Model = {
    name: String
}

-- Messages
type Msg =
    NoOp
