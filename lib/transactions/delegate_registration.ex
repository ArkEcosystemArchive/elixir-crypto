defmodule ArkCrypto.Transactions.DelegateRegistration do
  alias ArkCrypto.Crypto
  alias ArkCrypto.Utils.EcKey
  alias ArkCrypto.Transactions.Transaction
  alias ArkCrypto.Transactions.Enums.{Fees, Types}

  @spec create(String.t(), String.t(), String.t()) :: Map.t()
  def create(username, secret, second_secret \\ nil) do
    key = EcKey.get_private_key(secret)
    public_key = EcKey.private_key_to_public_key(key)

    transaction = %{
      id: nil,
      timestamp: Crypto.seconds_since_epoch(),
      type: Types.delegate_registration(),
      fee: Fees.delegate_registration(),
      sender_public_key: public_key,
      signature: nil,
      sign_signature: nil,
      amount: 0,
      asset: %{
        delegate: %{
          public_key: public_key,
          username: username
        }
      }
    }

    Transaction.add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
