defmodule ArkEcosystem.Crypto.Serializers.SecondSignatureRegistration do

  def serialize(bytes, transaction) do

    bytes
      <> (transaction.asset.signature.publicKey |> Base.decode16!(case: :lower))

  end

end
