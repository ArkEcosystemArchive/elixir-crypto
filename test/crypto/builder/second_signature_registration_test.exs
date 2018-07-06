defmodule ArkEcosystem.Crypto.Builder.SecondSignatureRegistrationTest do
  use ExUnit.Case, async: false
  import ArkEcosystem.Crypto.Builder.SecondSignatureRegistration
  import Mock

  setup_with_mocks([
    {ArkEcosystem.Crypto.Crypto, [:passthrough], [seconds_since_epoch: fn() -> 27534919 end]}
  ]) do
    {
      :ok,
      [
        secret: "this is a top secret passphrase",
        second_secret: "this is a top secret second passphrase"
      ]
    }
  end

  test "create_second_signature", context do
    transaction = create(context[:second_secret], context[:secret])

    expected_signature = "3045022100e0f8cf6f9697b5a60757a71cc45d32803d4877afba053ab10501f9d2c9d9894b02200ce473d59f0d2b577d04b267bb25f4c5e7f12c15290c35efafbe3ff9b4a26a30"
    assert(transaction[:signature] == expected_signature)

    expected_id = "a5415f2639d1e1e9b63545dffed6ed36f7f72e20ee107ec8dfa0e644c42ff881"
    assert(transaction[:id] == expected_id)
  end

end
