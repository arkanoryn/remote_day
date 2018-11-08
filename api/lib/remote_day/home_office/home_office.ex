defmodule RemoteDay.HomeOffice do
  @moduledoc """
    HomeOffice context.
  """

  alias RemoteDay.HomeOffice.Event
  alias RemoteDay.Repo

  @doc """
  Returns the list of events.

  ## Examples
    iex> list_events()
    [%Event{}, ...]
  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Returns the list of events after starting_date and up to `limit` days after it.
  If `limit = 0`, it will return the list of events from today up to the last event.
  If `starting_date = :today`, starting_date will be replace by the date of today.
  """
  def list_events(starting_date, limit \\ 0)
  def list_events(:today, limit), do: list_events(Timex.today(), limit)

  def list_events(starting_date, 0) do
    Event
    |> Event.from_date(starting_date)
    |> Repo.all()
  end

  def list_events(starting_date, limit) do
    end_date = Timex.add(starting_date, Timex.Duration.from_days(limit))

    Event
    |> Event.between_dates(starting_date, end_date)
    |> Repo.all()
  end

  @doc """
  Creates an Event with provided attrs and returns the newly created Event.
  """
  def create_event(%{} = attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates provided Event with provided attrs and returns the newly created Event.
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes provided Event and returns the last value of the Event.
  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def delete_event(id) when is_integer(id) do
    Event
    |> Repo.get!(id)
    |> Repo.delete()
  end
end
