defmodule HelloWorldTest do
  use ExUnit.Case
  import RemoteDay.Factory

  test "the truth" do
    assert 1 + 1 == 2
  end

  describe "Faker" do
    test "Faker is properly loaded" do
      name = Faker.Name.name()

      assert name == name
    end
  end

  describe "Factory" do
    test "Default test Factory" do
      assert build(:test) == %{name: "Jane Doe"}
    end

    test "Factory with provided attrs" do
      attrs = %{name: Faker.Name.name()}

      assert build(:test, attrs) == attrs
    end
  end
end
