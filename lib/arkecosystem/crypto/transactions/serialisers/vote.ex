defmodule ArkEcosystem.Crypto.Transactions.Serializers.Vote do
  def serialize(bytes, transaction) do
    votes = serialize_votes(transaction.asset.votes, [])
    votecount = length(votes)

    bytes <>
      <<votecount::little-unsigned-integer-size(8)>> <>
      (Enum.join(votes) |> Base.decode16!(case: :lower))
  end

  defp serialize_votes(votes, serialized_votes) when length(votes) > 0 do
    {vote, votes} = List.pop_at(votes, 0)

    serialized_votes =
      if not is_nil(vote) do
        prefix =
          if String.starts_with?(vote, "+") do
            "01"
          else
            "00"
          end

        <<_::binary-size(1), rest::binary>> = vote
        serialized_votes ++ [prefix <> rest]
      else
        serialized_votes
      end

    serialize_votes(votes, serialized_votes)
  end

  defp serialize_votes(votes, serialized_votes) when length(votes) == 0 do
    serialized_votes
  end
end
