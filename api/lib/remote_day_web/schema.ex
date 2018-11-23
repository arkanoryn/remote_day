defmodule RemoteDayWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  alias RemoteDayWeb.Schema.Types.{Events, Users}

  # imports of types
  import_types(Events)
  import_types(Users)

  query do
    import_fields(:events_queries)
  end

  mutation do
    import_fields(:events_mutations)
    import_fields(:users_mutations)
  end
end
