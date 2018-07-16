defmodule ArkEcosystem.Crypto.Identities.WIF do
  alias ArkEcosystem.Crypto.Utils.Base58Check
  alias ArkEcosystem.Crypto.Configuration.Network

  def from_passphrase(passphrase, network \\ nil) do
    network = network || Network.get()
    passphrase = :crypto.hash(:sha256, passphrase) <> <<1>>
    Base58Check.encode58check(<<network.wif>>, passphrase)
  end
end
