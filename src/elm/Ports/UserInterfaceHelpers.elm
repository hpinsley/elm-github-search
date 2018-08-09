port module Ports.UserInterfaceHelpers exposing (..)

port setFocusToElement : { id: String, delay: Float } -> Cmd msg

port setFocusToElementResult : (String -> msg) -> Sub msg