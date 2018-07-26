module Utils exposing (..)

import Http exposing (..)
import Types exposing (..)
import Date exposing (..)
import Time exposing (..)
import Date.Format exposing (format)

initialCap : String -> String
initialCap input =
    (++)
        (input |> String.left 1 |> String.toUpper)
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


getRepoSearchTerm : RepoSearchType -> String
getRepoSearchTerm repoSearchType =
    case repoSearchType of
        UserRepoSearch login ->
            login ++ "'s repositories..."

        GeneralRepoSearch query ->
            "repos matching " ++ query


getSearchTerm : SearchType -> String
getSearchTerm searchType =
    case searchType of
        NotSearching ->
            ""

        UserLookup login _ ->
            "user " ++ login

        RepoQuery repoSearchType ->
            getRepoSearchTerm repoSearchType

timeToFullDateDisplay : Time -> String
timeToFullDateDisplay time =
    time
        |> Date.fromTime
        |> format "%A %B %d %Y %I:%M:%S %p"
