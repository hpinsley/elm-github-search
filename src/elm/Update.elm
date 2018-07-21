module Update exposing (..)

import Types exposing (..)
import Services exposing (..)
import Regex
import Utils


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OnSearchTermChange newSearchTerm ->
            { model | searchTerm = newSearchTerm } ! []

        StartNewSearch ->
            { model
                | page = SearchPage
                , searchType = NotSearching
                , errorMessage = ""
                , searchTerm = ""
            }
                ! []

        StartSearch ->
            let
                cmd =
                    searchRepos model.searchTerm model.items_per_page
            in
                { model
                    | searchType = RepoQuery (GeneralRepoSearch model.searchTerm)
                    , errorMessage = ""
                    , page = SearchingPage
                }
                    ! [ cmd ]

        StartUserSearch login url avatar_url ->
            let
                cmd =
                    searchUser login
            in
                { model
                    | searchType = UserLookup login avatar_url
                    , errorMessage = ""
                    , page = SearchingForUserPage
                }
                    ! [ cmd ]

        StartUserRepoSearch login url ->
            let
                cmd = searchUserRepos url
            in
                { model
                    | searchType = RepoQuery (UserRepoSearch login)
                    , searchTerm = "Repos for user " ++ login
                    , errorMessage = ""
                    , page = SearchingPage
                }
                    ! [ cmd ]

        ProcessUserSearchResult result ->
            case result of
                Err httpError ->
                    { model
                        | page = SearchPage
                        , searchType = NotSearching
                        , errorMessage = Utils.httpErrorMessage httpError
                        , user = Nothing
                    }
                        ! []

                Ok user ->
                    { model
                        | page = UserPage
                        , user = Just user
                        , searchType = NotSearching
                        , errorMessage = ""
                    }
                        ! []

        -- UserReposQueryResult
        ProcessUserReposResult result ->
            case result of
                Err httpError ->
                    { model
                        | page = SearchPage
                        , searchType = NotSearching
                        , errorMessage = Utils.httpErrorMessage httpError
                        , userRepos = Nothing
                    }
                        ! []

                Ok result ->
                    let
                        userLogin = case model.user of
                                        Just user -> user.login
                                        Nothing -> ""

                        matchingRepos = {
                              totalItems = 0
                            , searchType = RepoQuery (UserRepoSearch userLogin)
                            , items = result.items
                            , links = extractLinksFromHeader result.linkHeader
                        }
                    in

                    { model
                        | page = ResultsPage
                        , userRepos = matchingRepos
                        , searchType = NotSearching
                        , errorMessage = ""
                    }
                        ! []

        ReturnToRepoSearchResults ->
            { model
                | page = ResultsPage
            }
                ! []

        SearchReposViaUrl url ->
            let
                cmd =
                    searchViaUrl url
            in
                { model
                    | searching = True
                    , errorMessage = ""
                    , page = SearchingPage
                }
                    ! [ cmd ]

        ProcessRepoSearchResult results ->
            case results of
                Ok searchResult ->
                    { model
                        | searching = False
                        , page = ResultsPage
                        , result_count = searchResult.total_count
                        , matching_repos = searchResult.items
                        , links = extractLinksFromHeader searchResult.linkHeader
                    }
                        ! []

                Err errorMessage ->
                    { model
                        | page = SearchPage
                        , searching = False
                        , errorMessage = errorMessage
                        , matching_repos = []
                        , links = []
                        , result_count = -1
                    }
                        ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


extractLinksFromHeader : Maybe String -> List Link
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


extractLinkFromSingle : String -> Maybe Link
extractLinkFromSingle linkText =
    let
        pattern =
            Regex.regex "<(.*)>; rel=\"(.*)\""

        matches =
            Regex.find (Regex.AtMost 1) pattern linkText
    in
        case matches of
            [] ->
                Nothing

            match :: _ ->
                case match.submatches of
                    link :: rel :: _ ->
                        Just { rel = Maybe.withDefault "" rel, link = Maybe.withDefault "" link }

                    _ ->
                        Nothing
