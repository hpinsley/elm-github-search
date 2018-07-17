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
            , searchUserLogin = ""
            , searchUserAvatarUrl = Nothing
            , items_per_page = 5
            , searching = False
            , errorMessage = ""
            , result_count = 0
            , matching_repos = []
            , links = []
            , user = Nothing
        }
        ,  Cmd.none
    )

-- MODEL

type Page
    = SearchPage
    | SearchingPage
    | SearchingForUserPage
    | ResultsPage
    | UserPage

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
        , searchUserLogin: String
        , searchUserAvatarUrl: Maybe String
        , items_per_page: Int
        , searching: Bool
        , errorMessage: String
        , result_count: Int
        , matching_repos: List RepoItem
        , links: List Link
        , user: Maybe User
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | SearchReposViaUrl String
    | ProcessRepoSearchResult (Result String RepoQueryResult)
    | StartNewSearch
    | StartUserSearch String String (Maybe String)
    | ProcessUserSearchResult (Result Http.Error User)
    | ReturnToRepoSearchResults

