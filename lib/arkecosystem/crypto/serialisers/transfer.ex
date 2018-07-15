defmodule ArkEcosystem.Crypto.Serializers.Transfer do
  alias ArkEcosystem.Crypto.Utils.Base58Check

  def serialize(bytes, transaction) do

    amount = << transaction.amount::little-unsigned-integer-size(64) >>
    expiration = if Map.has_key?(transaction, :expiration) do
      << transaction.expiration::little-unsigned-integer-size(32) >>
    else
      << 0::little-unsigned-integer-size(32) >>
    end

    recipient_id = transaction.recipient_id
      |> Base58Check.decode58check

    bytes
      <> amount
      <> expiration
      <> recipient_id
  end

end
