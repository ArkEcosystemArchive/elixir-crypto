defmodule ArkEcosystem.Crypto.Deserializers.TimelockTransfer do
  alias ArkEcosystem.Crypto.Crypto

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)

    <<
      _             :: binary-size(offset),
      amount        :: little-unsigned-integer-size(64),
      timelock_type :: little-unsigned-integer-size(8),
      timelock      :: little-unsigned-integer-size(32),
      recipient_id  :: binary-size(21),
      _             :: binary
    >> = bytes

    recipient_id = Crypto.encode58(recipient_id)

    transaction = transaction
      |> Map.put(:amount, amount)
      |> Map.put(:timelock_type, timelock_type)
      |> Map.put(:timelock, timelock)
      |> Map.put(:recipient_id, recipient_id)

    asset_offset = asset_offset + (21 + 13) * 2
    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

end
