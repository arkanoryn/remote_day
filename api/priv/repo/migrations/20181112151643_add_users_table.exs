defmodule RemoteDay.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:username, :string)
      add(:password_hash, :string)

      timestamps()
    end

    create(unique_index(:users, :email))
    create(index(:users, :username))
  end
end
