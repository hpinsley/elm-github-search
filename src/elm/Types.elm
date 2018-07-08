module Types exposing (..)

init : ( Model, Cmd Msg )
init =
    (10, Cmd.none )

-- MODEL
type alias Model = Int

-- Messages
type Msg = NoOp | Increment
