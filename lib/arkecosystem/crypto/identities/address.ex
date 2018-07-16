defmodule ArkEcosystem.Crypto.Identities.Address do
  alias ArkEcosystem.Crypto.Utils.Base58Check

  def from_passphrase(passphrase, network \\ nil) do
    passphrase
    |> ArkEcosystem.Crypto.Identities.PrivateKey.from_passphrase()
    |> from_private_key(network)
  end

  def from_public_key(public_key, network \\ nil) do
    network = network || ArkEcosystem.Crypto.Configuration.Network.version()

    public_key = Base.decode16(public_key, case: :lower)
    ripemd_public_key = :crypto.hash(:ripemd160, elem(public_key, 1))

    Base58Check.encode58check(network, ripemd_public_key)
  end

  def from_private_key(private_key, network \\ nil) do
    private_key
    |> ArkEcosystem.Crypto.Identities.PublicKey.from_private_key()
    |> from_public_key(network)
  end
end
