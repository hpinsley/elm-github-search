module Components.StatusBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Align
    = Left
    | Center
    | Right


type alias Section msg =
    { label : String
    , content : Html msg
    , alignment : Align
    }



-- hello component


statusBar : List (Section msg) -> Html msg
statusBar sections =
    sections
        |> List.map (renderSection <| List.length sections)
        |> \l ->
            l
                ++ [ clear ]
                |> div
                    [ style
                        [ ( "clear", "both" )
                        , ( "box-shadow", "1em 0.5em 1em" )
                        , ( "position", "absolute" )
                        , ( "bottom", "20px" )
                        , ( "width", "80%" )
                        , ( "font-size", "10pt" )
                        , ( "background", "rgb(100, 100, 100)" )
                        ]
                    ]


clear : Html a
clear =
    div
        [ class "clear"
        ]
        []


renderSection : Int -> Section msg -> Html msg
renderSection sectionCount section =
    div
        [ buildStyle sectionCount section
        ]
        [ label
            [ style
                [ ( "font-weight", "bold" )
                , ( "color", "orange" )
                , ( "margin-right", "10px" )
                ]
            ]
            [ text section.label ]
        , span [] [ section.content ]
        ]


buildStyle : Int -> Section msg -> Html.Attribute msg
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
            , ( "display", "inline-block" )
            , ( "margin-left", "auto" )
            , ( "margin-right", "auto" )
            , ( "border", "2px solid white" )
            , ( "padding", "10px" )
            , ( "color", "gold" )
            ]
