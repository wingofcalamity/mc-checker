defmodule Checker.Apps.Minecraft do
  alias Checker.Apps.Minecraft.Packet

  def check_mc(host, port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}]

    with {:ok, sock} <- :gen_tcp.connect(String.to_charlist(host), port, tcp_options, 5_000) do
      handshake(sock, host, port)
    end
  end

  defp handshake(sock, host, port) do
    try do
      with :ok <- :gen_tcp.send(sock, Packet.encode_handshake(host, port, 763)),
           :ok <- :gen_tcp.send(sock, <<1::8, 0::8>>),
           {:ok, frame, _rest} <- recv_frame(sock, <<>>),
           {:ok, result} <- Packet.decode_status(frame) do
        {:ok, result}
      end
    after
      :gen_tcp.close(sock)
    end
  end

  defp recv_frame(sock, acc) do
    {:ok, data} = :gen_tcp.recv(sock, 0)
    acc = <<acc::binary, data::binary>>

    case Packet.decode_frame(acc) do
      {:ok, data, rest} ->
        {:ok, data, rest}

      :incomplete ->
        recv_frame(sock, acc)
    end
  end
end
