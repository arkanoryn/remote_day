defmodule RemoteDayWeb.Router do
  use RemoteDayWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api" do
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: RemoteDayWeb.Schema, interface: :simple)
  end
end
