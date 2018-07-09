module Decoders exposing (..)

import Json.Decode exposing (int, string, float, nullable, list, bool, succeed, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

import GithubTypes exposing (..)

repoSearchResultDecoder : Decoder RepoQueryResult
repoSearchResultDecoder =
    decode RepoQueryResult
        |> required "total_count" int
        |> required "incomplete_result" bool
