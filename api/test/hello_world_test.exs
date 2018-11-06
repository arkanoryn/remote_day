defmodule HelloWorldTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Faker is properly loaded" do
    name = Faker.Name.name()

    assert name == name
  end
end
