ExUnit.start(exclude: [:skip])

defmodule ArkEcosystem.Test.TestHelper do

  @fixtures_path "test/fixtures/"

  def read_transaction_fixture(transaction_type, name) when is_bitstring(transaction_type) do
    ("transactions/" <> transaction_type <> "/" <> name)
      |> read_fixture
  end

  def read_fixture(path) when is_bitstring(path) do
    (@fixtures_path <> path <> ".json")
      |> File.read!
      |> Jason.decode!(%{ :keys => :atoms })
  end

end
