defmodule RemoteDayWeb.Resolvers.Account do
  @moduledoc """
  Module resolves Account related queries
  """
  alias RemoteDay.Account
  alias RemoteDayWeb.ErrorHelpers
  require Logger

  def create_user(
        _root,
        %{email: email, username: _username, password: pwd, password_confirmation: _pwd_conf} =
          attrs,
        _info
      ) do
    Logger.debug("attrs=#{inspect(attrs)}")

    with {:ok, _user} <- Account.create_user(attrs),
         {:ok, user, token} <- Account.login(%{email: email, password: pwd}) do
      Logger.info("status='success'", user_id: user.id)
      {:ok, %{user: user, token: token}}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.info("status='failure' user='unknown' reasons='#{changeset}'", user_id: "unknown")
        Logger.debug("attrs='#{inspect(attrs)}'", user_id: "unknown")
        {:error, ErrorHelpers.handle_changeset_errors(changeset.errors)}
    end
  end

  def authenticate(_root, %{email: _email, password: _pwd} = attrs, _info) do
    case Account.login(attrs) do
      {:ok, user, token} ->
        Logger.info("status='success'", user_id: user.id)
        {:ok, %{user: user, token: token}}

      {:error, error} ->
        Logger.info("status='failure' reasons='#{inspect(error)}'", user_id: "unknown")

        {:error, "invalid credentials"}
    end
  end
end
