defmodule Sonyflake.Utils do
  @moduledoc """
  Utility functions for the package.
  """
  use Bitwise

  defp is_private_ipv4(ip) do
    case ip do
      {10, _x, _y, _z} ->
        true

      {192, 168, _x, _y} ->
        true

      {172, 16, _x, _y} ->
        true

      {172, 32, _x, _y} ->
        true

      _ ->
        false
    end
  end

  defp private_ipv4() do
    {:ok, addrs} = :inet.getif()

    filtered =
      Enum.filter(
        addrs,
        fn address ->
          ip = elem(address, 0)
          is_private_ipv4(ip)
        end
      )

    elem(hd(filtered), 0)
  end

  @spec lower_16_bit_private_ip() :: non_neg_integer
  @doc """
  Fetches first non-local public IPv4 address, and returns
  the lower 16-bit value.
  """
  def lower_16_bit_private_ip() do
    {_, _, b3, b4} = private_ipv4()
    (b3 <<< 8) + b4
  end

  @spec to_sonyflake_time(DateTime.t()) :: non_neg_integer
  @doc """
  Converts any given `DateTime` value to a 10-microsecond accuracy integer value.
  """
  def to_sonyflake_time(datetime) do
    (DateTime.to_unix(datetime, :nanosecond) / Sonyflake.Constants.sonyflake_time_unit())
    |> trunc()
  end
end
