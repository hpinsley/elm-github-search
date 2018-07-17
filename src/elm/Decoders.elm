module Decoders exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

import GithubTypes exposing (..)

ownerDecoder : Decoder Owner
ownerDecoder =
    decode Owner
        |> required "login" string
        |> required "url" string
        |> optional "avatar_url" (maybe string) Nothing
        |> required "repos_url" string

userDecoder : Decoder User
userDecoder =
    decode User
        |> required "login" string
        |> required "url" string
        |> optional "avatar_url" (maybe string) Nothing
        |> required "repos_url" string

repoSearchResultDecoder : Decoder RepoQueryResult
repoSearchResultDecoder =
    decode RepoQueryResult
        |> required "total_count" int
        |> required "incomplete_results" bool
        |> required "items" (list repoItemDecoder)
        |> optional "linkHeader" (maybe string) (Just "")

repoItemDecoder : Decoder RepoItem
repoItemDecoder =
    decode RepoItem
        |> required "id" int
        |> required "name" string
        |> required "full_name" string
        |> required "private" bool
        |> required "url" string
        |> required "html_url" string
        |> required "owner" ownerDecoder
        |> optional "description" (maybe string) Nothing