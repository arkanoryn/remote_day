defmodule RemoteDayWeb.Schema do
  use Absinthe.Schema

  alias RemoteDayWeb.Resolvers

  object :mine do
    field(:random, :string)
  end

  query do
    field(:random_tmp, :mine) do
      resolve(&Resolvers.Tmp.my_random/3)
    end
  end
end
