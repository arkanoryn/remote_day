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

  schema "events" do
    field(:date, Timex.Ecto.Date)
    field(:kind, :string, default: "day")

    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(event, %{} = attrs) do
    event
    |> cast(attrs, ~w(user_id date kind)a)
    |> validate_required(~w(user_id date kind)a)
    |> date_greater_or_equal_to_today(:date)
    |> foreign_key_constraint(:user_id)
  end

  def between_dates(query, starting_date, end_date) do
    from(c in query, where: c.date >= ^starting_date, where: c.date < ^end_date)
  end

  def by_date(query, date) do
    from(c in query, where: c.date >= ^date)
  end

  def from_date(query, starting_date) do
    from(c in query, where: c.date >= ^starting_date)
  end

  def by_user_id(query, user_id) do
    from(c in query, where: c.user_id >= ^user_id)
  end

  def by_kind(query, kind) do
    from(c in query, where: c.kind >= ^kind)
  end

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
