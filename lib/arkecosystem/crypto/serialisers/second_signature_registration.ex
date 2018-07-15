defmodule ArkEcosystem.Crypto.Serializers.SecondSignatureRegistration do

  def serialize(bytes, transaction) do

    bytes
      <> (transaction.asset.signature.public_key |> Base.decode16!(case: :lower))

  end

end
