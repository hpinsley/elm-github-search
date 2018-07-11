module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)

init : ( Model, Cmd Msg )
init =
    (
        {
              page = SearchPage
            , searchTerm = ""
            , items_per_page = 10
            , searching = False
            , errorMessage = ""
            , result_count = 0
            , matching_repos = []
            , links = []
        }
        ,  Cmd.none
    )

-- MODEL

type Page
    = SearchPage
    | SearchingPage
    | ResultsPage

type alias SearchRequest =
    {
          searchTerm: String
        , items_per_page: Int
    }

type alias Link =
    {
        rel: String,
        link: String
    }

type alias Model =
    {
          page: Page
        , searchTerm: String
        , items_per_page: Int
        , searching: Bool
        , errorMessage: String
        , result_count: Int
        , matching_repos: List RepoItem
        , links: List Link
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | ProcessRepoSearchResult (Result String RepoQueryResult)
    | StartNewSearch
