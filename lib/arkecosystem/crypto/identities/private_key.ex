defmodule ArkEcosystem.Crypto.Identities.PrivateKey do
  def from_passphrase(secret) do
    Base.encode16(:crypto.hash(:sha256, secret), case: :lower)
  end
end
