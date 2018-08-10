module Pages.GraphPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Components.StatusBar exposing (..)


view : Model -> Html Msg
view model =
    div
        [ id "graph"
        , style
            [ ( "position", "relative" )
            ]
        ]
        [ text "Graph Here"
        , buildStatusBar model
        ]


buildStatusBar : Model -> Html Msg
buildStatusBar model =
    statusBar
        { fontSize = "12pt"
        , sections =
            [ { label = Nothing, content = returnBtn model, alignment = Center, fontSize = Nothing }
            ]
        }


returnBtn : Model -> Html Msg
returnBtn model =
    button
        [ class "btn"
        , style
            [ ( "margin", "0px" )
            , ( "padding", "6px" )
            ]
        , onClick (NavigateToPage SearchPage)
        ]
        [ text "Return to Search" ]
