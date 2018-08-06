module Components.StatusBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Align
    = Left
    | Center
    | Right


type alias Section =
    { label : String
    , text : String
    , alignment : Align
    }



-- hello component


statusBar : List Section -> Html a
statusBar sections =
    sections
        |> List.map (renderSection <| List.length sections)
        |> \l ->
            l
                ++ [ clear ]
                |> div [ class "statusBar" ]


clear : Html a
clear =
    div
        [ class "clear"
        ]
        []


renderSection : Int -> Section -> Html a
renderSection sectionCount section =
    div
        [ class "statusBarSection"
        , buildStyle sectionCount section
        ]
        [ label [] [ text section.label ]
        , span [] [ text section.text ]
        ]


buildStyle : Int -> Section -> Html.Attribute a
buildStyle sectionCount section =
    let
        width =
            100.0 / (toFloat sectionCount)

        strWidth =
            toString width ++ "%"
    in
        style
            [ ( "text-align"
              , case section.alignment of
                    Left ->
                        "left"

                    Center ->
                        "center"

                    Right ->
                        "right"
              )
            , ( "width", strWidth )
            ]
