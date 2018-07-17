module Pages.OwnerPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)

view : Model -> Html Msg
view model =
    case model.owner of
        Nothing ->
            no_owner

        Just owner ->
            displayOwner model owner


no_owner : Html Msg
no_owner =
    text "No owner"


displayOwner : Model -> Owner -> Html Msg
displayOwner model owner =
    div []
        [ h1 [] [ text owner.login ]
        , case owner.avatar_url of
            Nothing ->
                text ""

            Just image_url ->
                img [ src image_url ] []
        , table []
            [ tr []
                [ td []
                    [ text "Repos:"
                    ]
                , td []
                    [ text <| owner.repos_url
                    ]
                ]
            ]
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
