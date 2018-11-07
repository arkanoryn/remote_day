defmodule RemoteDayWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  alias RemoteDayWeb.Resolvers.Tmp

  # imports of types
  import_types(RemoteDayWeb.Schema.EventTypes)

  object :mine do
    field(:random, :string)
  end

  query do
    import_fields(:events_queries)

    field(:random_tmp, :mine) do
      resolve(&Tmp.my_random/3)
    end
  end
end
