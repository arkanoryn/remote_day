defmodule RemoteDayWeb.Context do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn
  alias RemoteDay.Account.Guardian
  require Logger

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        Guardian.resource_from_claims(claims)

      {:error, error} ->
        Logger.info("status='failure' reasons='#{inspect(error)}'")
        Logger.debug("token='#{token}'")
        {:error, error}

      nil ->
        Logger.error("token='#{token}' status='failure' reasons='unknown'")
        {:error, "Unauthorized"}
    end
  end
end
