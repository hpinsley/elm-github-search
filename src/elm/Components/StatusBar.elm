module Components.StatusBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String

type Align = Left | Center | Right

type alias Section a =
    {
          contents: Html a
        , alignment: Align
    }

-- hello component
statusBar : List (Section a) -> Html a
statusBar sections =
  div
    [ class "statusBar" ]
    <| (List.map renderSection sections) ++ [clear]

clear: Html a
clear =
    div [
        class "clear"
    ]
    []

renderSection: (Section a) -> Html a
renderSection section =
    div [
          class "statusBarSection"
        , buildStyle section
    ]
    [
        section.contents
    ]

buildStyle: (Section a) -> Html.Attribute a
buildStyle section =
    style [
        ("text-align", case section.alignment of
                        Left -> "left"
                        Center -> "center"
                        Right -> "right")
    ]
