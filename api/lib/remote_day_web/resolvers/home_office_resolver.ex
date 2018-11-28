defmodule RemoteDayWeb.Resolvers.HomeOffice do
  @moduledoc """
  Module resolves HomeOffice related queries
  """
  require Logger

  alias RemoteDay.{
    Emails.LateRemoteWorkers,
    HomeOffice,
    HomeOffice.Event,
    Mailer
  }

  alias RemoteDayWeb.ErrorHelpers

  @default_event_kind "day"

  @spec all_events(any, %{starting_date: Timex.Date.t() | :today, limit: pos_integer}, any) :: [
          Event.t()
        ]
  @spec all_events(any, %{starting_date: Timex.Date.t() | :today}, any) :: [Event.t()]
  def all_events(_root, %{starting_date: starting_date, limit: limit}, _info) do
    Logger.info("Resolver.HomeOffice#all_events: begin")

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

  @spec create_event(any, %{date: Timex.Date.t()}, any) :: {:ok, Event.t()} | {:error, String.t()}
  @spec create_event(any, %{date: Timex.Date.t(), kind: String.t()}, any) ::
          {:ok, Event.t()} | {:error, String.t()}
  def create_event(
        _root,
        %{date: date, kind: _k} = attrs,
        %{context: %{current_user: current_user}}
      ) do
    Logger.info("Resolver.HomeOffice#create_event: begin")
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
              |> LateRemoteWorkers.announcement()
              |> Mailer.deliver_later()
            end

            {:ok, event}

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.info(
              "Resolver.HomeOffice#create_event:changerror:\n#{inspect(changeset.errors)}\n-------\n"
            )

            {:error, ErrorHelpers.handle_changeset_errors(changeset.errors)}
        end

      false ->
        {:error, "A user can only create one event per day"}
    end
  end

  def create_event(root, %{date: _d} = attrs, info),
    do: create_event(root, Map.put(attrs, :kind, @default_event_kind), info)

  defp string_to_date(str), do: str |> Timex.parse!("{YYYY}-{M}-{D}") |> Timex.to_date()
end
