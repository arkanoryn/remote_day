defmodule RemoteDayWeb.Schema.Middleware.Authorize do
  @moduledoc """
  Absinthe Middleware to verify if the token received in parameter is valid and
  the user is authorized to access the resources
  """
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  require Logger

  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        Logger.info("Unauthorized request: user not authenticated.")
        Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end
end
