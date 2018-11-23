defmodule RemoteDayWeb.Resolvers.HomeOffice do
  @moduledoc """
  Module resolves HomeOffice related queries
  """
  alias RemoteDay.HomeOffice

  @default_event_kind "day"

  def all_events(_root, %{starting_date: starting_date, limit: limit}, _info) do
    starting_date =
      case starting_date do
        "today" -> :today
        _ -> string_to_date(starting_date)
      end

    events = HomeOffice.list_events(starting_date, limit)

    {:ok, events}
  end

  def all_events(root, %{starting_date: starting_date}, info),
    do: all_events(root, %{starting_date: starting_date, limit: 0}, info)

  def create_event(
        _root,
        %{date: date, kind: _k} = attrs,
        %{context: %{current_user: current_user}}
      ) do
    attrs = if is_bitstring(date), do: %{attrs | date: string_to_date(date)}, else: attrs
    attrs = Map.put(attrs, :user_id, current_user.id)

    case HomeOffice.create_event(attrs) do
      {:ok, event} ->
        {:ok, event}

      {:error, _errors} ->
        # TODO: improve error hanlding
        {:error, "An error occured."}
    end
  end

  def create_event(root, %{date: _d, user_id: _uid} = attrs, info),
    do: create_event(root, Map.put(attrs, :kind, @default_event_kind), info)

  defp string_to_date(str), do: str |> Timex.parse!("{YYYY}-{M}-{D}") |> Timex.to_date()
end
