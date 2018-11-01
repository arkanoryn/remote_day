defmodule RemoteDayWeb.Resolvers.Tmp do
  def my_random(_parent, _args, _resolution), do: {:ok, %{random: "troll"}}
end
