defmodule RemoteDay.Repo.Migrations.AddEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:user_id, :integer)
      add(:date, :date)
      add(:kind, :string)

      timestamps()
    end

    create(index(:events, [:user_id]))
  end
end
