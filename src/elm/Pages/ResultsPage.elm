module Pages.ResultsPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)

view : Model -> Html Msg
view model =
    div []
        [ h2 []
            [ text <| "Result count " ++ (toString model.result_count)
            ]
        , displayResultsTable model
        , button
            [ class "btn btn-primary btn-lg"
            , onClick StartNewSearch
            ]
            [ text "New Search" ]
        ]


displayResultsTable : Model -> Html Msg
displayResultsTable model =
    table [ class "table table-dark" ]
        [   tableHeader model
          , tableBody model
        ]

tableBody : Model -> Html Msg
tableBody model =
    tbody []
    (List.map getDataRow model.matching_repos)

getDataRow : RepoItem -> Html Msg
getDataRow item =
  tr []
  [
      td [][text (toString item.id)]
    , td [][text item.name]
    , td [][text item.full_name]
    , td [][text (toString item.private)]
  ]

tableHeader : Model -> Html Msg
tableHeader model =
    thead []
        [ tr []
            [ colHeader "Id"
            , colHeader "Name"
            , colHeader "Full Name"
            , colHeader "Private"
            ]
        ]


colHeader : String -> Html Msg
colHeader col =
    th []
        [ text col
        ]
