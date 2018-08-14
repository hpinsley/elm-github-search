module Update exposing (..)

import Types exposing (..)
import Services exposing (..)
import Regex
import Utils
import Time
import Ports.UserInterfaceHelpers as UserInterfaceHelpers
import Ports.D3 as D3
import Encoders
import Json.Encode

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        OnSearchTermChange newSearchTerm ->
            { model | searchTerm = newSearchTerm } ! []

        ProcessTime timeSource currentTime ->
            { model | currentTime = currentTime, timeSource = timeSource } ! []

        ResetSearch ->
            { model
                | page = SearchPage
                , searchType = NotSearching
                , errorMessage = ""
                , searchTerm = ""
                , searchRepos = Nothing
                , userRepos = Nothing
                , filterText = ""
                , highlightText = ""
                , sortBy = Nothing
            }
                ! [focusSearchInput]

        StartGeneralRepoSearch ->
            let
                cmd =
                    searchRepos model.searchTerm model.items_per_page model.language
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
                cmd =
                    searchUserRepos url
            in
                { model
                    | searchType = RepoQuery (UserRepoSearch login)
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
                        userLogin =
                            case model.user of
                                Just user ->
                                    user.login

                                Nothing ->
                                    ""

                        matchingRepos =
                            { total_items = 0
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
                        matchingRepos =
                            { total_items = searchResult.total_count
                            , searchType = GeneralRepoSearch model.searchTerm
                            , items = searchResult.items
                            , links = extractLinksFromHeader searchResult.linkHeader
                            }
                        searchRepos = applySortOrder (Just matchingRepos) model.sortBy
                    in
                        { model
                            | page = ResultsPage
                            , searchRepos = searchRepos
                            , searchCount = model.searchCount + 1
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

        SortClick columnClicked ->
            (sortModel model columnClicked) ! []

        OnItemsPerPageChanged strPerPage ->
            let itemsPerPage =
                case String.toInt strPerPage of
                    Err _ ->
                        5
                    Ok n -> n
            in
                {model | items_per_page = itemsPerPage} ! []

        OnLanguageChanged language ->
            { model | language = language } ! []

        OnHighlightTextChanged text ->
            { model | highlightText = text } ! []

        OnFilterTextChanged text ->
            { model | filterText = text } ! []

        ClearFiltersAndHighlights ->
            { model | highlightText = "", filterText = "" } ! []

        ClearSearchPageFilters ->
            { model | language = "", items_per_page = defaultItemsPerPage } ! [focusSearchInput]

        SetFocusedElement focusedElement ->
            { model | lastFocusedElement = focusedElement } ! []

        NavigateToPage page ->
            { model | page = page } ! []

        RenderGraph ->
            let
                encoded = Encoders.encodeMonthValueList model.graphData.months
                graphInit = {
                      title = model.graphData.title
                    , monthData = Json.Encode.encode 5 encoded
                }
                cmd = D3.render graphInit
            in
                model ! [cmd]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [
          Time.every (60 * Time.second) (ProcessTime "Subscription")
        , UserInterfaceHelpers.setFocusToElementResult SetFocusedElement
    ]



-- Sub.none

focusSearchInput : Cmd Msg
focusSearchInput =
    UserInterfaceHelpers.setFocusToElement { id = "searchTermInput", delay = 250 }

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


extractSearchTypeFromRepoResults : Maybe MatchingRepos -> SearchType
extractSearchTypeFromRepoResults matchingRepos =
    case matchingRepos of
        Just matching ->
            RepoQuery matching.searchType

        Nothing ->
            NotSearching

sortModel: Model -> String -> Model
sortModel model columnClicked =
    let
        _ = Debug.log "sortBy" columnClicked
        newSortOrder = getNewSortOrder model.sortBy columnClicked
    in
        { model
            | sortBy = newSortOrder
            , searchRepos = applySortOrder model.searchRepos newSortOrder
            , userRepos = applySortOrder model.userRepos newSortOrder
        }

getNewSortOrder: Maybe SortBy -> String -> Maybe SortBy
getNewSortOrder oldSortOrder columnClicked =
    case oldSortOrder of
        Nothing ->
            Just (SortBy columnClicked Descending)

        Just oldSortOrder ->
            if (oldSortOrder.column == columnClicked)
            then
                Just (SortBy oldSortOrder.column (reverseSortOrder oldSortOrder.order))
            else
                Just (SortBy columnClicked Descending)

reverseSortOrder: SortOrder -> SortOrder
reverseSortOrder order =
    if order == Ascending then Descending else Ascending

applySortOrder: Maybe MatchingRepos -> Maybe SortBy -> Maybe MatchingRepos
applySortOrder matches sortBy =
    case matches of
        Nothing ->
            Nothing
        Just _ ->
            case sortBy of
                Nothing ->
                    matches
                Just sb ->
                    Maybe.map (applySortOrderToMatch sb) matches

applySortOrderToMatch: SortBy -> MatchingRepos -> MatchingRepos
applySortOrderToMatch sortBy matches =
    let
        comparableFunc =
            case sortBy.column of
                "stars" -> .stargazers_count
                "size" -> .size
                _ -> .stargazers_count

        sortedItems =
            matches.items
                |> List.sortBy comparableFunc
                |> (if sortBy.order == Descending then List.reverse else identity)
    in
        { matches | items = sortedItems }
