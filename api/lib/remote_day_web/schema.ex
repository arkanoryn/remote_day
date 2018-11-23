defmodule RemoteDayWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  alias RemoteDay.Account
  alias RemoteDayWeb.Schema.Types.{Events, Users}

  def context(ctx), do: Map.put(ctx, :loader, loader(ctx))

  def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]

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

  defp loader(ctx) do
    default_params = default_params(ctx)

    Enum.reduce(
      sources(),
      Dataloader.new(),
      &Dataloader.add_source(&2, &1, :erlang.apply(&1, :data, [default_params]))
    )
  end

  defp default_params(%{current_user: current_user}), do: %{current_user: current_user}
  defp default_params(_), do: %{current_user: nil}

  defp sources do
    [
      Account
    ]
  end
end
