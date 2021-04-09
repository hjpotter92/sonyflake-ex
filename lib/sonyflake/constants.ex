defmodule Sonyflake.Constants do
  @moduledoc """
  Constants for usage across project.
  """

  @bit_len_time 39
  @bit_len_sequence 8
  @bit_len_machine_id 63 - (@bit_len_sequence + @bit_len_time)
  @sonyflake_time_unit 1.0e7
  @sonyflake_epoch DateTime.from_iso8601("2014-09-01T00:00:00Z")

  @spec bit_len_sequence :: 8
  def bit_len_sequence() do
    @bit_len_sequence
  end

  @spec bit_len_machine_id :: 16
  def bit_len_machine_id() do
    @bit_len_machine_id
  end

  def bit_len_time() do
    @bit_len_time
  end

  @spec sonyflake_epoch :: non_neg_integer()
  def sonyflake_epoch() do
    {:ok, time, _} = @sonyflake_epoch
    Sonyflake.Utils.to_sonyflake_time(time)
  end

  @spec sonyflake_epoch :: DateTime.t()
  def sonyflake_epoch_raw() do
    {:ok, time, _} = @sonyflake_epoch
    time
  end

  @spec sonyflake_time_unit :: float
  def sonyflake_time_unit() do
    @sonyflake_time_unit
  end
end
