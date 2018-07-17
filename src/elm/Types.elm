module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)
import Http

init : ( Model, Cmd Msg )
init =
    (
        {
              page = SearchPage
            , searchTerm = "angular-mashup"
            , searchOwnerLogin = ""
            , searchOwnerAvatarUrl = Nothing
            , items_per_page = 5
            , searching = False
            , errorMessage = ""
            , result_count = 0
            , matching_repos = []
            , links = []
            , owner = Nothing
        }
        ,  Cmd.none
    )

-- MODEL

type Page
    = SearchPage
    | SearchingPage
    | SearchingForOwnerPage
    | ResultsPage
    | OwnerPage

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
        , searchOwnerLogin: String
        , searchOwnerAvatarUrl: Maybe String
        , items_per_page: Int
        , searching: Bool
        , errorMessage: String
        , result_count: Int
        , matching_repos: List RepoItem
        , links: List Link
        , owner: Maybe Owner
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | SearchReposViaUrl String
    | ProcessRepoSearchResult (Result String RepoQueryResult)
    | StartNewSearch
    | StartOwnerSearch String String (Maybe String)
    | ProcessOwnerSearchResult (Result Http.Error Owner)

