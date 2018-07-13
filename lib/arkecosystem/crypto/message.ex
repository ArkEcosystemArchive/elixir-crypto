defmodule ArkEcosystem.Crypto.Message do
  alias ArkEcosystem.Crypto.Utils.EcKey

  @spec sign(String.t(), String.t()) :: Map.t()
  def sign(message, passphrase) do
    %{
      :publickey => EcKey.secret_to_public_key(passphrase),
      :signature => EcKey.sign(message, passphrase),
      :message => message
    }
  end

  @spec verify(String.t(), String.t(), String.t()) :: Boolean.t()
  def verify(message, signature, public_key) do
    EcKey.verify(message, signature, public_key)
  end
end
