module GithubTypes exposing (..)

type alias RepoQueryResult =
    {
          total_count: Int
        , incomplete_result: Bool
        , items: List RepoItem
        , linkHeader: Maybe String
    }

type alias RepoItem =
    {
          id: Int
        , name: String
        , full_name: String
        , private: Bool
    }