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

    StartSearch ->
      let
        cmd = searchRepos model.searchTerm
      in
        { model | searching = True } ! [cmd]

    ProcessRepoSearchResult results ->
      case results of
        Ok searchResult ->
          { model | searching = False, result_count = searchResult.total_count } ! []
        Err httpError ->
          { model
            | searching = False
            , errorMessage = Utils.httpErrorMessage httpError
            , result_count = -1 } ! []

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none