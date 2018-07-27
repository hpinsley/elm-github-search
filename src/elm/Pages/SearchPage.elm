module Pages.SearchPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Utils exposing (..)


view : Model -> Html Msg
view model =
    div [ id "searchPage", class "row" ]
        [ div [ class "col-xs-12" ]
            [ h1 []
                [ text "GitHub Search" ]
            , h2 []
                [ text <| model.errorMessage
                ]
            , div []
                [ getSearchTerm model
                , getButtons model
                ]
            ]
        , div [ id "timeDisplay" ]
            [ text <| Utils.timeToFullDateDisplay model.currentTime
            , br [] []
            , text model.timeSource
            ]
        ]


getButtons : Model -> Html Msg
getButtons model =
    div [ class "buttonGroup form-group" ]
        [ button
            [ class "btn btn-primary btn-lg"
            , onClick StartGeneralRepoSearch
            ]
            [ text "Search" ]
        ]


getSearchTerm : Model -> Html Msg
getSearchTerm model =
    div [ class "form-group" ]
        [ input
            [ type_ "text"
            , class "form-control"
            , placeholder "Search term"
            , value model.searchTerm
            , onInput OnSearchTermChange
            ]
            []
        ]
