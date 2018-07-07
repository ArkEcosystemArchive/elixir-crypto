defmodule ArkEcosystem.Crypto.Deserializers.MultiPayment do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)
    <<
      _               :: binary-size(offset),
      total           :: little-unsigned-integer-size(16),
      payments_binary :: binary
    >> = bytes

    payments = deserialize_payments(0, total, bytes, [])
    amount = Enum.reduce(payments, 0, fn(payment, acc) -> payment.amount + acc end)

    transaction = Kernel.put_in(transaction, [:asset, :payments], payments)
      |> Map.put(:amount, amount)

    asset_offset = asset_offset + 2 + (total * 29)

    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

  defp deserialize_payments(from, to, bytes, payments) when from < to do
    <<
      amount    :: little-unsigned-integer-size(64),
      address   :: binary-size(21),
      rest      :: binary
    >> = bytes

    recipient_id = address
      |> Base58Check.encode58check(<<>>)

    payment = %{
      :amount => amount,
      :recipient_id => recipient_id
    }

    payments = payments ++ [payment]
    from = from + 1

    deserialize_payments(from, to, rest, payments)
  end

  defp deserialize_payments(from, to, bytes, payments) when from == to do
    payments
  end

end
