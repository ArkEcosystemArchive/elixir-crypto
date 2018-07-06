defmodule ArkEcosystem.Crypto.Builder.DelegateRegistration do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Crypto.Builder.Transaction
  alias ArkEcosystem.Crypto.Enums.{Fees, Types}

  @spec create(String.t(), String.t(), String.t()) :: Map.t()
  def create(username, secret, second_secret \\ nil) do
    public_key = EcKey.secret_to_public_key(secret)

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
