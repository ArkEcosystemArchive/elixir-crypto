defmodule ArkEcosystem.Crypto.Identities.PublicKey do
  alias Exbtc.Core, as: BtcCore
  alias ArkEcosystem.Crypto.Utils.Der

  def from_passphrase(secret) do
    secret
    |> ArkEcosystem.Crypto.Identities.PrivateKey.from_passphrase()
    |> from_private_key
  end

  def from_private_key(private_key) do
    private_key
    |> BtcCore.privkey_to_pubkey()
    |> BtcCore.compress()
  end

  def verify(message, signature, public_key) do
    message = :crypto.hash(:sha256, message)
    signature = Base.decode16!(signature, case: :lower)
    public_key = Base.decode16!(public_key, case: :lower)

    :crypto.verify(:ecdsa, :sha256, {:digest, message}, signature, [public_key, :secp256k1])
  end
end
