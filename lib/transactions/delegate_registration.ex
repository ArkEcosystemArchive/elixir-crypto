defmodule ArkCrypto.Transactions.DelegateRegistration do
  @type 2
  @fee Application.get_env(:ark_crypto, :transactions)[:delegate_fee]

  @spec username(String.t()) :: Map.t()
  def username(username) do
    #
  end

  @spec create(String.t(), String.t()) :: Map.t()
  def create(secret, second_secret \\ nil) do
    key = EcKey.get_private_key(secret)
    public_key = EcKey.private_key_to_public_key(key)

    transaction = %{
      amount: 0,
      asset: %{
        delegate: %{
          public_key: public_key,
          username: username
        }
      },
      fee: @fee,
      id: nil,
      sender_public_key: public_key,
      sign_signature: nil,
      signature: nil,
      timestamp: __MODULE__.seconds_since_epoch,
      type: @type,
    }

    add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
