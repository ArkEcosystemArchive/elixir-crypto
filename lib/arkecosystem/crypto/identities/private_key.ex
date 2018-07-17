defmodule ArkEcosystem.Crypto.Identities.PrivateKey do
  alias Exbtc.Core, as: BtcCore
  alias ArkEcosystem.Crypto.Helpers.Der

  def from_passphrase(passphrase) do
    Base.encode16(:crypto.hash(:sha256, passphrase), case: :lower)
  end

  def from_hex(private_key) do
    Base.decode16!(private_key, case: :lower)
  end

  def sign(message, passphrase) do
    private_key = ArkEcosystem.Crypto.Identities.PrivateKey.from_passphrase(passphrase)

    {_v, r, s} =
      BtcCore.ecdsa_raw_sign(
        Base.encode16(:crypto.hash(:sha256, message), case: :lower),
        private_key
      )

    r
    |> Der.encode_sequence(s)
    |> Base.encode16(case: :lower)
  end
end
