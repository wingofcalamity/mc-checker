defmodule Checker.Apps.Minecraft.VarString do
  alias Checker.Apps.Minecraft.VarInt

  def encode(string) do
    <<VarInt.encode(byte_size(string))::binary, string::binary>>
  end

  def decode(binary) do
    {length, rest} = VarInt.decode(binary)

    if byte_size(rest) < length do
      {:error, :incomplete}
    else
      <<string::binary-size(length), remaining::binary>> = rest
      {string, remaining}
    end
  end
end
