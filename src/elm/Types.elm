module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)
import Http

init : ( Model, Cmd Msg )
init =
    (
        {
              page = SearchPage
            , searchType = NotSearching
            , searchTerm = ""
            , items_per_page = 5
            , errorMessage = ""
            , user = Nothing
            , userRepos = Nothing
            , searchRepos = Nothing
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
        , items_per_page: Int
        , errorMessage: String
        , user: Maybe User
        , userRepos: Maybe MatchingRepos
        , searchRepos: Maybe MatchingRepos
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | SearchReposViaUrl String
    | ProcessRepoSearchResult (Result String RepoQueryResult)
    | StartNewSearch
    | StartUserSearch String String (Maybe UserAvatarUrl)
    | ProcessUserSearchResult (Result Http.Error User)
    | StartUserRepoSearch String String
    | ProcessUserReposResult (Result Http.Error UserReposQueryResult)
    | ReturnToRepoSearchResults

