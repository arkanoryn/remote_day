defmodule RemoteWebDay.Resolvers.Account.User.UsersTest do
  @moduledoc """
  Module describes the tests regarding the creation of Users through the Account Resolver
  """

  use RemoteDayWeb.ConnCase

  import RemoteDay.Factory
  import RemoteDayWeb.GraphQLHelper

  @operation_type :mutation
  @operation_name "createUser"
  @args [
    {:email, "String!"},
    {:username, "String!"},
    {:password, "String!"},
    {:passwordConfirmation, "String!"}
  ]

  describe "create_user/3" do
    test "it creates a new user", %{conn: conn} do
      attrs = user_params()

      create_user_mutation =
        build_query(@operation_type, @operation_name, @args, [
          {"user", ~w(id email username)}
        ])

      response =
        conn
        |> graphql_query(query: create_user_mutation, variables: attrs)
        |> json_response(200)
        |> parse_response(@operation_name)

      user = response["user"]

      assert user["id"]
      assert user["username"] == attrs.username
      assert user["email"] == attrs.email
    end

    test "creating a user returns a token", %{conn: conn} do
      attrs = user_params()

      create_user_mutation = build_query(@operation_type, @operation_name, @args, ~w(token))

      response =
        conn
        |> graphql_query(query: create_user_mutation, variables: attrs)
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response["token"]
    end

    test "creating an already existing users fails", %{conn: conn} do
      user = insert(:user)
      attrs = user_params(%{email: user.email})

      create_user_mutation = build_query(@operation_type, @operation_name, @args, ~w(token))

      response =
        conn
        |> graphql_query(query: create_user_mutation, variables: attrs)
        |> json_response(200)
        |> parse_errors()

      assert List.first(response)["message"] == "email has already been taken"
    end

    defp user_params(opts \\ %{}) do
      attrs = params_for(:user, opts)
      Map.put(attrs, :passwordConfirmation, attrs.password_confirmation)
    end
  end
end
