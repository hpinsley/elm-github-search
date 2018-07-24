module Pages.UserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import GithubTypes exposing (..)
import Services


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
    div [ class "userInfo" ]
        [ h1 [] [ text user.login ]
        , case user.avatar_url of
            Nothing ->
                text ""

            Just image_url ->
                img [ src image_url, class "mediumAvatar" ] []
        , table [ class "userTable" ]
            [ tbody []
                [ userInfoRow "Url:" (a [ href user.html_url ] [ text <| user.login ++ "'s User Page" ])
                , userInfoRow "Repos:" (a [ onClick <| StartUserRepoSearch user.login user.repos_url ] [ text <| user.login ++ "'s Repos (api)" ])
                , userInfoRow "Bio:" (text <| Maybe.withDefault "" user.bio)
                , userInfoRow "Followers:" (text <| toString user.followers)
                , userInfoRow "Following:" (text <| toString user.following)
                , userInfoRow "Public Repos:" (text <| toString user.public_repos)
                , userInfoRow "Public Gists:" (text <| toString user.public_gists)
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
