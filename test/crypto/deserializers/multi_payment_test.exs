defmodule ArkEcosystem.Crypto.Deserializer.MultiPaymentTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer
  import Mock

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/multi_payment.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Deserializer.deserialize(transaction)
    assert(actual.id == transaction.id)
  end


end
