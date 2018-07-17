module Pages.ResultsPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)
import Utils

view : Model -> Html Msg
view model =
    div []
        [ h2 []
            [ text <| "Result count " ++ (toString model.result_count)
            ]
        , displayResultsTable model
        , displayLinks model
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


displayResultsTable : Model -> Html Msg
displayResultsTable model =
    table
        [ id "repo-results-table"
        , class "table table-dark"
        ]
        [ tableHeader model
        , tableBody model
        ]


displayLinks : Model -> Html Msg
displayLinks model =
    div [ class "buttonGroup" ] (List.map displayLink model.links)


displayLink : Link -> Html Msg
displayLink link =
    button
        [ class "btn btn-primary btn-lg"
        , onClick (SearchReposViaUrl link.link)
        ]
        [ text <| Utils.initialCap link.rel ]


tableBody : Model -> Html Msg
tableBody model =
    tbody []
        (model.matching_repos
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
    tr []
        [ td [ class "repoName" ] [ text item.name ]
        , td [] [ text item.full_name ]
        , td []
            [ a [ onClick (StartUserSearch item.owner.login item.owner.url item.owner.avatar_url) ]
                [ text item.owner.login ]
            ]
        , td []
            [ case item.owner.avatar_url of
                Nothing ->
                    text "Missing"

                Just avatar_url ->
                    img
                        [ class "avatar"
                        , src avatar_url
                        ]
                        []
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
