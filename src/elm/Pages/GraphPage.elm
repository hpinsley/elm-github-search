module Pages.GraphPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ id "graphPage" ]
        [ graphGroupDisplay model
        , navButtons model
        ]


graphGroupDisplay : Model -> Html Msg
graphGroupDisplay model =
    div [ id "graphGroup" ]
        [ graphDataDisplay model
        , graphContent model
        , div [ class "clear" ] []
        ]


graphDataDisplay : Model -> Html Msg
graphDataDisplay model =
    div [ id "graphDataDisplay" ]
        [ h1 []
            [ text model.graphData.title
            ]
        , displayMonthValues model
        ]


displayMonthValues : Model -> Html Msg
displayMonthValues model =
    div [] <|
        List.map displayMonthValue model.graphData.months


displayMonthValue : MonthValue -> Html Msg
displayMonthValue month =
    div [ class "monthValue" ]
        [ label []
            [ text month.month
            ]
        , input
            [ type_ "number"
            , value (toString month.val)
            , onInput (ChangeMonthValue month.month)
            ]
            []
        ]



-- Content is filled in by JavaScript port and D3


graphContent : Model -> Html Msg
graphContent model =
    div [ id "graphContent" ]
        []


navButtons : Model -> Html Msg
navButtons model =
    div
        [ id "graphNavButtons"
        ]
        [ renderBtn model
        , returnBtn model
        ]


returnBtn : Model -> Html Msg
returnBtn model =
    button
        [ class "btn btn-primary btn-lg"
        , onClick (NavigateToPage SearchPage)
        ]
        [ text "Return to Search" ]


renderBtn : Model -> Html Msg
renderBtn model =
    button
        [ class "btn btn-primary btn-lg"
        , onClick RenderGraph
        ]
        [ text "Render" ]
