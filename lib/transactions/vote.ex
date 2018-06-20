defmodule ArkCrypto.Transactions.Vote do
  alias ArkCrypto.Crypto
  alias ArkCrypto.Utils.EcKey
  alias ArkCrypto.Transactions.Transaction
  alias ArkCrypto.Transactions.Enums.{Fees, Types}

  @spec create(Array.t(), String.t(), String.t(), String.t()) :: Map.t()
  def create(votes, secret, second_secret, network_address \\ nil) do
    network_address = network_address || <<0x17>>
    key = EcKey.get_private_key(secret)

    transaction = %{
      id: nil,
      timestamp: Crypto.seconds_since_epoch(),
      type: Types.vote(),
      fee: Fees.vote(),
      sender_public_key: EcKey.private_key_to_public_key(key),
      signature: nil,
      sign_signature: nil,
      recipient_id: EcKey.private_key_to_address(key, network_address),
      amount: 0,
      asset: %{votes: votes}
    }

    Transaction.add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
