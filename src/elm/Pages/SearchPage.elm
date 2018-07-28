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
                , getItemsPerPageEntry model
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


getItemsPerPageEntry : Model -> Html Msg
getItemsPerPageEntry model =
    div
        [ class "form-group"
        , id "itemsPerPageForm"
        ]
        [ label [ for "itemsPerPageInput" ]
            [ text "Items per page:"
            ]
        , input
            [ type_ "text"
            , id "itemsPerPageInput"
            , class "form-control"
            , placeholder "Items per page"
            , value (toString model.items_per_page)
            , onInput OnItemsPerPageChanged
            ]
            []
        ]


getSearchTerm : Model -> Html Msg
getSearchTerm model =
    div [ class "form-group" ]
        [ input
            [ type_ "text"
            , id "searchTermInput"
            , class "form-control"
            , placeholder "Search term"
            , value model.searchTerm
            , onInput OnSearchTermChange
            ]
            []
        ]
