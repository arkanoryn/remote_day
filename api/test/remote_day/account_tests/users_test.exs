defmodule RemoteDay.Tests.Account.UserTest do
  @moduledoc """
  Module describing the tests of the User from Account
  """
  use RemoteDay.DataCase

  import Comeonin.Bcrypt, only: [checkpw: 2]
  import RemoteDay.Factory

  alias RemoteDay.Account
  alias RemoteDay.Account.User

  describe "create_user/1" do
    test "with valid attrs" do
      attrs = params_for(:user)

      assert {:ok, %User{} = user} = Account.create_user(attrs)
      assert user.email == attrs.email
      assert user.username == attrs.username
      assert user.password_hash
      assert checkpw(attrs.password, user.password_hash)
    end

    test "with pwd too short" do
      attrs = params_for(:user) |> random_pwd(5)
      assert {:error, changeset} = Account.create_user(attrs)
      assert "should be at least 8 character(s)" in errors_on(changeset).password
    end

    test "with pwd too long" do
      attrs = params_for(:user) |> random_pwd(129)
      assert {:error, changeset} = Account.create_user(attrs)
      assert "should be at most 128 character(s)" in errors_on(changeset).password
    end

    test "pwd confirmation does not matches pwd" do
      attrs = params_for(:user)

      assert {:error, changeset} =
               Account.create_user(%{attrs | password_confirmation: "no match"})

      assert "does not match confirmation" in errors_on(changeset).password_confirmation
    end

    test "valid email" do
      attrs = params_for(:user)

      assert {:error, changeset} = Account.create_user(%{attrs | email: "no match"})

      assert "has invalid format" in errors_on(changeset).email
    end
  end

  describe "get_user!/1" do
    setup do
      user = insert(:user)

      [user: user]
    end

    test "with existing id", %{user: user} do
      fetched_user = Account.get_user!(user.id)

      assert fetched_user == %{user | password: nil, password_confirmation: nil}
    end
  end

  describe "get_user_by!" do
    setup do
      user = insert(:user)

      [user: user]
    end

    test "by email/1", %{user: user} do
      fetched_user = Account.get_user_by!(email: user.email)

      assert fetched_user == %{user | password: nil, password_confirmation: nil}
      assert Account.get_user_by!(email: user.email) == Account.get_user_by!(%{email: user.email})
    end
  end

  describe "login/1" do
    setup do
      {:ok, user} = params_for(:user) |> Account.create_user()

      [user: user]
    end

    test "authenticate user with good credentials", %{user: user} do
      %{email: email, password: pwd} = user

      assert {:ok, user, token} = Account.login(%{email: email, password: pwd})
      assert {:ok, user, token} = Account.login(email: email, password: pwd)
    end

    test "fails with bad pwd", %{user: user} do
      assert {:error, "invalid password"} =
               Account.login(%{email: user.email, password: "wrong password"})
    end

    test "fails with bad email" do
      assert {:error, :unauthorized} =
               Account.login(%{email: "user.email", password: "wrong password"})
    end
  end
end
