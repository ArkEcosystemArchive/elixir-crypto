defmodule ArkEcosystem.Crypto.Utils.EcKey do
  alias Exbtc.Core, as: BtcCore
  alias ArkEcosystem.Crypto.Utils.Der

  # TODO: move this to the private key
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

  # TODO: move this to the public key
  def verify(message, signature, public_key) do
    message = :crypto.hash(:sha256, message)
    signature = Base.decode16!(signature, case: :lower)
    public_key = Base.decode16!(public_key, case: :lower)

    :crypto.verify(:ecdsa, :sha256, {:digest, message}, signature, [public_key, :secp256k1])
  end
end
