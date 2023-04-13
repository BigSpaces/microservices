defmodule TweetServiceTest do
  use ExUnit.Case
  doctest TweetService

  test "greets the world" do
    assert TweetService.hello() == :world
  end
end
