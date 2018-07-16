defmodule ArkEcosystem.Crypto.Transactions.Deserializers.DelegateRegistration do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)

    <<
      _               :: binary-size(offset),
      username_length :: little-integer-size(8),
      _               :: binary
    >> = bytes

    <<
      _               :: binary-size(offset),
      _               :: binary-size(1),
      username        :: binary-size(username_length),
      _               :: binary
    >> = bytes

    payload = %{
      :asset => %{
        :delegate => %{
          :username => username
        }
      }
    }

    start_offset = asset_offset + (username_length + 1) * 2

    [
      Map.merge(transaction, payload),
      start_offset,
      serialized,
      bytes
    ]
  end

end
