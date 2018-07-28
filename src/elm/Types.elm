module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)
import Http
import Time
import Task

init : ( Model, Cmd Msg )
init =
    (
        {
              page = SearchPage
            , searchType = NotSearching
            , searchTerm = "angular-mashup"
            , language = "javascript"
            , items_per_page = 10
            , errorMessage = ""
            , user = Nothing
            , userRepos = Nothing
            , searchRepos = Nothing
            , sortBy = Nothing
            , currentTime = 0
            , timeSource = ""
        }
        ,  Task.perform (ProcessTime "Intial Cmd") Time.now
    )

-- MODEL

type Page
    = SearchPage
    | SearchingPage
    | SearchingForUserPage
    | ResultsPage
    | UserPage

type alias UserLogin = String
type alias SearchTerm = String
type alias UserAvatarUrl = String

type RepoSearchType
    = UserRepoSearch UserLogin
    | GeneralRepoSearch SearchTerm

type SearchType
    = NotSearching
    | RepoQuery RepoSearchType
    | UserLookup UserLogin (Maybe UserAvatarUrl)

type alias Link =
    {
        rel: String,
        link: String
    }

type SortOrder = Ascending | Descending

type alias SortBy =
    {
        column: String,
        order: SortOrder
    }

type alias MatchingRepos =
    {
          total_items: Int
        , searchType: RepoSearchType
        , items: List RepoItem
        , links: List Link
    }

type alias Model =
    {
          page: Page
        , searchType: SearchType
        , searchTerm: String
        , language: String
        , items_per_page: Int
        , errorMessage: String
        , user: Maybe User
        , userRepos: Maybe MatchingRepos
        , searchRepos: Maybe MatchingRepos
        , sortBy: Maybe SortBy
        , currentTime: Time.Time
        , timeSource: String
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartGeneralRepoSearch
    | SearchReposViaUrl String
    | ProcessRepoSearchResult (Result String RepoQueryResult)
    | ResetSearch
    | StartUserSearch String String (Maybe UserAvatarUrl)
    | ProcessUserSearchResult (Result Http.Error User)
    | StartUserRepoSearch String String
    | ProcessUserReposResult (Result Http.Error UserReposQueryResult)
    | ReturnToRepoSearchResults
    | ProcessTime String Time.Time
    | SortClick String
    | OnItemsPerPageChanged String
    | OnLanguageChanged String
