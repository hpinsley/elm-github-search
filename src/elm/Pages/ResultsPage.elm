module Pages.ResultsPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)
import Utils


view : Model -> MatchingRepos -> Html Msg
view model matching_repos =
    div []
        [ h2 []
            [ text <| "Result count " ++ (toString matching_repos.total_items)
            ]
        , displayResultsTable model matching_repos
        , displayLinks model matching_repos
        , displayAdditionalButtons model
        ]


displayAdditionalButtons : Model -> Html Msg
displayAdditionalButtons model =
    div [ class "buttonGroup" ]
        [ button
            [ class "btn btn-primary btn-lg"
            , onClick StartNewSearch
            ]
            [ text "New Search" ]
        ]


displayResultsTable : Model -> MatchingRepos -> Html Msg
displayResultsTable model matching_repos =
    table
        [ id "repo-results-table"
        , class "table table-dark"
        ]
        [ tableHeader model
        , tableBody model matching_repos
        ]


displayLinks : Model -> MatchingRepos -> Html Msg
displayLinks model matching_repos =
    div [ class "buttonGroup" ] (List.map (displayLink model) matching_repos.links)


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


tableBody : Model -> MatchingRepos -> Html Msg
tableBody model matching_repos =
    tbody []
        (matching_repos.items
            |> List.map renderRepo
            |> List.concat
        )


renderRepo : RepoItem -> List (Html Msg)
renderRepo item =
    [ getMainRepoItemRow item
    , getDescriptionRepoItemRow item
    ]


getMainRepoItemRow : RepoItem -> Html Msg
getMainRepoItemRow item =
    let
        userLookupCmd =
            (StartUserSearch item.owner.login item.owner.url item.owner.avatar_url)
    in
        tr []
            [ td [ class "repoName" ] [ text item.name ]
            , td [] [ text item.full_name ]
            , td [] [ text <| if item.fork then "Yes" else "No" ]
            , td [ class "ownerLogin" ]
                [ a [ onClick userLookupCmd ]
                    [ text item.owner.login ]
                ]
            , td [ class "avatar"]
                [ case item.owner.avatar_url of
                    Nothing ->
                        text "Missing"

                    Just avatar_url ->
                        a [onClick userLookupCmd]
                            [ img
                                [ class "avatar"
                                , src avatar_url
                                ]
                                []
                            ]
                ]
            , td [] [ a [ href item.html_url ] [ text "View on Github" ] ]
            ]


getDescriptionRepoItemRow : RepoItem -> Html Msg
getDescriptionRepoItemRow item =
    tr
        []
        [ td
            [ colspan 5 ]
            [ text (Maybe.withDefault "(no description)" item.description) ]
        ]


tableHeader : Model -> Html Msg
tableHeader model =
    thead []
        [ tr []
            [ colHeader "Name"
            , colHeader "Full Name"
            , colHeader "Fork"
            , colHeader "Owner"
            , colHeader "Avatar"
            , colHeader ""
            ]
        ]


colHeader : String -> Html Msg
colHeader col =
    th []
        [ text col
        ]
