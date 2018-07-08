defmodule ArkEcosystem.Crypto.Serializers.TimelockTransfer do
  alias ArkEcosystem.Crypto.Utils.Base58Check

  def serialize(bytes, transaction) do

    amount = << transaction.amount::little-unsigned-integer-size(64) >>
    timelocktype = << transaction.timelocktype::little-unsigned-integer-size(8) >>
    timelock = << transaction.timelock::little-unsigned-integer-size(32) >>

    recipient_id = transaction.recipientId
      |> Base58Check.decode58check

    bytes
      <> amount
      <> timelocktype
      <> timelock
      <> recipient_id
  end

end
