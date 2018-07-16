defmodule ArkEcosystem.Crypto.Utils.Underscorer do
  def underscore(map) when is_map(map) do
    Map.keys(map)
    |> transform_keys(map)
  end

  defp transform_keys(keys, map) when length(keys) > 0 do
    {key, keys} = List.pop_at(keys, 0)

    value = Map.get(map, key)
    underscore_key = make_key_underscore(key)

    map =
      cond do
        is_map(value) ->
          nested_keys = Map.keys(value)
          transformed_map = transform_keys(nested_keys, value)
          Map.put(map, underscore_key, transformed_map)

        is_list(value) ->
          transformed_list = Enum.map(value, fn item -> transform_list_value(item) end)
          Map.put(map, underscore_key, transformed_list)

        true ->
          Map.delete(map, key)
          |> Map.put(underscore_key, value)
      end

    transform_keys(keys, map)
  end

  defp transform_keys(keys, map) when length(keys) == 0 do
    map
  end

  defp transform_list_value(value) do
    cond do
      is_map(value) ->
        underscore(value)

      is_list(value) ->
        Enum.map(value, fn item -> transform_list_value(item) end)

      true ->
        value
    end
  end

  defp make_key_underscore(key) do
    key |> Atom.to_string() |> Macro.underscore() |> String.to_atom()
  end
end
