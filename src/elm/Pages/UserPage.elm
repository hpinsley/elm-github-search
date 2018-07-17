module Pages.UserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)

view : Model -> Html Msg
view model =
    case model.user of
        Nothing ->
            no_user

        Just user ->
            displayUser model user


no_user : Html Msg
no_user =
    text "No user"


displayUser : Model -> User -> Html Msg
displayUser model user =
    div []
        [ h1 [] [ text user.login ]
        , case user.avatar_url of
            Nothing ->
                text ""

            Just image_url ->
                img [ src image_url ] []
        , table [class "userTable"]
            [
                tr []
                    [ td []
                        [ text "Bio:"
                        ]
                    , td []
                        [ text <| Maybe.withDefault "" user.bio
                        ]
                    ]
                , tr []
                    [ td []
                        [ text "Repos:"
                        ]
                    , td []
                        [ text <| user.repos_url
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
