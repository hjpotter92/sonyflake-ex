defmodule Sonyflake.Setting do
  @moduledoc """
  Setting and configuration for creating Sonyflake instance.
  """

  @enforce_keys [:start_time, :machine_id]
  defstruct [:start_time, :machine_id]

  defp is_start_time_valid(time) do
    is_struct(time, DateTime) and time >= Sonyflake.Constants.sonyflake_epoch_raw()
  end

  defp get_start_time(time) do
    if is_start_time_valid(time),
      do: Sonyflake.Utils.to_sonyflake_time(time),
      else: nil
  end

  @spec new :: %Sonyflake.Setting{machine_id: non_neg_integer, start_time: non_neg_integer}
  @doc """
  Generate configuration for initialising a new Sonyflake generator instance.
  """
  def new() do
    %Sonyflake.Setting{
      start_time: Sonyflake.Constants.sonyflake_epoch(),
      machine_id: Sonyflake.Utils.lower_16_bit_private_ip()
    }
  end

  @spec new(DateTime.t()) ::
          nil | %Sonyflake.Setting{machine_id: non_neg_integer, start_time: non_neg_integer}
  @doc """
  Generate configuration for initialising a new Sonyflake generator instance.

  The `start_time` is used as initial seed for sequence.
  """
  def new(start_time) do
    start_time = get_start_time(start_time)

    if is_nil(start_time) do
      nil
    else
      %Sonyflake.Setting{
        start_time: start_time,
        machine_id: Sonyflake.Utils.lower_16_bit_private_ip()
      }
    end
  end

  @spec new(DateTime.t(), (() -> non_neg_integer), (non_neg_integer -> boolean)) ::
          nil | %Sonyflake.Setting{machine_id: non_neg_integer, start_time: non_neg_integer}
  @doc """
  Generate configuration for initialising a new Sonyflake generator instance.

  The `start_time` is used as initial seed for sequence.  `machine_id`
  is used to generate a `non_neg_integer` identifier for machine,
  which is then further validated with the `check_machine_id` call.
  """
  def new(start_time, machine_id, check_machine_id) do
    id = machine_id.()
    valid_id = check_machine_id.(id)
    start_time = get_start_time(start_time)

    if is_nil(start_time) or not valid_id do
      nil
    else
      %Sonyflake.Setting{
        start_time: start_time,
        machine_id: id
      }
    end
  end
end
