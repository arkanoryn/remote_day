defmodule RemoteWebDay.Resolvers.Account.AuthenticationTest do
  @moduledoc """
  describes tests regarding user authentication
  """
  use RemoteDayWeb.ConnCase

  import RemoteDay.Factory
  import RemoteDayWeb.GraphQLHelper

  alias RemoteDay.Account

  @operation_type :mutation
  @operation_name "authenticate"
  @args [
    {:email, "String!"},
    {:password, "String!"}
  ]

  setup do
    {:ok, user} = params_for(:user) |> Account.create_user()

    [user: user]
  end

  describe "authenticate/3" do
    test "returns the user and a token when email & pwd are valid", %{conn: conn, user: user} do
      attrs = %{email: user.email, password: user.password}

      authenticate_user_mutation =
        build_query(@operation_type, @operation_name, @args, [
          {"user", ~w(id email username)},
          "token"
        ])

      response =
        conn
        |> graphql_query(query: authenticate_user_mutation, variables: attrs)
        |> json_response(200)
        |> parse_response(@operation_name)

      res_user = response["user"]
      assert res_user["id"]
      assert res_user["username"] == user.username
      assert res_user["email"] == user.email
      assert res_user["id"] == Integer.to_string(user.id)
      assert response["token"]
    end

    test "returns an error when email & pwd are valid", %{conn: conn, user: user} do
      attrs = %{email: user.email, password: "wrong password"}

      authenticate_user_mutation =
        build_query(@operation_type, @operation_name, @args, [
          {"user", ~w(id email username)},
          "token"
        ])

      response =
        conn
        |> graphql_query(query: authenticate_user_mutation, variables: attrs)
        |> json_response(200)
        |> parse_errors()

      assert List.first(response)["message"] == "invalid credentials"
    end
  end
end
