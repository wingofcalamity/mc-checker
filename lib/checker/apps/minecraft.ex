defmodule Checker.Apps.Minecraft do
  alias Checker.Apps.Minecraft.VarString
  alias Checker.Apps.Minecraft.VarInt

  def check_mc(host, port) do
    case :gen_tcp.connect(
           String.to_charlist(host),
           port,
           [
             :binary,
             {:packet, 0},
             {:active, false}
           ],
           5_000
         ) do
      {:ok, sock} ->
        try do
          with :ok <- :gen_tcp.send(sock, handshake(host, port, 763)),
               :ok <- :gen_tcp.send(sock, <<1::8, 0::8>>),
               {:ok, data} <- :gen_tcp.recv(sock, 0, 5_000),
               {_len, rest} <- VarInt.decode(data),
               {_packet_id, status} <- VarInt.decode(rest),
               {result, _rest} <- VarString.decode(status) do
            {:ok, result}
          end
        after
          :gen_tcp.close(sock)
        end

      {:error, :timeout} ->
        {:error, :timeout}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp handshake(host, port, protocol) do
    body = <<
      VarInt.encode(0)::binary,
      VarInt.encode(protocol)::binary,
      VarString.encode(host)::binary,
      port::unsigned-big-16,
      VarInt.encode(1)::binary
    >>

    <<VarInt.encode(byte_size(body))::binary, body::binary>>
  end
end
