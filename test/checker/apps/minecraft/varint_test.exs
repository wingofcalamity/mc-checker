defmodule VarIntTest do
  use ExUnit.Case
  alias Checker.Apps.Minecraft.VarInt

  describe "encode/1" do
    test "encodes single-byte values" do
      assert VarInt.encode(0) == <<0x00>>
      assert VarInt.encode(1) == <<0x01>>
      assert VarInt.encode(127) == <<0x7F>>
    end

    test "encodes values requiring multiple bytes" do
      assert VarInt.encode(128) == <<0x80, 0x01>>
      assert VarInt.encode(255) == <<0xFF, 0x01>>
      assert VarInt.encode(300) == <<0xAC, 0x02>>
    end

    test "encodes negative values" do
      assert VarInt.encode(-1) == <<0xFF, 0xFF, 0xFF, 0xFF, 0x0F>>
      assert VarInt.encode(-2_147_483_648) == <<0x80, 0x80, 0x80, 0x80, 0x08>>
    end
  end

  describe "decode/1" do
    test "decodes single-byte values" do
      assert VarInt.decode(<<0x00>>) == {0, <<>>}
      assert VarInt.decode(<<0x01>>) == {1, <<>>}
      assert VarInt.decode(<<0x7F>>) == {127, <<>>}
    end

    test "decodes multiple-byte values" do
      assert VarInt.decode(<<0x80, 0x01>>) == {128, <<>>}
      assert VarInt.decode(<<0xFF, 0x01>>) == {255, <<>>}
      assert VarInt.decode(<<0xAC, 0x02>>) == {300, <<>>}
    end

    test "decodes negative value" do
      assert VarInt.decode(<<0xFF, 0xFF, 0xFF, 0xFF, 0x0F>>) == {-1, <<>>}
      assert VarInt.decode(<<0x80, 0x80, 0x80, 0x80, 0x08>>) == {-2_147_483_648, <<>>}
    end

    test "leaves bytes after the VarInt untouched" do
      assert VarInt.decode(<<0xAC, 0x02, 0xFF, 0xFF>>) == {300, <<0xFF, 0xFF>>}
    end
  end
end
