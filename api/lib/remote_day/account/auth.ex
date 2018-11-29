defmodule RemoteDay.Account.Auth do
  @moduledoc false
  import Comeonin.Bcrypt, only: [check_pass: 2, dummy_checkpw: 0]
  alias RemoteDay.Account.User

  @spec authenticate(User.t() | nil, String.t()) :: {:ok, User.t()} | {:error, :unauthorized}
  def authenticate(user, password) do
    case user do
      nil ->
        dummy_checkpw()
        {:error, :unauthorized}

      _ ->
        check_pass(user, password)
    end
  end
end
