defmodule SonyflakeTest do
  @moduledoc """
  Tests for the Sonyflake module.
  """
  use ExUnit.Case
  doctest Sonyflake

  test "Generate single id" do
    sf1 = Sonyflake.new()
    {:ok, sf2, id} = Sonyflake.next_id(sf1)
    assert is_integer(id)
  end
end
