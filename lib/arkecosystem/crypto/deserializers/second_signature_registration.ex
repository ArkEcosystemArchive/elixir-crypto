defmodule ArkEcosystem.Crypto.Deserializers.SecondSignatureRegistration do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    <<
      _           :: binary-size(asset_offset),
      public_key  :: binary-size(66),
      _           :: binary
    >> = serialized

    signature = %{
      :public_key => public_key
    }

    transaction = Kernel.put_in(transaction, [:asset, :signature], signature)

    asset_offset = asset_offset + 66

    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

end
