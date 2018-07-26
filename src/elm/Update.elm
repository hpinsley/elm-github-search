module Update exposing (..)

import Types exposing (..)
import Services exposing (..)
import Regex
import Utils
import Time

-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OnSearchTermChange newSearchTerm ->
            { model | searchTerm = newSearchTerm } ! []

        ProcessTime currentTime ->
            { model | currentTime = currentTime } ! []

        ResetSearch ->
            { model
                | page = SearchPage
                , searchType = NotSearching
                , errorMessage = ""
                , searchTerm = ""
                , searchRepos = Nothing
                , userRepos = Nothing
            }
                ! []

        StartGeneralRepoSearch ->
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
                              total_items = 0
                            , searchType = UserRepoSearch userLogin
                            , items = result.items
                            , links = extractLinksFromHeader result.linkHeader
                        }
                    in

                    { model
                        | page = ResultsPage
                        , userRepos = Just matchingRepos
                        , errorMessage = ""
                    }
                        ! []

        ReturnToRepoSearchResults ->
            { model
                | page = ResultsPage
                , searchType = extractSearchTypeFromRepoResults model.searchRepos
            }
                ! []

        SearchReposViaUrl url ->
            let
                cmd =
                    searchViaUrl url
            in
                { model
                    | searchType = extractSearchTypeFromRepoResults model.searchRepos
                    , errorMessage = ""
                    , page = SearchingPage
                }
                    ! [ cmd ]

        ProcessRepoSearchResult results ->
            case results of
                Ok searchResult ->
                    let
                        matchingRepos = {
                              total_items = searchResult.total_count
                            , searchType = GeneralRepoSearch model.searchTerm
                            , items = searchResult.items
                            , links = extractLinksFromHeader searchResult.linkHeader
                        }
                    in
                        { model
                            | page = ResultsPage
                            , searchRepos = Just matchingRepos
                        }
                        ! []

                Err errorMessage ->
                    { model
                        | page = SearchPage
                        , searchType = NotSearching
                        , errorMessage = errorMessage
                        , searchRepos = Nothing
                    }
                        ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (60 * Time.second) ProcessTime
    -- Sub.none

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

extractSearchTypeFromRepoResults: (Maybe MatchingRepos) -> SearchType
extractSearchTypeFromRepoResults matchingRepos =
    case matchingRepos of
        Just matching ->
            RepoQuery matching.searchType
        Nothing ->
            NotSearching