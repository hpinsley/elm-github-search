module Decoders exposing (..)

import Json.Decode exposing (int, string, float, nullable, list, bool, succeed, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import GithubTypes exposing (..)

repoSearchResultDecoder : Decoder RepoQueryResult
repoSearchResultDecoder =
    decode RepoQueryResult
        |> required "total_count" int
        |> required "incomplete_results" bool
        |> required "items" (list repoItemDecoder)

repoItemDecoder : Decoder RepoItem
repoItemDecoder =
    decode RepoItem
        |> required "id" int
        |> required "name" string
        |> required "full_name" string
        |> required "private" bool