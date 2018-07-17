defmodule ArkEcosystem.Crypto.Helpers.Der do
  def encode_sequence(r, s) do
    combined = encode_integer(r) <> encode_integer(s)
    <<0x30>> <> <<byte_length(combined)>> <> combined
  end

  # private

  defp encode_integer(integer) do
    h = integer |> Integer.to_string(16)

    s =
      case Integer.mod(String.length(h), 2) do
        0 -> elem(Base.decode16(h), 1)
        1 -> elem(Base.decode16("0" <> h), 1)
      end

    <<num, _::binary>> = s

    if num <= 0x7F do
      <<2, byte_length(s)>> <> s
    else
      <<2, byte_length(s) + 1, 0>> <> s
    end
  end

  defp byte_length(string) do
    div(bit_size(string), 8)
  end
end
