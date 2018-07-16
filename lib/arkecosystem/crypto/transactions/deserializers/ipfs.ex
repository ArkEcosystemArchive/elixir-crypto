defmodule ArkEcosystem.Crypto.Transactions.Deserializers.IPFS do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)
    <<
      _           :: binary-size(offset),
      dag_length  :: little-unsigned-integer-size(8),
      _           :: binary
    >> = bytes

    dag_length = dag_length * 2
    asset_offset = asset_offset + 2
    <<
      _           :: binary-size(asset_offset),
      dag         :: binary-size(dag_length),
      _           :: binary
    >> = serialized

    transaction = Kernel.put_in(transaction, [:asset, :dag], dag)

    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

end
