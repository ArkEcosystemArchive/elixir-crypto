defmodule ArkCrypto.Transactions.SecondSignatureRegistration do
  alias ArkCrypto.Crypto
  alias ArkCrypto.Utils.EcKey
  alias ArkCrypto.Transactions.Transaction
  alias ArkCrypto.Transactions.Enums.{Fees, Types}

  @spec create(String.t(), String.t()) :: Map.t()
  def create(second_secret, first_secret) do
    key = EcKey.get_private_key(first_secret)
    second_key = EcKey.get_private_key(second_secret)

    transaction = %{
      amount: 0,
      asset: %{
        signature: %{
          public_key: EcKey.private_key_to_public_key(second_key)
        }
      },
      fee: Types.second_signature_registration(),
      id: nil,
      sender_public_key: EcKey.private_key_to_public_key(key),
      sign_signature: nil,
      signature: nil,
      timestamp: Crypto.seconds_since_epoch,
      type: Types.second_signature_registration()
    }

    Transaction.add_signatures_and_create_id(transaction, first_secret)
  end
end
