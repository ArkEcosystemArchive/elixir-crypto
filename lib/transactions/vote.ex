defmodule ArkCrypto.Transactions.Vote do
  @type 3
  @fee Application.get_env(:ark_crypto, :transactions)[:vote_fee]

  @spec votes(Array.t()) :: Map.t()
  def votes(votes) do
    #
  end

  @spec create(String.t(), String.t(), String.t()) :: Map.t()
  def create(secret, second_secret, network_address \\ nil) do
    network_address = network_address || <<0x17>>
    key = EcKey.get_private_key(secret)

    transaction = %{
      amount: 0,
      asset: %{ votes: votes },
      fee: @fee,
      id: nil,
      recipient_id: EcKey.private_key_to_address(key, network_address),
      sender_public_key: EcKey.private_key_to_public_key(key),
      sign_signature: nil,
      signature: nil,
      timestamp: __MODULE__.seconds_since_epoch,
      type: @type
    }

    add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
