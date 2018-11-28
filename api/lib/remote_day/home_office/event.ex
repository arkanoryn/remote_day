defmodule RemoteDay.HomeOffice.Event do
  @moduledoc """
  The Event schema for homeoffice day.

  user_id:  id of user creating the event
  date:     date at which the event takes place
  kind:     kind of event ("day", "late_arrival")
  """
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias RemoteDay.Account.User

  @type t :: %__MODULE__{
          date: Timex.Ecto.Date.t(),
          kind: String.t(),
          user: User.t()
        }

  schema "events" do
    field(:date, Timex.Ecto.Date)
    field(:kind, :string, default: "day")

    belongs_to(:user, User)
    timestamps()
  end

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = event, %{} = attrs \\ :empty) do
    event
    |> cast(attrs, ~w(user_id date kind)a)
    |> validate_required(~w(user_id date kind)a)
    |> date_greater_or_equal_to_today(:date)
    |> foreign_key_constraint(:user_id)
  end

  @spec between_dates(Ecto.Query.t(), Timex.Date.t(), Timex.Date.t()) :: Ecto.Query.t()
  def between_dates(query, starting_date, end_date) do
    from(c in query, where: c.date >= ^starting_date, where: c.date < ^end_date)
  end

  @spec by_date(Ecto.Query.t(), Timex.Date.t()) :: Ecto.Query.t()
  def by_date(query, date) do
    from(c in query, where: c.date == ^date)
  end

  @spec from_date(Ecto.Query.t(), Timex.Date.t()) :: Ecto.Query.t()
  def from_date(query, starting_date) do
    from(c in query, where: c.date >= ^starting_date)
  end

  @spec by_user_id(Ecto.Query.t(), integer()) :: Ecto.Query.t()
  def by_user_id(query, user_id) do
    from(e in query, join: u in assoc(e, :user), where: u.id == ^user_id)
  end

  @spec by_kind(Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  def by_kind(query, kind) do
    from(c in query, where: c.kind == ^kind)
  end

  @spec with_user(Ecto.Query.t()) :: Ecto.Query.t()
  def with_user(query) do
    from(c in query, preload: [:user])
  end

  defp date_greater_or_equal_to_today(changeset, field) do
    validate_change(changeset, field, fn _, date ->
      case Timex.diff(date, Timex.today(), :days) >= 0 do
        true -> []
        false -> [{field, "can only be today or future date"}]
      end
    end)
  end
end
