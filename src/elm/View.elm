module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Pages.SearchPage exposing (view)
import Pages.SearchingPage exposing (view)
import Pages.ResultsPage exposing (view)
import Pages.SearchingForUserPage exposing (view)
import Pages.UserPage exposing (view)
import Components.StatusBar exposing (..)
import Utils exposing (..)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div []
        [ div [ id "page" ] [ displayPage model ]
        , buildStatusBar model
        ]


displayPage : Model -> Html Msg
displayPage model =
    case model.page of
        SearchPage ->
            Pages.SearchPage.view model

        SearchingPage ->
            Pages.SearchingPage.view model

        ResultsPage ->
            callResultsPageWithRepoResult model

        SearchingForUserPage ->
            Pages.SearchingForUserPage.view model

        UserPage ->
            Pages.UserPage.view model


buildStatusBar : Model -> Html Msg
buildStatusBar model =
    let
        btn =
            button [] [ text "Clear" ]
    in
        statusBar
            { fontSize = "12pt"
            , sections =
                [ { label = Just "Search count:", content = text (toString model.searchCount), alignment = Left, fontSize = Nothing }
                , { label = Nothing, content = btn, alignment = Center, fontSize = Nothing }
                , { label = Just "Time:", content = text (Utils.timeToFullDateDisplay model.currentTime), alignment = Center, fontSize = Just "12pt" }
                , { label = Just "Time Source:", content = text model.timeSource, alignment = Right, fontSize = Nothing }
                ]
            }


callResultsPageWithRepoResult : Model -> Html Msg
callResultsPageWithRepoResult model =
    case model.searchType of
        NotSearching ->
            text ""

        UserLookup _ _ ->
            text ""

        RepoQuery repoSearchType ->
            case repoSearchType of
                UserRepoSearch login ->
                    case model.userRepos of
                        Nothing ->
                            text ""

                        Just userRepos ->
                            Pages.ResultsPage.view model userRepos

                GeneralRepoSearch searchTerm ->
                    case model.searchRepos of
                        Nothing ->
                            text ""

                        Just searchRepos ->
                            Pages.ResultsPage.view model searchRepos
