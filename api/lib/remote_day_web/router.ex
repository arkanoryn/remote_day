defmodule RemoteDayWeb.Router do
  use RemoteDayWeb, :router

  forward("/v1", Absinthe.Plug, schema: RemoteDayWeb.Schema)

  scope "/test" do
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: RemoteDayWeb.Schema, interface: :simple)
  end
end
