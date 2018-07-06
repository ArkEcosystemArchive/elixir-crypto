defmodule ArkEcosystem.Crypto.Builder.TransferTest do
  use ExUnit.Case, async: false
  import ArkEcosystem.Crypto.Builder.Transfer
  import Mock

  setup_with_mocks([
    {ArkEcosystem.Crypto.Crypto, [:passthrough], [seconds_since_epoch: fn() -> 27534919 end]}
  ]) do
    {
      :ok,
      [
        amount: 133380000000,
        recipient_id: "AXoXnFi4z1Z6aFvjEYkDVCtBGW2PaRiM25",
        vendor_field: "This is a transaction from PHP",
        secret: "this is a top secret passphrase",
        second_secret: "this is a top secret second passphrase"
      ]
    }
  end

  test "create_transfer", context do
    transaction = create(context[:recipient_id], context[:amount], context[:vendor_field], context[:secret])

    expected_signature = "3045022100dc01cb746d6223584f9a6df0c580161588f4475f714b972c015374db4bf494850220382c42e80f6fd13f32859528b9462d89e13d8667254fce3e69ea86925ac7477d"
    assert(transaction[:signature] == expected_signature)

    expected_id = "ea024d3f0d68c3ff92c04761138c8a7a916f72cededcedb77907cbf8a356f668"
    assert(transaction[:id] == expected_id)
  end

  test "create_transfer with second signature", context do
    transaction = create(context[:recipient_id], context[:amount], context[:vendor_field], context[:secret], context[:second_secret])

    expected_sign_signature = "3045022100c42b56f0767138fedf1d0c46695e5a5c1b1d05012171b8f535f53062b84f72a602203b58c598b53dea623c50d76a95f7121f5f9350d99fb2e88620a20a09c44c5839"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "61955359cd168358ea51fc12213a6e31f59716fa98ffbb45f920aed6d9a86400"
    assert(transaction[:id] == expected_id)
  end

end
