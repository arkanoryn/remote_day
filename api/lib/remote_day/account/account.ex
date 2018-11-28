defmodule RemoteDay.Account do
  @moduledoc """
  Account context
  """
  import Comeonin.Bcrypt, only: [check_pass: 2, dummy_checkpw: 0]

  alias RemoteDay.Account.{Guardian, User}
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
  ##              USERS            ##
  ##                               ##
  ###################################
  ###################################
  @spec list_users :: [User.t()]
  def list_users do
    Repo.all(User)
  end

  @spec create_user(%{
          email: String.t(),
          username: String.t(),
          password: String.t(),
          password_confirmation: String.t()
        }) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(
        %{email: _email, username: _username, password: _pwd, password_confirmation: _pwd_conf} =
          attrs
      ) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user!(number) :: User.t() | nil
  def get_user!(id) do
    Repo.get(User, id)
  end

  @spec get_user_by!(%{email: String.t()}) :: User.t() | nil
  def get_user_by!(%{email: email}), do: get_user_by!(email: email)

  @spec get_user_by!(email: String.t()) :: User.t() | nil
  def get_user_by!(email: email) do
    Repo.get_by(User, email: String.downcase(email))
  end

  ###################################
  ###################################
  ##                               ##
  ##        AUTHENTICATION         ##
  ##                               ##
  ###################################
  ###################################
  @spec login(%{email: String.t(), password: String.t()}) ::
          {:ok, User.t(), String.t()} | {:error, atom()}
  def login(%{email: email, password: pwd}), do: login(email: email, password: pwd)

  @spec login(email: String.t(), password: String.t()) ::
          {:ok, User.t(), String.t()} | {:error, atom()}
  def login(email: email, password: pwd) do
    with user <- get_user_by!(email: email),
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
