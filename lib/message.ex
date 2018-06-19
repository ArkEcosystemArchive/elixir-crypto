# Taken from https://github.com/gjaldon/base58check, but uses :crypto instead of :erlsha2

defmodule ArkCrypto.Message do
  alias ArkCrypto.Utils.EcKey
  alias Exbtc.Core, as: BtcCore
  alias ArkCrypto.Utils.Der

  @spec sign(String.t(), String.t()) :: Map.t()
  def sign(message, passphrase) do
    private_key = EcKey.get_private_key(passphrase)

    {_v, r, s} = BtcCore.ecdsa_raw_sign(
      Base.encode16(:crypto.hash(:sha256, message), case: :lower),
      private_key
    )

    signature = r
    |> Der.encode_sequence(s)
    |> Base.encode16(case: :lower)

    %{
      :publickey => EcKey.private_key_to_public_key(private_key),
      :signature => signature,
      :message => message
    }
  end

  @spec verify(String.t(), String.t(), String.t()) :: Boolean.t()
  def verify(message, signature, public_key) do
    IO.puts message
    IO.puts signature
    IO.puts public_key
  end
end
