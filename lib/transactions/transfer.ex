defmodule ArkCrypto.Transactions.Transfer do
  alias ArkCrypto.Crypto
  alias ArkCrypto.Utils.EcKey
  alias ArkCrypto.Transactions.Transaction
  alias ArkCrypto.Transactions.Enums.{Fees, Types}

  @spec create(String.t(), Integer.t(), String.t(), String.t(), String.t()) :: Map.t()
  def create(recipient_id, amount, vendor_field, secret, second_secret \\ nil) do
    key = EcKey.get_private_key(secret)

    transaction = %{
      id: nil,
      timestamp: Crypto.seconds_since_epoch(),
      type: Types.transfer(),
      fee: Fees.transfer(),
      sender_public_key: EcKey.private_key_to_public_key(key),
      signature: nil,
      sign_signature: nil,
      amount: amount,
      recipient_id: recipient_id,
      vendor_field: vendor_field
    }

    Transaction.add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
