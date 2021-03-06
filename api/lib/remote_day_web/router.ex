defmodule RemoteDayWeb.Router do
  use RemoteDayWeb, :router

  pipeline :graphql do
    plug(RemoteDayWeb.Context)
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/v1" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: RemoteDayWeb.Schema)
  end

  scope "/test" do
    pipe_through(:graphql)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: RemoteDayWeb.Schema, interface: :simple)
  end
end
