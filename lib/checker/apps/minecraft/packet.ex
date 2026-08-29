defmodule Checker.Apps.Minecraft.Packet do
  alias Checker.Apps.Minecraft.VarInt
  alias Checker.Apps.Minecraft.VarString

  def encode_handshake(host, port, protocol) do
    body = <<
      VarInt.encode(0)::binary,
      VarInt.encode(protocol)::binary,
      VarString.encode(host)::binary,
      port::unsigned-big-16,
      VarInt.encode(1)::binary
    >>

    <<VarInt.encode(byte_size(body))::binary, body::binary>>
  end

  def decode_frame(binary) do
    {len, rest} = VarInt.decode(binary)
    decode_frame(rest, len)
  end

  defp decode_frame(binary, len) when byte_size(binary) >= len do
    <<frame::binary-size(len), rest::binary>> = binary
    {:ok, frame, rest}
  end

  defp decode_frame(_binary, _len), do: :incomplete

  def decode_status(binary) do
    {0, data} = VarInt.decode(binary)
    {result, _rest} = VarString.decode(data)
    {:ok, result}
  end
end
