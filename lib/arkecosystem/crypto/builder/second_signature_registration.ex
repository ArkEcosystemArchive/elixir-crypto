defmodule ArkEcosystem.Crypto.Builder.SecondSignatureRegistration do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Crypto.Builder.Transaction
  alias ArkEcosystem.Crypto.Enums.{Fees, Types}

  @spec create(String.t(), String.t()) :: Map.t()
  def create(second_secret, first_secret) do
    transaction = %{
      id: nil,
      timestamp: Crypto.seconds_since_epoch(),
      type: Types.second_signature_registration(),
      fee: Fees.second_signature_registration(),
      sender_public_key: EcKey.secret_to_public_key(first_secret),
      signature: nil,
      sign_signature: nil,
      amount: 0,
      asset: %{
        signature: %{
          public_key: EcKey.secret_to_public_key(second_secret)
        }
      }
    }

    Transaction.add_signatures_and_create_id(transaction, first_secret)
  end
end
