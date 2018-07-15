defmodule ArkEcosystem.Crypto.Serializers.MultiSignatureRegistration do

  def serialize(bytes, transaction) do

    keysgroup = if transaction.version == 1 do
      serialize_keysgroup(transaction.asset.multisignature.keysgroup, [])
    else
      transaction.asset.multisignature.keysgroup
    end

    keysgroup_length = length keysgroup

    bytes
      <> << transaction.asset.multisignature.min::little-unsigned-integer-size(8) >>
      <> << keysgroup_length::little-unsigned-integer-size(8) >>
      <> << transaction.asset.multisignature.lifetime::little-unsigned-integer-size(8) >>
      <> (Enum.join(keysgroup) |> Base.decode16!(case: :lower))

  end

  defp serialize_keysgroup(v1_keysgroup, keysgroup) when length(v1_keysgroup) > 0 do

    { key, v1_keysgroup } = List.pop_at(v1_keysgroup, 0)

    key = if not is_nil(key) and String.starts_with?(key, "+") do
      key
        |> String.trim("+")

    else
      <<>>
    end

    keysgroup = keysgroup ++ [key]
    serialize_keysgroup(v1_keysgroup, keysgroup)
  end

  defp serialize_keysgroup(v1_keysgroup, keysgroup) when length(v1_keysgroup) == 0 do
    keysgroup
  end

end
