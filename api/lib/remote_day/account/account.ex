defmodule RemoteDay.Account do
  @moduledoc """
  Account context
  """
  import Comeonin.Bcrypt, only: [check_pass: 2, dummy_checkpw: 0]

  alias RemoteDay.Account.{Guardian, User}
  alias RemoteDay.Repo

  def create_user(
        %{email: _email, username: _username, password: _pwd, password_confirmation: _pwd_conf} =
          attrs
      ) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(%{id: id}) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get(User, id)
  end

  def get_user_by!(%{email: email}), do: get_user_by!(:email, email)

  def get_user_by!(:email, email) do
    Repo.get_by(User, email: String.downcase(email))
  end

  def login(%{email: email, password: pwd}) do
    with user <- get_user_by!(:email, email),
         {:ok, user} <- authenticate(user, pwd),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      {:ok, user, token}
    else
      err -> err
    end
  end

  defp authenticate(user, password) do
    case user do
      nil ->
        dummy_checkpw()
        {:error, :unauthorized}

      _ ->
        check_pass(user, password)
    end
  end
end
