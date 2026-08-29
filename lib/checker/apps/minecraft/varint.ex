defmodule Checker.Apps.Minecraft.VarInt do
  import Bitwise

  def encode(value) do
    {encoded, _} = encode(value, <<>>)
    encoded
  end

  defp encode(value, acc) when value < 128 do
    {<<acc::binary, value::8>>, []}
  end

  defp encode(value, acc) do
    chunk = value &&& 0x7F
    remaining = value >>> 7
    encode(remaining, <<acc::binary, 1::1, chunk::7 >>)
  end

  def decode(binary) do
    decode(binary, 0, 0)
  end
  defp decode(<<continue::1, value::7, rest::binary>>, acc, shift) when continue == 1 do
    new_acc = acc + (value <<< (shift * 7))
    decode(rest, new_acc, shift + 1)
  end
  defp decode(<<continue::1, value::7, rest::binary>>, acc, shift) when continue == 0 do
    new_acc = acc + (value <<< (shift * 7))
    {new_acc, rest}
  end
end
