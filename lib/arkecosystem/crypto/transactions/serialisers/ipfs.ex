defmodule ArkEcosystem.Crypto.Transactions.Serializers.IPFS do

  def serialize(bytes, transaction) do
    dag = transaction.asset.ipfs.dag
    length = byte_size dag

    bytes
      <> << length::little-unsigned-integer-size(8) >>
      <> dag
  end

end
