module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)

init : ( Model, Cmd Msg )
init =
    (
        {
              page = SearchPage
            , name = "Howard"
            , searchTerm = ""
            , searching = False
            , errorMessage = ""
            , result_count = 0
            , matching_repos = []
        }
        ,  Cmd.none
    )

-- MODEL

type Page
    = SearchPage
    | ResultsPage

type alias Model =
    {
          page: Page
        , name: String
        , searchTerm: String
        , searching: Bool
        , errorMessage: String
        , result_count: Int
        , matching_repos: List RepoItem
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | ProcessRepoSearchResult (Result Http.Error RepoQueryResult)
    | StartNewSearch
