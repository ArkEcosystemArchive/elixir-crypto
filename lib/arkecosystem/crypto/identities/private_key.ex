defmodule ArkEcosystem.Crypto.Identities.PrivateKey do
  alias Exbtc.Core, as: BtcCore
  alias ArkEcosystem.Crypto.Utils.Der

  def from_passphrase(secret) do
    Base.encode16(:crypto.hash(:sha256, secret), case: :lower)
  end

  def sign(message, secret) do
    private_key = ArkEcosystem.Crypto.Identities.PrivateKey.from_passphrase(secret)

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
