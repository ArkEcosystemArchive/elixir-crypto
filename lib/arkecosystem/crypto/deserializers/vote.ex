defmodule ArkEcosystem.Crypto.Deserializers.Vote do

  def deserialize(data) do
    [ transaction, asset_offset, serialized, bytes ] = data

    offset = div(asset_offset, 2)
    <<
      _           :: binary-size(offset),
      vote_length :: little-unsigned-integer-size(8),
      _           :: binary
    >> = bytes

    asset_offset = asset_offset + 2
    votes = deserialize_votes(0, vote_length, serialized, asset_offset, [])

    transaction = Kernel.put_in(transaction, [:asset, :votes], votes)

    asset_offset = asset_offset + vote_length * 34 * 2
    [
      transaction,
      asset_offset,
      serialized,
      bytes
    ]
  end

  defp deserialize_votes(from, to, serialized, offset, votes) when from < to do

    index_start = offset + from * 2 * 34
    index_end = 2 * 34 - 2
    <<
      _     :: binary-size(index_start),
      type  :: binary-size(2),
      vote  :: binary-size(index_end),
      _     :: binary
    >> = serialized

    vote = if String.last(type) == "1" do
      "+" <> vote
    else
      "-" <> vote
    end

    votes = votes ++ [vote]
    from = from + 1
    deserialize_votes(from, to, serialized, offset, votes)
  end

  defp deserialize_votes(from, to, _serialized, _offset, votes) when from == to do
    votes
  end

end
