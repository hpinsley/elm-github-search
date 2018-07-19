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
        , table [ class "userTable" ]
            [ tbody []
                [ userInfoRow "Bio:" (text <| Maybe.withDefault "" user.bio)
                , userInfoRow "Repos:" (text user.repos_url)
                , userInfoRow "Followers:" (text <| toString user.followers)
                , userInfoRow "Following:" (text <| toString user.following)
                ]
            ]
        , displayAdditionalButtons model
        ]


userInfoRow : String -> Html Msg -> Html Msg
userInfoRow rowLabel valueElement =
    tr []
        [ td []
            [ text rowLabel
            ]
        , td []
            [ valueElement
            ]
        ]


displayAdditionalButtons : Model -> Html Msg
displayAdditionalButtons model =
    div [ class "buttonGroup" ]
        [ button
            [ class "btn btn-primary btn-lg"
            , onClick ReturnToRepoSearchResults
            ]
            [ text "Return to Search Results" ]
        ]
