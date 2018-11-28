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

  @type t :: %__MODULE__{
          username: String.t(),
          email: String.t(),
          password_hash: String.t(),
          events: [Event.t()]
        }

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:events, Event)

    timestamps()
  end

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
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
