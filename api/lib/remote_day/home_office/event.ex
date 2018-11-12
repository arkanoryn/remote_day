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

  schema "events" do
    field(:user_id, :integer)
    field(:date, Timex.Ecto.Date)
    field(:kind, :string, default: "day")

    timestamps()
  end

  @doc false
  def changeset(event, %{} = attrs) do
    event
    |> cast(attrs, ~w(user_id date kind)a)
    |> validate_required(~w(user_id date kind)a)
    |> date_greater_or_equal_to_today(:date)
  end

  def between_dates(query, starting_date, end_date) do
    from(c in query, where: c.date >= ^starting_date, where: c.date < ^end_date)
  end

  def from_date(query, starting_date) do
    from(c in query, where: c.date >= ^starting_date)
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