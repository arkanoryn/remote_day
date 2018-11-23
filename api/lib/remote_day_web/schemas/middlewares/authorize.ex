defmodule RemoteDayWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  require Logger

  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        Logger.info("Unauthorized request: user not authenticated.")
        Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end
end
