defmodule RemoteDayWeb.Resolvers.HomeOffice do
  @moduledoc """
  Module resolves HomeOffice related queries
  """
  alias RemoteDay.{
    Emails.LateRemoteWorkers,
    HomeOffice,
    HomeOffice.Event,
    Mailer
  }

  alias RemoteDayWeb.ErrorHelpers
  require Logger

  @default_event_kind "day"

  @spec all_events(any, %{starting_date: Timex.Date.t() | :today, limit: pos_integer}, any) :: [
          Event.t()
        ]
  @spec all_events(any, %{starting_date: Timex.Date.t() | :today}, any) :: [Event.t()]
  def all_events(
        _root,
        %{starting_date: starting_date, limit: limit},
        %{context: %{current_user: current_user}}
      ) do
    Logger.debug("starting_date='#{starting_date}' limit='#{limit}'", user_id: current_user.id)

    starting_date =
      case starting_date do
        "today" -> :today
        _ -> string_to_date(starting_date)
      end

    Logger.debug("starting_date='#{starting_date}' limit='#{limit}'", user_id: current_user.id)

    events = HomeOffice.list_events(starting_date, limit)
    Logger.debug("events='#{inspect(events)}'", user_id: current_user.id)

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
    events = HomeOffice.get_events_by!(date: date, user_id: current_user.id)

    Logger.debug("attrs=#{inspect(attrs)} events='#{inspect(events)}'", user_id: current_user.id)

    case Enum.empty?(events) do
      true ->
        attrs = if is_bitstring(date), do: %{attrs | date: string_to_date(date)}, else: attrs
        attrs = Map.put(attrs, :user_id, current_user.id)
        Logger.debug("create_event: attrs='#{inspect(attrs)}'", user_id: current_user.id)

        case HomeOffice.create_event(attrs) do
          {:ok, event} ->
            Logger.info("status='success' event='#{event.id}'", user_id: current_user.id)
            send_announcement(current_user, event)
            {:ok, event}

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.info("status='failure' reasons='#{inspect(changeset)}'",
              user_id: current_user.id
            )

            {:error, ErrorHelpers.handle_changeset_errors(changeset.errors)}
        end

      false ->
        Logger.info("status='failure' reasons='['already remote today']'",
          user_id: current_user.id
        )

        {:error, "A user can only create one event per day"}
    end
  end

  def create_event(root, %{date: _d} = attrs, info),
    do: create_event(root, Map.put(attrs, :kind, @default_event_kind), info)

  defp string_to_date(str), do: str |> Timex.parse!("{YYYY}-{M}-{D}") |> Timex.to_date()

  defp send_announcement(current_user, event) do
    deadline = Timex.today() |> Timex.to_datetime() |> Timex.shift(hours: 9, minutes: 30)

    if event.date == Timex.today() && Timex.diff(deadline, Timex.now()) <= 0 do
      current_user
      |> LateRemoteWorkers.announcement()
      |> Mailer.deliver_later()

      Logger.info("status='success' event='#{event.id}'", user_id: current_user.id)
      :sent
    else
      Logger.info("status='ok'  event='#{event.id}'", user_id: current_user.id)

      :not_sent
    end
  end
end
