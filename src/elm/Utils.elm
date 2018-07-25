module Utils exposing (..)

import Http exposing (..)
import Types exposing (..)

initialCap: String -> String
initialCap input =
    (++)
        (input|> String.left 1 |> String.toUpper)
        (String.dropLeft 1 input)

httpErrorMessage : Http.Error -> String
httpErrorMessage error =
    case error of
        Http.BadUrl url ->
            "Bad Url " ++ url

        Http.Timeout ->
             "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus _ ->
            "Bad Status"

        Http.BadPayload errmsg _ ->
            "Bad Payload: " ++ errmsg

getSearchTerm: SearchType -> String
getSearchTerm searchType =
    case searchType of
        NotSearching ->
            ""
        RepoQuery (UserRepoSearch login) ->
            login ++ "'s repositories..."

        RepoQuery (GeneralRepoSearch query) ->
            "repos matching " ++ query

        UserLookup login _ ->
            "user " ++ login