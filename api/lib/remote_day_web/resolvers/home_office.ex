defmodule RemoteDayWeb.Resolvers.HomeOffice do
  alias RemoteDay.HomeOffice

  def all_events(root, %{starting_date: "today"}, info),
    do: all_events(root, %{starting_date: :today}, info)

  def all_events(_root, %{starting_date: starting_date}, _info) do
    events = HomeOffice.list_events(starting_date)

    {:ok, events}
  end
end
