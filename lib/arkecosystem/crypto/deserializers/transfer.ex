defmodule ArkEcosystem.Crypto.Deserializers.Transfer do
  alias ArkEcosystem.Crypto.Crypto

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)
    <<
      _             :: binary-size(offset),
      amount        :: little-unsigned-integer-size(64),
      expiration    :: little-unsigned-integer-size(32),
      recipient_id  :: binary-size(21),
      _             :: binary
    >> = bytes

    recipient_id = recipient_id
      |> Crypto.encode58

    transaction = Map.put(transaction, :amount, amount)
    transaction = Map.put(transaction, :expiration, expiration)
    transaction = Map.put(transaction, :recipient_id, recipient_id)

    asset_offset = asset_offset + ((21 + 12) * 2)

    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

end
