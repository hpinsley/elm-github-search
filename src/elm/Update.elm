module Update exposing (..)

import Types exposing (..)
import Services exposing (..)
import Regex

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
            , links = extractLinksFromHeader searchResult.linkHeader
          } ! []
        Err errorMessage ->
          { model
            | page = SearchPage
            , searching = False
            , errorMessage = errorMessage
            , matching_repos = []
            , links = []
            , result_count = -1 } ! []

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

extractLinksFromHeader: Maybe String -> List Link
extractLinksFromHeader linkHeader =
  case linkHeader of
    Nothing ->
      []
    Just links ->
        String.split "," links
          |> List.map extractLinkFromSingle
          |> List.filterMap identity

-- The format of these links is:
-- <https://api.github.com/search/repositories?q=trains&per_page=10&page=100>; rel="last"
-- Use a RegEx

extractLinkFromSingle: String -> Maybe Link
extractLinkFromSingle linkText =
  let
      pattern = Regex.regex "<(.*)>; rel=\"(.*)\""
      matches = Regex.find (Regex.AtMost 1) pattern linkText
      y = Debug.log "matches" matches
  in
      case matches of
        [] -> Nothing
        match::xs ->
          case match.submatches of
            [] -> Nothing
            link::rel::_ ->
              Just { rel = Maybe.withDefault "" rel, link = Maybe.withDefault "" link}
            _ -> Nothing

