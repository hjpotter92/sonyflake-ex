defmodule Sonyflake do
  @moduledoc """
  Documentation for `Sonyflake`.
  """
  import Bitwise

  @enforce_keys [:machine_id, :start_time, :sequence]
  defstruct [:machine_id, :start_time, elapsed_time: 0, msb: 0, sequence: 0]

  @spec new :: %Sonyflake{
          elapsed_time: 0,
          machine_id: non_neg_integer,
          msb: 0,
          sequence: 255,
          start_time: non_neg_integer
        }
  @doc """
  Create an instance of `Sonyflake` unique ID generator.
  """
  def new() do
    setting = Sonyflake.Setting.new()

    %Sonyflake{
      sequence: (1 <<< Sonyflake.Constants.bit_len_sequence()) - 1,
      machine_id: setting.machine_id,
      start_time: setting.start_time
    }
  end

  @spec new(%Sonyflake.Setting{
          start_time: non_neg_integer,
          machine_id: non_neg_integer
        }) ::
          nil
          | %Sonyflake{
              elapsed_time: 0,
              machine_id: non_neg_integer,
              msb: 0,
              sequence: 255,
              start_time: non_neg_integer
            }
  @doc """
  Create an instance of `Sonyflake` unique ID generator, using a predetermined
  setting.
  """
  def new(setting) do
    if is_nil(setting),
      do: nil,
      else: %Sonyflake{
        sequence: (1 <<< Sonyflake.Constants.bit_len_sequence()) - 1,
        machine_id: setting.machine_id,
        start_time: setting.start_time
      }
  end

  @spec current_elapsed_time(%Sonyflake{start_time: non_neg_integer}) :: non_neg_integer
  @doc """
  Get time elapsed since the SonyFlake ID generator was initialised.
  """
  def current_elapsed_time(%Sonyflake{start_time: start_time}) do
    (Sonyflake.Utils.to_sonyflake_time(DateTime.utc_now()) - start_time) |> trunc()
  end

  @spec next_id(%Sonyflake{
          elapsed_time: non_neg_integer,
          machine_id: non_neg_integer,
          msb: non_neg_integer,
          sequence: non_neg_integer,
          start_time: non_neg_integer
        }) ::
          {:ok,
           %Sonyflake{
             elapsed_time: non_neg_integer,
             machine_id: non_neg_integer,
             msb: non_neg_integer,
             sequence: non_neg_integer,
             start_time: non_neg_integer
           }, non_neg_integer}
  @doc """
  Generates and returns the next unique ID.

  Raises a `TimeoutError` after the `SonyFlake` time overflows.
  """
  def next_id(sonyflake) do
    mask_sequence = (1 <<< Sonyflake.Constants.bit_len_sequence()) - 1
    current_time = current_elapsed_time(sonyflake)

    sonyflake =
      if sonyflake.elapsed_time < current_time do
        %Sonyflake{sonyflake | elapsed_time: current_time, sequence: 0}
      else
        sequence = sonyflake.sequence + 1 &&& mask_sequence

        temp =
          if sequence == 0,
            do:
              (
                new_elapsed_time = sonyflake.elapsed_time + 1
                overtime = new_elapsed_time - current_time
                Process.sleep(overtime)
                %Sonyflake{sonyflake | sequence: sequence, elapsed_time: new_elapsed_time}
              )

        temp
      end

    {:ok, sonyflake, to_id(sonyflake)}
  end

  defp to_id(%Sonyflake{elapsed_time: elapsed_time, sequence: sequence, machine_id: machine_id}) do
    time =
      elapsed_time <<<
        (Sonyflake.Constants.bit_len_sequence() + Sonyflake.Constants.bit_len_machine_id())

    sequence = sequence <<< Sonyflake.Constants.bit_len_machine_id()
    time ||| sequence ||| machine_id
  end

  @spec decompose(non_neg_integer) :: [
          {:id, non_neg_integer}
          | {:machine_id, non_neg_integer}
          | {:msb, non_neg_integer}
          | {:sequence, non_neg_integer}
          | {:time, non_neg_integer},
          ...
        ]
  @doc """
  Decompose a generated sonyflake id back to its components.
  """
  def decompose(id) when is_number(id) do
    mask_sequence =
      ((1 <<< Sonyflake.Constants.bit_len_sequence()) - 1) <<<
        Sonyflake.Constants.bit_len_machine_id()

    mask_machine_id = (1 <<< Sonyflake.Constants.bit_len_machine_id()) - 1
    msb = id >>> 63

    time =
      id >>> (Sonyflake.Constants.bit_len_sequence() + Sonyflake.Constants.bit_len_machine_id())

    sequence = (id &&& mask_sequence) >>> Sonyflake.Constants.bit_len_machine_id()
    machine_id = id &&& mask_machine_id
    [id: id, msb: msb, time: time, sequence: sequence, machine_id: machine_id]
  end
end
