port module Ports.UserInterfaceHelpers exposing (..)

port setFocusToElement : { id: String, delay: Float } -> Cmd msg
