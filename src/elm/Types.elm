module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)
import Http
import Time
import Task

-- MODEL

type Page
    = SearchPage
    | SearchingPage
    | SearchingForUserPage
    | ResultsPage
    | UserPage
    | GraphPage

type alias UserLogin = String
type alias SearchTerm = String
type alias UserAvatarUrl = String

type alias MonthValue =
    {
          month: String
        , val: Int
    }

type alias GraphData =
    {
        title: String,
        months: List MonthValue
    }

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
        , highlightText: String
        , filterText: String
        , searchCount: Int
        , lastFocusedElement: String
        , graphData: GraphData
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
    | OnHighlightTextChanged String
    | OnFilterTextChanged String
    | ClearFiltersAndHighlights
    | ClearSearchPageFilters
    | SetFocusedElement String
    | NavigateToPage Page
    | RenderGraph String

init : ( Model, Cmd Msg )
init =
    let
        graphData = {
            title = "Months",
            months = [
                      MonthValue "Jan" 31
                    , MonthValue "Feb" 28
                    , MonthValue "Mar" 31
                    , MonthValue "Apr" 30
                    , MonthValue "May" 31
                    , MonthValue "Jun" 30
                    , MonthValue "Jul" 31
                    , MonthValue "Aug" 31
                    , MonthValue "Sep" 30
                    , MonthValue "Oct" 31
                    , MonthValue "Nov" 30
                    , MonthValue "Dec" 31
                    ]
        }
    in
        (
            {
                page = SearchPage
                , searchType = NotSearching
                , searchTerm = ""
                , language = ""
                , items_per_page = defaultItemsPerPage
                , errorMessage = ""
                , user = Nothing
                , userRepos = Nothing
                , searchRepos = Nothing
                , sortBy = Nothing
                , currentTime = 0
                , timeSource = ""
                , highlightText = ""
                , filterText = ""
                , searchCount = 0
                , lastFocusedElement = ""
                , graphData = graphData
            }
            ,  Task.perform (ProcessTime "Intial Cmd") Time.now
        )

defaultItemsPerPage = 20