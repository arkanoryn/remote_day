defmodule RemoteDay.Account.User do
  @moduledoc """
  The User schema for Account.

  * username
  * email
  * password_hash
  * password
  * password_confirmation
  """
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  import Ecto.Changeset

  alias RemoteDay.HomeOffice.Event

  @required_fields ~w(username password password_confirmation email)a

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:events, RemoteDay.HomeOffice.Event)

    timestamps()
  end

  def changeset(%__MODULE__{} = model, attrs \\ :empty) do
    model
    |> cast(attrs, @required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, max: 128)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
