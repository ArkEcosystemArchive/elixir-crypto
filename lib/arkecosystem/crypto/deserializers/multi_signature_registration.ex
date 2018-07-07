defmodule ArkEcosystem.Crypto.Deserializers.MultiSignatureRegistration do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)
    <<
      _                     :: binary-size(offset),
      min                   :: little-unsigned-integer-size(8),
      number_of_signatures  :: little-unsigned-integer-size(8),
      lifetime              :: little-unsigned-integer-size(8),
      rest                  :: binary
    >> = bytes

    keysgroup = deserialize_keysgroup(0, number_of_signatures, rest, [])

    multi_signature = %{
      :min => min,
      :lifetime => lifetime,
      :keysgroup => keysgroup
    }

    transaction = Kernel.put_in(transaction, [:asset, :multisignature], multi_signature)
    asset_offset = asset_offset + 6 + (number_of_signatures * 66)

    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

  defp deserialize_keysgroup(from, to, bytes, keysgroup) when from < to do
    <<
      address     :: binary-size(33),
      rest        :: binary
    >> = bytes

    public_key = address
      |> Base.encode16(case: :lower)

    keysgroup = keysgroup ++ [public_key]
    from = from + 1

    deserialize_keysgroup(from, to, rest, keysgroup)
  end

  defp deserialize_keysgroup(from, to, bytes, keysgroup) when from == to do
    keysgroup
  end

end
