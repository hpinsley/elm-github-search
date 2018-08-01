module Pages.ResultsPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)
import Utils
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Locale, usLocale)


view : Model -> MatchingRepos -> Html Msg
view model matching_repos =
    div []
        [ displayTextFilter model
        , displayResultsTable model matching_repos
        , displayLinks model matching_repos
        ]


displayTextFilter : Model -> Html Msg
displayTextFilter model =
    div [ id "textFilter" ]
        [ label [] [ text "Filter:" ]
        , input
            [ type_ "text"
            , id "globalFilter"
            , class "form-control"
            , value model.filterText
            , onInput OnFilterTextChanged
            ]
            []
        , label [] [ text "Highlight:" ]
        , input
            [ type_ "text"
            , id "hightlightInput"
            , class "form-control"
            , value model.highlightText
            , onInput OnHighlightTextChanged
            ]
            []
        , button
            [ class "btn btn-primary"
            , onClick ClearFiltersAndHighlights
            ]
            [ text "Clear" ]
        ]


displayResultsTable : Model -> MatchingRepos -> Html Msg
displayResultsTable model matching_repos =
    div [ class "scrollingRegion" ]
        [ table
            [ id "repo-results-table"
            , class "table table-dark"
            ]
            [ tableHeader model
            , tableBody model matching_repos
            ]
        ]


displayLinks : Model -> MatchingRepos -> Html Msg
displayLinks model matching_repos =
    div [ class "buttonGroup" ]
        (List.map (displayLink model) matching_repos.links
            ++ (displayAdditionalButtons model)
        )


displayLink : Model -> Link -> Html Msg
displayLink model link =
    let
        clickMsg =
            case model.searchType of
                RepoQuery repoSearchType ->
                    case repoSearchType of
                        UserRepoSearch login ->
                            --  Continue a user search with a link
                            StartUserRepoSearch login link.link

                        GeneralRepoSearch _ ->
                            SearchReposViaUrl link.link

                _ ->
                    NoOp
    in
        button
            [ class "btn btn-primary btn-lg"
            , onClick clickMsg
            ]
            [ text <| Utils.initialCap link.rel ]


displayAdditionalButtons : Model -> List (Html Msg)
displayAdditionalButtons model =
    [ button
        [ class "btn btn-primary btn-lg"
        , onClick ResetSearch
        ]
        [ text "New Search" ]
      -- Allow backing up to the general repo search if we drilled into an owner
    , case model.searchType of
        RepoQuery (UserRepoSearch _) ->
            case model.searchRepos of
                Just matching_repos ->
                    button
                        [ class "btn btn-primary btn-lg"
                        , onClick ReturnToRepoSearchResults
                        ]
                        [ text <| "Return to " ++ Utils.getRepoSearchTerm matching_repos.searchType
                        ]

                _ ->
                    text ""

        _ ->
            text ""
    ]


tableBody : Model -> MatchingRepos -> Html Msg
tableBody model matching_repos =
    tbody []
        (matching_repos.items
            |> List.filter (\r -> not r.fork)
            |> List.filter (\r -> doesRepoMatchFilter model r)
            |> List.map (renderRepo model)
            |> List.concat
        )


doesRepoMatchFilter : Model -> RepoItem -> Bool
doesRepoMatchFilter model item =
    if (model.filterText == "") then
        True
    else
        List.any
            (doesFieldMatch item model.filterText)
            [ .name
            , .full_name
            , .url
            , .html_url
            , .language
            ]

doesFieldMatch : RepoItem -> String -> (RepoItem -> String) -> Bool
doesFieldMatch item text fieldAccessor =
    String.contains (String.toLower text) (String.toLower <| fieldAccessor item)


renderRepo : Model -> RepoItem -> List (Html Msg)
renderRepo model item =
    [ getMainRepoItemRow item
    , getDescriptionRepoItemRow model item
    ]


intFormat : Int -> String
intFormat n =
    format { usLocale | decimals = 0 } (toFloat n)


getMainRepoItemRow : RepoItem -> Html Msg
getMainRepoItemRow item =
    let
        userLookupCmd =
            (StartUserSearch item.owner.login item.owner.url item.owner.avatar_url)

        commaFormat =
            { usLocale
                | decimals = 0
            }
    in
        tr []
            [ td [ class "repoName" ] [ text item.name ]
            , td [] [ text item.full_name ]
            , td []
                [ text <|
                    if item.fork then
                        "Yes"
                    else
                        "No"
                ]
            , td [ class "ownerLogin" ]
                [ a [ onClick userLookupCmd ]
                    [ text item.owner.login ]
                ]
            , td [ class "avatar" ]
                [ case item.owner.avatar_url of
                    Nothing ->
                        text "Missing"

                    Just avatar_url ->
                        a [ onClick userLookupCmd ]
                            [ img
                                [ class "avatar"
                                , src avatar_url
                                ]
                                []
                            ]
                ]
            , td [] [ a [ href item.html_url ] [ text "View on Github" ] ]
            , td [ class "stars" ] [ text <| intFormat item.stargazers_count ]
            , td [ class "size" ] [ text <| intFormat item.size ]
            , td [ class "language" ] [ text item.language ]
            ]


getDescriptionRepoItemRow : Model -> RepoItem -> Html Msg
getDescriptionRepoItemRow model item =
    tr
        []
        [ td
            [ colspan 9 ]
            [ getHighlights model.highlightText (Maybe.withDefault "(no description)" item.description) ]
        ]


getHighlights : String -> String -> Html Msg
getHighlights highlightWord str =
    let
        indexes =
            String.indexes (String.toLower highlightWord) (String.toLower str)
    in
        case indexes of
            [] ->
                text str

            i :: _ ->
                let
                    l =
                        String.length highlightWord

                    left =
                        String.slice 0 i str

                    h =
                        String.slice i (i + l) str

                    right =
                        String.dropLeft (i + l) str
                in
                    span []
                        [ text left
                        , highlight h
                        , getHighlights highlightWord right
                        ]


highlight : String -> Html Msg
highlight str =
    span
        [ class "highlight"
        ]
        [ text str
        ]


tableHeader : Model -> Html Msg
tableHeader model =
    thead []
        [ tr []
            [ colHeader model "Name"
            , colHeader model "Full Name"
            , colHeader model "Fork"
            , colHeader model "Owner"
            , colHeader model "Avatar"
            , colHeader model ""
            , colHeader model "Stars"
            , colHeader model "Size"
            , colHeader model "Language"
            ]
        ]


colHeader : Model -> String -> Html Msg
colHeader model col =
    let
        testColumn = String.toLower col
        sortable = case testColumn of
                    "stars" -> True
                    "size" -> True
                    _ -> False

        sortableClass =
            if sortable then
                "sortable"
            else
                "notsortable"

        sortDirectionClass =
            case model.sortBy of
                Nothing -> "notsorted"
                Just s ->
                    if (s.column == testColumn)
                    then
                        if (s.order == Ascending)
                        then
                            "sorted-ascending"
                        else
                            "sorted-descending"
                    else
                        "notsorted"

        classes = sortableClass ++ " " ++ sortDirectionClass
    in
        th
            [ class classes
            , onClick <|
                if sortable then
                    SortClick (String.toLower col)
                else
                    NoOp
            ]
            [ text col
            ]
