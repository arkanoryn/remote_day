defmodule RemoteDayWeb.Router do
  use RemoteDayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RemoteDayWeb do
    pipe_through :api
  end
end
