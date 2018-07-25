module GithubTypes exposing (..)

import Date

type alias RepoQueryResult =
    {
          total_count: Int
        , incomplete_result: Bool
        , items: List RepoItem
        , linkHeader: Maybe String
    }

type alias UserReposQueryResult =
    {
          items: List RepoItem
        , linkHeader: Maybe String
    }

type alias Owner = {
      login: String
    , url: String
    , avatar_url: Maybe String
    , repos_url: String
}

type alias User = {
      login: String
    , url: String
    , html_url: String
    , avatar_url: Maybe String
    , repos_url: String
    , bio: Maybe String
    , public_repos: Int
    , public_gists: Int
    , followers: Int
    , following: Int
}

type alias RepoItem =
    {
          id: Int
        , name: String
        , full_name: String
        , private: Bool
        , fork: Bool
        , url: String
        , html_url: String
        , owner: Owner
        , description: Maybe String
        , stargazers_count: Int
        , watchers_count: Int
    }