defmodule ArkEcosystem.Crypto.Transactions.MultiSignatureRegistration do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Crypto.Transactions.Transaction
  alias ArkEcosystem.Crypto.Transactions.Enums.{Fees, Types}

  @spec create(String.t(), String.t(), List.t(), Integer.t(), Integer.t()) :: Map.t()
  def create(secret, second_secret, keysgroup, lifetime, min) do
    key = EcKey.get_private_key(secret)

    transaction = %{
      :id => nil,
      :timestamp => Crypto.seconds_since_epoch(),
      :type => Types.multi_signature_registration(),
      :fee => (1 + length(keysgroup)) * Fees.multi_signature_registration(),
      :sender_public_key => EcKey.private_key_to_public_key(key),
      :signature => nil,
      :sign_signature => nil,
      :amount => 0,
      :asset => %{
        :multisignature => %{
          :min => min,
          :lifetime => lifetime,
          :keysgroup => keysgroup
        }
      }
    }

    Transaction.add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
