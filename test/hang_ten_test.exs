defmodule HangTenTest do
  use ExUnit.Case
  doctest HangTen

  test "greets the world" do
    assert HangTen.hello() == :world
  end
end
