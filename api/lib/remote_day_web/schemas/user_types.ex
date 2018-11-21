defmodule RemoteDayWeb.Schema.Types.Users do
  @moduledoc """
  objects, queries and mutations related to the Users
  """
  use Absinthe.Schema.Notation

  alias RemoteDayWeb.Resolvers.Account

  object :user do
    field(:id, non_null(:id))
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
    field(:username, :string)
  end

  object :session do
    field(:token, :string)
  end

  object :user_session do
    field(:user, non_null(:user))
    field(:token, :string)
  end

  object :users_mutations do
    @desc "Create a user"
    field(:create_user, :user_session) do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))
      arg(:username, non_null(:string))

      resolve(&Account.create_user/3)
    end

    @desc "authenticate a user"
    field(:authenticate, :user_session) do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Account.authenticate/3)
    end
  end
end
