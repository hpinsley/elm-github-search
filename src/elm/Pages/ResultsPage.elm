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
    table [ class "table table-dark" ]
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
        (List.map getDataRow model.matching_repos)


getDataRow : RepoItem -> Html Msg
getDataRow item =
    tr []
        [ td [] [ text (toString item.id) ]
        , td [] [ text item.name ]
        , td [] [ text item.full_name ]
        , td [] [ text item.owner.login ]
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
        , td [] [ text (item.url) ]
        ]


tableHeader : Model -> Html Msg
tableHeader model =
    thead []
        [ tr []
            [ colHeader "Id"
            , colHeader "Name"
            , colHeader "Full Name"
            , colHeader "Owner"
            , colHeader "Avatar"
            , colHeader "Url"
            ]
        ]


colHeader : String -> Html Msg
colHeader col =
    th []
        [ text col
        ]
