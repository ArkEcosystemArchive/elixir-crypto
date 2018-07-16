defmodule ArkEcosystem.Crypto.Identities.PublicKey do
  alias Exbtc.Core, as: BtcCore

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
end
