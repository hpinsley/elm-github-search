module Types exposing (..)

init : ( Model, Cmd Msg )
init =
    (
        {
            name = "Howard"
            , searchTerm = ""
            , searching = False
        }
        ,  Cmd.none
    )

-- MODEL
type alias Model =
    {
          name: String
        , searchTerm: String
        , searching: Bool
    }

-- Messages
type Msg =
    NoOp
