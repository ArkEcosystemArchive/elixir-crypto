# Taken from https://github.com/gjaldon/base58check, but uses :crypto instead of :erlsha2

defmodule ArkCrypto.Base58Check do
  @b58_characters '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

  def decode58(code) when is_binary(code) do
    code |> to_charlist |> decode58(0)
  end

  def decode58(_code) do
    raise(ArgumentError, "expects base58-encoded binary")
  end

  def decode58check(code) do
    decoded_bin = decode58(code) |> :binary.encode_unsigned()
    payload_size = byte_size(decoded_bin) - 4

    <<payload::binary-size(payload_size), checksum::binary-size(4)>> =
      decoded_bin

    if generate_checksum(payload) == checksum do
      payload
    else
      raise ArgumentError, "checksum doesn't match"
    end
  end

  def encode58(data) do
    encoded_zeroes = convert_leading_zeroes(data, [])
    integer = if is_binary(data), do: :binary.decode_unsigned(data), else: data
    encode58(integer, [], encoded_zeroes)
  end

  def encode58check(prefix, data) when is_binary(prefix) and is_binary(data) do
    data = case Base.decode16(String.upcase(data)) do
      {:ok, bin}  ->  bin
      :error      ->  data
    end
    versioned_data = prefix <> data
    checksum = generate_checksum(versioned_data)
    encode58(versioned_data <> checksum)
  end

  def encode58check(prefix, data) do
    prefix =
      if is_integer(prefix), do: :binary.encode_unsigned(prefix), else: prefix
    data = if is_integer(data), do: :binary.encode_unsigned(data), else: data
    encode58check(prefix, data)
  end

  # private

  defp convert_leading_zeroes(<<0>> <> data, encoded_zeroes) do
    encoded_zeroes = ['1'|encoded_zeroes]
    convert_leading_zeroes(data, encoded_zeroes)
  end

  defp convert_leading_zeroes(_data, encoded_zeroes) do
    encoded_zeroes
  end

  defp decode58([], acc) do
    acc
  end

  defp decode58([c|code], acc) do
    decode58(code, (acc * 58) + do_decode58(c))
  end

  for {encoding, value} <- Enum.with_index(@b58_characters) do
    defp do_encode58(unquote(value)), do: unquote(encoding)
    defp do_decode58(unquote(encoding)), do: unquote(value)
  end

  defp double_sha256(chars) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, chars))
  end

  defp encode58(0, acc, encoded_zeroes) do
    to_string([encoded_zeroes|acc])
  end

  defp encode58(integer, acc, encoded_zeroes) do
    encoded = do_encode58(rem(integer, 58))
    encode58(div(integer, 58), [encoded | acc], encoded_zeroes)
  end

  defp generate_checksum(versioned_data) do
    <<checksum::binary-size(4), _rest::binary-size(28)>> =
      versioned_data |> double_sha256
    checksum
  end
end
