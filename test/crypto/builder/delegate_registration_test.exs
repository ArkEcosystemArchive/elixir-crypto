defmodule ArkEcosystem.Crypto.Builder.DelegateRegistrationTest do
  use ExUnit.Case, async: false
  import ArkEcosystem.Crypto.Builder.DelegateRegistration
  import Mock

  @tag :skip
  setup_with_mocks([
    {ArkEcosystem.Crypto.Crypto, [:passthrough], [seconds_since_epoch: fn() -> 27534919 end]}
  ]) do
    {
      :ok,
      [
        username: "polo polo",
        secret: "this is a top secret passphrase",
        second_secret: "this is a top secret second passphrase"
      ]
    }
  end

  test "create", context do
    transaction = create(context[:username], context[:secret])
    expected_signature = "3045022100ba357d3e1cbade677819594e3530e0f8d03352b6b663a05375739aa5c997db5002203fdc93b79300bd19949ff2df8266cee338a0afb6d890158191d4238301774663"
    assert(transaction[:signature] == expected_signature)

    expected_id = "26866f39d5575010cf1c3d07413f83a8032632cb3054a1f67748002f2bfc7d99"
    assert(transaction[:id] == expected_id)
  end

  @tag :skip
  test "create_delegate with second signature", context do
    transaction = create(context[:username], context[:secret], context[:second_secret])

    expected_sign_signature = "3045022100ee0ece14aef2c2b9bf9d6977e9ec3aa2fb9012e6fda3319ffff5fdec6e918e7a022032586a338df7fd6d55e6d303c0fa2e3454faa7aeeb45056fded3fca63e991002"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "6e121a27ffe05adc172f0f98b9aafe374cb93c9927b0ade4a273f7437785826e"
    assert(transaction[:id] == expected_id)
  end

end
