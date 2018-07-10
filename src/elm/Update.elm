module Update exposing (..)

import Types exposing (..)
import Services exposing (..)
import Utils exposing (..)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      model ! []

    OnSearchTermChange newSearchTerm ->
      { model | searchTerm = newSearchTerm } ! []

    StartNewSearch ->
        { model
          | searching = False
          , page = SearchPage
          , errorMessage = ""
          , searchTerm = ""
        } ! []

    StartSearch ->
      let
        cmd = searchRepos { searchTerm = model.searchTerm, items_per_page = model.items_per_page }
      in
        { model
          | searching = True
          , errorMessage = ""
          , page = SearchingPage
        } ! [cmd]

    ProcessRepoSearchResult results ->
      case results of
        Ok searchResult ->
          { model
            | searching = False
            , page = ResultsPage
            , result_count = searchResult.total_count
            , matching_repos = searchResult.items
          } ! []
        Err httpError ->
          { model
            | searching = False
            , errorMessage = Utils.httpErrorMessage httpError
            , result_count = -1 } ! []

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none