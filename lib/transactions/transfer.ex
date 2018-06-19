defmodule ArkCrypto.Transactions.Vote do
  @type 0
  @fee Application.get_env(:ark_crypto, :transactions)[:transfer_fee]

  @spec recipient_id(String.t()) :: Map.t()
  def recipient_id(recipient_id) do
    #
  end

  @spec amount(Integer.t()) :: Map.t()
  def amount(amount) do
    #
  end

  @spec vendor_field(String.t()) :: Map.t()
  def vendor_field(vendor_field) do
    #
  end

  @spec create(String.t(), String.t()) :: Map.t
  def create(secret, second_secret \\ nil) do
    key = ArkCrypto.EcKey.get_private_key(secret)

    transaction = %{
      amount: amount,
      fee: @fee,
      id: nil,
      recipient_id: recipient_id,
      sender_public_key: EcKey.private_key_to_public_key(key),
      sign_signature: nil,
      signature: nil,
      timestamp: __MODULE__.seconds_since_epoch,
      type: @type,
      vendor_field: vendor_field
    }

    add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
