module Pages.GraphPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Components.StatusBar exposing (..)


view : Model -> Html Msg
view model =
    div
        [ id "graphPage" ]
        [ graphContent model
        , navButtons model
        ]


graphContent : Model -> Html Msg
graphContent model =
    div [ id "graphContent" ]
        [ text "content here"
        ]


navButtons : Model -> Html Msg
navButtons model =
    div
        [ id "graphNavButtons"
        ]
        [ returnBtn model
        ]


returnBtn : Model -> Html Msg
returnBtn model =
    button
        [ id "returnFromGraphPageBtn"
        , class "btn btn-primary btn-lg"
        , onClick (NavigateToPage SearchPage)
        ]
        [ text "Return to Search" ]
