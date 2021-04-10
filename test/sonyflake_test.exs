defmodule SonyflakeTest do
  @moduledoc """
  Tests for the Sonyflake module.
  """
  use ExUnit.Case
  doctest Sonyflake

  test "Generate single id" do
    start_time = DateTime.utc_now()
    setting = Sonyflake.Setting.new(start_time)
    sonyflake_initial = Sonyflake.new(setting)
    {:ok, sonyflake_later, id} = Sonyflake.next_id(sonyflake_initial)
    assert is_integer(id)
    parts = Sonyflake.decompose(id)
    assert parts[:msb] == 0
    assert parts[:sequence] == 0
  end
end
