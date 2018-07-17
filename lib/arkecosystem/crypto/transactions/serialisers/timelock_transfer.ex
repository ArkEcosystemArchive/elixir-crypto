defmodule ArkEcosystem.Crypto.Transactions.Serializers.TimelockTransfer do
  alias ArkEcosystem.Crypto.Helpers.Base58Check

  def serialize(bytes, transaction) do
    amount = <<transaction.amount::little-unsigned-integer-size(64)>>
    timelocktype = <<transaction.timelocktype::little-unsigned-integer-size(8)>>
    timelock = <<transaction.timelock::little-unsigned-integer-size(32)>>

    recipient_id =
      transaction.recipient_id
      |> Base58Check.decode58check()

    bytes <> amount <> timelocktype <> timelock <> recipient_id
  end
end
