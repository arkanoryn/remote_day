defmodule RemoteDay.Factory.Account.User do
  @moduledoc """
  Account.User Factory
  """

  alias Faker.Internet
  alias Faker.StarWars
  alias RemoteDay.Account.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        pwd = random_pwd(15)

        %User{
          email: Internet.email(),
          password: pwd,
          password_confirmation: pwd,
          username: StarWars.character()
        }
      end

      def random_pwd(size) do
        size
        |> :crypto.strong_rand_bytes()
        |> Base.url_encode64(padding: false)
      end

      def random_pwd(user, size) do
        pwd =
          size
          |> :crypto.strong_rand_bytes()
          |> Base.url_encode64(padding: false)

        %{user | password: pwd, password_confirmation: pwd}
      end
    end
  end
end
