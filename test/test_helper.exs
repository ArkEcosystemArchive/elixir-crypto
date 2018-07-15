ExUnit.start(exclude: [:skip])

defmodule ArkEcosystem.Test.TestHelper do

  @fixtures_path "test/fixtures/transactions/"

  def read_fixture(transaction_type, name) when is_bitstring(transaction_type) do
    filepath = @fixtures_path <> transaction_type <> "/" <> name <> ".json"

    File.read!(filepath)
      |> Jason.decode!(%{ :keys => :atoms })
  end

end
