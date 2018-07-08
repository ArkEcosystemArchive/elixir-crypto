defmodule ArkEcosystem.Crypto.Builder.Transfer do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Crypto.Builder.Transaction
  alias ArkEcosystem.Crypto.Enums.{Fees, Types}

  @spec create(String.t(), Integer.t(), String.t(), String.t(), String.t()) :: Map.t()
  def create(recipient_id, amount, vendor_field, secret, second_secret \\ nil) do
    transaction = %{
      id: nil,
      timestamp: Crypto.seconds_since_epoch(),
      type: Types.transfer(),
      fee: Fees.transfer(),
      sender_public_key: EcKey.secret_to_public_key(secret),
      signature: nil,
      sign_signature: nil,
      amount: amount,
      recipient_id: recipient_id,
      vendor_field: vendor_field
    }

    Transaction.add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
