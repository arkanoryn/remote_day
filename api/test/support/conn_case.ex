defmodule RemoteDayWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Phoenix.ConnTest
  alias Plug.Conn
  alias RemoteDay.Account
  alias RemoteDay.Repo

  using do
    quote do
      # Import conveniences for testing with connections
      use ConnTest
      import RemoteDayWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint RemoteDayWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    {conn, user} =
      if tags[:authenticated] do
        user_params = RemoteDay.Factory.params_for(:user)
        {:ok, user} = Account.create_user(user_params)
        {:ok, _u, token} = Account.login(user_params)

        conn = ConnTest.build_conn() |> Conn.put_req_header("authorization", "Bearer #{token}")

        {conn, user}
      else
        {ConnTest.build_conn(), nil}
      end

    {:ok, conn: conn, auth_user: user}
  end
end
