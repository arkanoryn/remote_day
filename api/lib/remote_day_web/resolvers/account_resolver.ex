defmodule RemoteDayWeb.Resolvers.Account do
  @moduledoc """
  Module resolves Account related queries
  """
  require Logger

  alias RemoteDay.Account

  def create_user(
        _root,
        %{email: email, username: _username, password: pwd, password_confirmation: _pwd_conf} =
          attrs,
        _info
      ) do
    Account.create_user(attrs)
    {:ok, user, token} = Account.login(%{email: email, password: pwd})
    {:ok, %{user: user, token: token}}
  end

  def authenticate(_root, %{email: _email, password: _password} = attrs, _info) do
    case Account.login(attrs) do
      {:ok, user, token} ->
        Logger.info("Resolver.Account#authenticate: user [#{user.id}] successfully authenticated")
        {:ok, %{user: user, token: token}}

      {:error, error} ->
        Logger.info("Resolver.Account#authenticate: an error occured.\n\n#{error}")
        {:error, "invalid credentials"}
    end
  end
end
