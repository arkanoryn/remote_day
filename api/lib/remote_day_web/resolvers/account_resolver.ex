defmodule RemoteDayWeb.Resolvers.Account do
  @moduledoc """
  Module resolves Account related queries
  """
  require Logger

  alias RemoteDay.Account
  alias RemoteDayWeb.ErrorHelpers

  def create_user(
        _root,
        %{email: email, username: _username, password: pwd, password_confirmation: _pwd_conf} =
          attrs,
        _info
      ) do
    Logger.info("Resolver.Account#create_user: begin")

    with {:ok, _user} <- Account.create_user(attrs),
         {:ok, user, token} <- Account.login(%{email: email, password: pwd}) do
      Logger.info("Resolver.Account#create_user: success")
      {:ok, %{user: user, token: token}}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.info("Resolver.Account#create_user:changeset_err\n#{inspect(changeset.errors)}")

        {:error, RemoteDayWeb.ErrorHelpers.handle_changeset_errors(changeset.errors)}
    end
  end

  def authenticate(_root, %{email: _email, password: _password} = attrs, _info) do
    Logger.info("Resolver.Account#authenticate: begin")

    case Account.login(attrs) do
      {:ok, user, token} ->
        Logger.info("Resolver.Account#authenticate: user [#{user.id}] successfully authenticated")
        {:ok, %{user: user, token: token}}

      {:error, error} ->
        Logger.info("Resolver.Account#authenticate: err.\n\n#{error}")
        {:error, "invalid credentials"}
    end
  end
end
