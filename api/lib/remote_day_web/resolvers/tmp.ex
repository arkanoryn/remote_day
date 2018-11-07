defmodule RemoteDayWeb.Resolvers.Tmp do
  @moduledoc false

  def my_random(_parent, _args, _resolution), do: {:ok, %{random: "troll"}}
end
