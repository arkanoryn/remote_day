defmodule RemoteDayWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  # imports of types
  import_types(RemoteDayWeb.Schema.EventTypes)
  import_types(RemoteDayWeb.Schema.Types.Users)

  query do
    import_fields(:events_queries)
  end

  mutation do
    import_fields(:events_mutations)
    import_fields(:users_mutations)
  end
end
