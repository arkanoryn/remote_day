defmodule RemoteDayWeb.Resolvers.HomeOffice do
  @moduledoc """
  Module resolves HomeOffice related queries
  """
  alias RemoteDay.{
    Emails.LateRemoteDay,
    HomeOffice,
    Mailer
  }

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
    events = HomeOffice.get_events_by!(date: date, user_id: current_user.id)

    case Enum.empty?(events) do
      true ->
        attrs = if is_bitstring(date), do: %{attrs | date: string_to_date(date)}, else: attrs
        attrs = Map.put(attrs, :user_id, current_user.id)

        case HomeOffice.create_event(attrs) do
          {:ok, event} ->
            deadline = Timex.today() |> Timex.to_datetime() |> Timex.shift(hours: 9, minutes: 30)

            if event.date == Timex.today() && Timex.diff(deadline, Timex.now()) <= 0 do
              current_user
              |> LateRemoteDay.email()
              |> Mailer.deliver_later()
            end

            {:ok, event}

          {:error, errors} ->
            parsed_errors = Enum.map(errors.errors, fn {key, {msg, _}} -> "#{key}: #{msg}" end)
            {:error, parsed_errors}
        end

      false ->
        {:error, "A user can only create one event per day"}
    end
  end

  def create_event(root, %{date: _d} = attrs, info),
    do: create_event(root, Map.put(attrs, :kind, @default_event_kind), info)

  defp string_to_date(str), do: str |> Timex.parse!("{YYYY}-{M}-{D}") |> Timex.to_date()
end
