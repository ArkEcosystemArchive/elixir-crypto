defmodule ArkElixirCrypto.TransactionBuilderTest do
  use ExUnit.Case, async: false
  import ArkElixirCrypto.TransactionBuilder
  import Mock

  setup_with_mocks([
    {ArkElixirCrypto.TransactionBuilder, [:passthrough], [seconds_since_epoch: fn() -> 27534919 end]}
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
    transaction = create_transfer(context[:recipient_id], context[:amount], context[:vendor_field], context[:secret])

    expected_signature = "3045022100dc01cb746d6223584f9a6df0c580161588f4475f714b972c015374db4bf494850220382c42e80f6fd13f32859528b9462d89e13d8667254fce3e69ea86925ac7477d"
    assert(transaction[:signature] == expected_signature)

    expected_id = "ea024d3f0d68c3ff92c04761138c8a7a916f72cededcedb77907cbf8a356f668"
    assert(transaction[:id] == expected_id)
  end

  test "create_transfer with second signature", context do
    transaction = create_transfer(context[:recipient_id], context[:amount], context[:vendor_field], context[:secret], context[:second_secret])

    expected_sign_signature = "3045022100c42b56f0767138fedf1d0c46695e5a5c1b1d05012171b8f535f53062b84f72a602203b58c598b53dea623c50d76a95f7121f5f9350d99fb2e88620a20a09c44c5839"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "61955359cd168358ea51fc12213a6e31f59716fa98ffbb45f920aed6d9a86400"
    assert(transaction[:id] == expected_id)
  end

  test "create_second_signature", context do
    transaction = create_second_signature(context[:second_secret], context[:secret])

    expected_signature = "3045022100e0f8cf6f9697b5a60757a71cc45d32803d4877afba053ab10501f9d2c9d9894b02200ce473d59f0d2b577d04b267bb25f4c5e7f12c15290c35efafbe3ff9b4a26a30"
    assert(transaction[:signature] == expected_signature)

    expected_id = "a5415f2639d1e1e9b63545dffed6ed36f7f72e20ee107ec8dfa0e644c42ff881"
    assert(transaction[:id] == expected_id)
  end

  test "create_vote", context do
    votes = ["+034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"]

    transaction = create_vote(votes, context[:secret], nil, <<0x1e>>)

    expected_signature = "3045022100f4149f952e62d4b3ca5927d4e5a2651caf590f6460a84c7b0f19e14d062eaa2202202fe504ad32853d51e61c2c5c8847880212995fc126d9ce846bb806746b54c1d9"
    assert(transaction[:signature] == expected_signature)

    expected_id = "415e2adf375bd1110783850de13a92513acb66372462ee94054012f9af6a25d7"
    assert(transaction[:id] == expected_id)
  end

  test "create_vote with second signature", context do
    votes = ["+034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"]

    transaction = create_vote(votes, context[:secret], context[:second_secret], <<0x1e>>)

    expected_sign_signature = "3045022100cb551914a376935af714a23b3fdbbb2435e6498ef16060db8c9574376148aeae0220690c422f953ff46d93334d6fb3be0e7a148ff50fa997985c13d6a9cd5ec53f73"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "84e4487eb23908b9849817a25b6804cb7aab5f13beaaa2ca2ef37c5c855db9d1"
    assert(transaction[:id] == expected_id)
  end

  test "create_delegate", context do
    transaction = create_delegate("polo polo", context[:secret])

    expected_signature = "3045022100ba357d3e1cbade677819594e3530e0f8d03352b6b663a05375739aa5c997db5002203fdc93b79300bd19949ff2df8266cee338a0afb6d890158191d4238301774663"
    assert(transaction[:signature] == expected_signature)

    expected_id = "26866f39d5575010cf1c3d07413f83a8032632cb3054a1f67748002f2bfc7d99"
    assert(transaction[:id] == expected_id)
  end

  test "create_delegate with second signature", context do
    transaction = create_delegate("polo polo", context[:secret], context[:second_secret])

    expected_sign_signature = "3045022100ee0ece14aef2c2b9bf9d6977e9ec3aa2fb9012e6fda3319ffff5fdec6e918e7a022032586a338df7fd6d55e6d303c0fa2e3454faa7aeeb45056fded3fca63e991002"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "6e121a27ffe05adc172f0f98b9aafe374cb93c9927b0ade4a273f7437785826e"
    assert(transaction[:id] == expected_id)
  end

  test "create_multisignature", context do
    keysgroup = [
      "+03a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+13a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+23a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933"
    ]
    lifetime = 74
    min = 2

    transaction = create_multisignature(context[:secret], nil, keysgroup, lifetime, min)

    expected_signature = "3045022100f24edf633395645601eb6f10a3e8f5f7638219862fc3053c40a798d1b9375721022054fc70dc96b3e6b9aa56d83701dcfc5d6c266f7c0bc75ace409a8c078bf00e72"
    assert(transaction[:signature] == expected_signature)

    expected_id = "0de9ade4017b8938847d86d9c523b86d46f7fa5e2e9d8caf5e64c5b7a6954ffe"
    assert(transaction[:id] == expected_id)
  end

  test "create_multisignature with second signature", context do
    keysgroup = [
      "+03a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+13a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+23a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933"
    ]
    lifetime = 74
    min = 2

    transaction = create_multisignature(context[:secret], context[:second_secret], keysgroup, lifetime, min)

    expected_sign_signature = "30450221009a8132f01ffc103e2e9bb66820cbf9a10b7a494b36e9427a5784f780f51f1eb3022032872b99e881eb16d2563c75c4c85cd5bb564ab3b94c426a710c941c5a9a9991"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "642d47747de077074f5e5f07720c808733ea67cef5ddd25bbeb4e54222404ef7"
    assert(transaction[:id] == expected_id)
  end
end
