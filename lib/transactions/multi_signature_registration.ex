defmodule ArkCrypto.Transactions.MultiSignatureRegistration do
  @type 4
  @fee Application.get_env(:ark_crypto, :transactions)[:multisignature_base_fee]

  @spec keysgroup(List.t()) :: Map.t()
  def keysgroup(keysgroup) do
    #
  end

  @spec lifetime(Integer.t()) :: Map.t()
  def lifetime(lifetime) do
    #
  end

  @spec min(Integer.t()) :: Map.t()
  def min(min) do
    #
  end

  @spec create(String.t(), String.t()) :: Map.t()
  def create(secret, second_secret) do
    key = EcKey.get_private_key(secret)

    transaction = %{
      :type => @type,
      :fee => (1 + length(keysgroup)) * @fee,
      :sender_public_key => EcKey.private_key_to_public_key(key),
      :asset => %{
        :multisignature => %{
          :min => min,
          :lifetime => lifetime,
          :keysgroup => keysgroup
        }
      },
      :amount => 0,
      :timestamp => __MODULE__.seconds_since_epoch,
      :signature => nil,
      :sign_signature => nil,
      :id => nil
    }

    add_signatures_and_create_id(transaction, secret, second_secret)
  end
end
