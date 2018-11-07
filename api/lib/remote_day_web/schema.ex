defmodule RemoteDayWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  alias RemoteDayWeb.Resolvers.Tmp

  object :mine do
    field(:random, :string)
  end

  query do
    field(:random_tmp, :mine) do
      resolve(&Tmp.my_random/3)
    end
  end
end
