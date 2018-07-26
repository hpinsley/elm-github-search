module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Types exposing (..)
import Pages.SearchPage exposing (view)
import Pages.SearchingPage exposing (view)
import Pages.ResultsPage exposing (view)

import Pages.SearchingForUserPage exposing (view)
import Pages.UserPage exposing (view)

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "left" )] ]
    [
      displayPage model
    ]

displayPage: Model -> Html Msg
displayPage model =
  let _ = Debug.log "page" model.page
  in
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

callResultsPageWithRepoResult: Model -> Html Msg
callResultsPageWithRepoResult model =
  case model.searchType of
    NotSearching -> text ""
    UserLookup _ _ -> text ""

    RepoQuery repoSearchType ->
      case repoSearchType of

        UserRepoSearch login ->
          case model.userRepos of
            Nothing -> text ""
            Just userRepos ->
              Pages.ResultsPage.view model userRepos

        GeneralRepoSearch searchTerm ->
          case model.searchRepos of
            Nothing -> text ""
            Just searchRepos ->
              Pages.ResultsPage.view model searchRepos