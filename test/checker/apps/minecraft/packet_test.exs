defmodule Checker.Apps.Minecraft.PacketTest do
  alias Checker.Apps.Minecraft.Packet
  use ExUnit.Case

  describe "decode_frame/1" do
    test "Decodes packet" do
      assert Packet.decode_frame(<<0x1, 0xAC>>) == {:ok, <<0xAC>>, <<>>}
    end

    test "Decodes packet with rest" do
      assert Packet.decode_frame(<<0x1, 0xAC, 0x50>>) == {:ok, <<0xAC>>, <<0x50>>}
    end

    test "Decodes short packet" do
      assert Packet.decode_frame(<<0x02, 0xAC>>) == :incomplete
    end
  end
end
