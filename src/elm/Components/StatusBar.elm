module Components.StatusBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Align
    = Left
    | Center
    | Right


type alias Section msg =
    { label : Maybe String
    , content : Html msg
    , alignment : Align
    , fontSize: Maybe String
    }


type alias StatusBarLayout msg =
    { fontSize : String
    , sections : List (Section msg)
    }



-- hello component


statusBar : StatusBarLayout msg -> Html msg
statusBar layout =
    layout.sections
        |> List.map (renderSection <| List.length layout.sections)
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
                        , ( "font-size", layout.fontSize )
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
        [ case section.label of
            Nothing ->
                text ""

            Just labelText ->
                label
                    [ style
                        [ ( "font-weight", "bold" )
                        , ( "color", "orange" )
                        , ( "margin-right", "10px" )
                        ]
                    ]
                    [ text labelText ]
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
            <| [ ( "text-align"
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
            ++ case section.fontSize of
                Nothing -> []
                Just fx -> [("font-size", fx)]
