defmodule RemoteDay.Factory do
  @moduledoc """
    Group of factories used through the tests.
    The Factories can be found under `~/test/factories` and added to this document by using the `use` function.
    For example: `use RemoteDay.User`

    It can then be call in the tests suit by adding `import RemoteDay.Factory`.
    Read [ex_machina readme](https://github.com/thoughtbot/ex_machina) for further details.
  """
  use ExMachina.Ecto, repo: RemoteDay.Repo

  def test_factory do
    %{
      name: "Jane Doe"
    }
  end
end
