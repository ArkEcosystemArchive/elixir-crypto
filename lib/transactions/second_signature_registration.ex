defmodule ArkCrypto.Transactions.SecondSignatureRegistration do
  @type 1
  @fee Application.get_env(:ark_crypto, :transactions)[:second_signature_fee]

  @spec second_secret(String.t()) :: Map.t()
  def second_secret(second_secret) do
    #
  end

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
      fee: @fee,
      id: nil,
      sender_public_key: EcKey.private_key_to_public_key(key),
      sign_signature: nil,
      signature: nil,
      timestamp: __MODULE__.seconds_since_epoch,
      type: @type
    }

    add_signatures_and_create_id(transaction, first_secret)
  end
end
