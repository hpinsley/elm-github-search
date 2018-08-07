module Pages.SearchPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Utils exposing (..)
import Components.StatusBar exposing (..)


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
                , getFilters model
                ]
            ]
        , buildStatusBar model
        ]


buildStatusBar : Model -> Html Msg
buildStatusBar model =
    let
        btn =
            button [] [ text "Clear" ]
    in
        statusBar
            { fontSize = "12pt"
            , sections =
                [ { label = Just "Search count:", content = text (toString model.searchCount), alignment = Left }
                , { label = Nothing, content = btn, alignment = Center }
                , { label = Just "Time:", content = text (Utils.timeToFullDateDisplay model.currentTime), alignment = Center }
                , { label = Just "Time Source:", content = text model.timeSource, alignment = Right }
                ]
            }


getButtons : Model -> Html Msg
getButtons model =
    div [ class "buttonGroup form-group" ]
        [ button
            [ class "btn btn-primary btn-lg"
            , disabled (model.searchTerm == "")
            , onClick StartGeneralRepoSearch
            ]
            [ text "Search" ]
        ]


getFilters : Model -> Html Msg
getFilters model =
    div [ id "filters" ]
        [ getItemsPerPageFilter model
        , getLanguageFilter model
        ]


getSearchStats : Model -> Html Msg
getSearchStats model =
    div [ id "searchStats" ]
        [ label [] [ text "Searches:" ]
        , text (toString model.searchCount)
        ]


getItemsPerPageFilter : Model -> Html Msg
getItemsPerPageFilter model =
    div
        [ class "form-group filter"
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


getLanguageFilter : Model -> Html Msg
getLanguageFilter model =
    div
        [ class "form-group filter"
        , id "language"
        ]
        [ label [ for "languageInput" ]
            [ text "Language:"
            ]
        , input
            [ type_ "text"
            , id "languageInput"
            , class "form-control"
            , placeholder "Language"
            , value model.language
            , onInput OnLanguageChanged
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
