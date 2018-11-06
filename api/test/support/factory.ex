defmodule RemoteDay.Factory do
  use ExMachina.Ecto, repo: RemoteDay.Repo

  def test_factory do
    %{
      name: "Jane Doe"
    }
  end
end
