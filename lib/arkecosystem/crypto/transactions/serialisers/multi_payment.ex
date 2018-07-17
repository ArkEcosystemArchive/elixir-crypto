defmodule ArkEcosystem.Crypto.Transactions.Serializers.MultiPayment do
  alias ArkEcosystem.Crypto.Helpers.Base58Check

  def serialize(bytes, transaction) do
    payments_count = length(transaction.asset.payments)

    bytes <>
      <<payments_count::little-unsigned-integer-size(64)>> <>
      serialize_payments(transaction.asset.payments, bytes)
  end

  defp serialize_payments(payments, bytes) when length(payments) > 0 do
    {payment, payments} = List.pop_at(payments, 0)

    bytes =
      if not is_nil(payment) do
        <<payment.amount::little-unsigned-integer-size(64)>> <>
          (payment.recipient_id
           |> Base58Check.decode58check())
      else
        bytes
      end

    serialize_payments(payments, bytes)
  end

  defp serialize_payments(payments, bytes) when length(payments) == 0 do
    bytes
  end
end
