defmodule ArkEcosystem.Crypto.Transactions.Serializers.DelegateRegistration do
  def serialize(bytes, transaction) do
    username = transaction.asset.delegate.username
    length = byte_size(username)

    bytes <> <<length::little-unsigned-integer-size(8)>> <> username
  end
end
