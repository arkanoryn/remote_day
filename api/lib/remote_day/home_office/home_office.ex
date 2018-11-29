defmodule RemoteDay.HomeOffice do
  @moduledoc """
    HomeOffice context.
  """
  alias RemoteDay.HomeOffice.Event
  alias RemoteDay.Repo

  ###################################
  ###################################
  ##                               ##
  ##      ABSINTHE DATALOADER      ##
  ##                               ##
  ###################################
  ###################################
  def data(params), do: Dataloader.Ecto.new(Repo, query: &query/2, default_params: params)

  def query(query, _args), do: query

  ###################################
  ###################################
  ##                               ##
  ##              EVENTS           ##
  ##                               ##
  ###################################
  ###################################

  @doc """
  Returns the list of events.

  ## Examples
    iex> list_events()
    [%Event{}, ...]
  """
  @spec list_events :: [Event.t()]
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Returns the list of events after starting_date and up to `limit` days after it.
  If `limit = 0`, it will return the list of events from today up to the last event.
  If `starting_date = :today`, starting_date will be replace by the date of today.
  """
  @spec list_events(:today | Timex.Date.t(), non_neg_integer()) :: [Event] | no_return
  def list_events(starting_date, limit \\ 0)
  def list_events(:today, limit), do: list_events(Timex.today(), limit)

  def list_events(starting_date, 0) do
    Event
    |> Event.with_user()
    |> Event.from_date(starting_date)
    |> Repo.all()
  end

  def list_events(starting_date, limit) do
    end_date = Timex.add(starting_date, Timex.Duration.from_days(limit))

    Event
    |> Event.with_user()
    |> Event.between_dates(starting_date, end_date)
    |> Repo.all()
  end

  @doc """
  Creates an Event with provided attrs and returns the newly created Event.
  """
  @spec create_event(map()) :: Event.t()
  def create_event(%{} = attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates provided Event with provided attrs and returns the newly created Event.
  """
  @spec update_event(Event.t(), map()) :: Event.t()
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @spec get_events_by!([...]) :: [Event.t()]
  def get_events_by!(opts \\ []) do
    Event
    |> (fn q -> if opts[:date], do: Event.by_date(q, opts[:date]), else: q end).()
    |> (fn q -> if opts[:user_id], do: Event.by_user_id(q, opts[:user_id]), else: q end).()
    |> (fn q -> if opts[:kind], do: Event.by_kind(q, opts[:kind]), else: q end).()
    |> Repo.all()
  end

  @doc """
  Deletes provided Event and returns the last value of the Event.
  """
  @spec delete_event(Event.t()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @spec delete_event(pos_integer()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def delete_event(id) when is_integer(id) do
    Event
    |> Repo.get!(id)
    |> Repo.delete()
  end
end
