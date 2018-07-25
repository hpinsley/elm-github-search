module Pages.SearchPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Utils exposing (..)

view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ h1 []
                [ text "GitHub Search"
                , h2 []
                    [ text <| model.errorMessage
                    ]
                , Html.div []
                    [ getSearchTerm model
                    , getButtons model
                    ]
                ]
            ]
            , div [][text <| Utils.timeToFullDateDisplay model.currentTime]
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
        [ label [] [ text "Search term:" ]
        , input
            [ type_ "text"
            , class "form-control"
            , value model.searchTerm
            , onInput OnSearchTermChange
            ]
            []
        ]
