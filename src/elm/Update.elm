module Update exposing (..)

import Types exposing (..)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      model ! []
      
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none