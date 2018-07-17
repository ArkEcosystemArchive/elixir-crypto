defmodule ArkEcosystem.Crypto.Utils.MapKeyTransformer do
  def underscore(map) when is_map(map) do
    transform_map(map, &Macro.underscore/1)
  end

  def camelCase(map) when is_map(map) do
    transform_map(map, &camelizer/1)
  end

  defp transform_map(map, transformer) when is_map(map) do
    Map.keys(map)
    |> transform_keys(map, transformer)
  end

  defp transform_keys(keys, map, transformer) when length(keys) > 0 do
    {key, keys} = List.pop_at(keys, 0)

    value = Map.get(map, key)
    transformed_key = transform_key(key, transformer)

    map =
      cond do
        is_map(value) ->
          nested_keys = Map.keys(value)
          transformed_map = transform_keys(nested_keys, value, transformer)
          write_key(map, key, transformed_key, transformed_map)

        is_list(value) ->
          transformed_list =
            Enum.map(value, fn item -> transform_list_value(item, transformer) end)

          write_key(map, key, transformed_key, transformed_list)

        true ->
          write_key(map, key, transformed_key, value)
      end

    transform_keys(keys, map, transformer)
  end

  defp transform_keys(keys, map, _transformer) when length(keys) == 0 do
    map
  end

  defp transform_list_value(value, transformer) do
    cond do
      is_map(value) ->
        transform_map(value, transformer)

      is_list(value) ->
        Enum.map(value, fn item -> transform_list_value(item, transformer) end)

      true ->
        value
    end
  end

  defp transform_key(key, transformer) do
    key |> Atom.to_string() |> transformer.() |> String.to_atom()
  end

  defp write_key(map, old_key, new_key, value) do
    Map.delete(map, old_key) |> Map.put(new_key, value)
  end

  # Macro.camelize turns public_key into PublicKey, so
  # an additional step is necessary to downcase the first character.
  defp camelizer(key) do
    camelized = key |> Macro.camelize()

    String.downcase(String.first(camelized)) <>
      String.slice(camelized, 1, String.length(camelized))
  end
end
