module Components.StatusBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Colors exposing (..)

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
                        , ( "box-shadow", "0.5em -0.5em 1em" )
                        , ( "position", "absolute" )
                        , ( "bottom", "0px" )
                        , ( "width", "100vw" )
                        , ( "font-size", layout.fontSize )
                        , ( "color", "white")
                        , ( "background", blackboard )
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
                        [
                            ( "margin-right", "10px" )
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
            ]
            ++ case section.fontSize of
                Nothing -> []
                Just fx -> [("font-size", fx)]
