defmodule ArkEcosystem.Crypto.Deserializers.DelegateResignationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/delegate_resignation.json")
      |> Jason.decode!(%{ :keys => :atoms })

    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    actual = Deserializer.deserialize(transaction)
    assert(actual.id == transaction.id)
  end

end
