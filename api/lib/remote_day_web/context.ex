defmodule RemoteDayWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias RemoteDay.Account.Guardian
  alias RemoteDay.Repo
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
      {:ok, claims} -> res = Guardian.resource_from_claims(claims)
      {:error, error} -> {:error, error}
      nil -> {:error, "Unauthorized"}
    end
  end
end
