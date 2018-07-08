module Components.Hello exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String

-- hello component
hello : Int -> Html a
hello repeatTimes =
  div
    [ class "h1" ]
    [ text ( "Hi, Elm" ++ ( "!" |> String.repeat repeatTimes ) ) ]
