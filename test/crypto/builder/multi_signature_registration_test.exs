defmodule ArkEcosystem.Crypto.Builder.MultiSignatureRegistrationTest do
  use ExUnit.Case, async: false
  import ArkEcosystem.Crypto.Builder.MultiSignatureRegistration
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

  test "create_multisignature", context do
    keysgroup = [
      "+03a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+13a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933",
      "+23a02b9d5fdd1307c2ee4652ba54d492d1fd11a7d1bb3f3a44c4a05e79f19de933"
    ]
    lifetime = 74
    min = 2

    transaction = create(context[:secret], nil, keysgroup, lifetime, min)

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

    transaction = create(context[:secret], context[:second_secret], keysgroup, lifetime, min)

    expected_sign_signature = "30450221009a8132f01ffc103e2e9bb66820cbf9a10b7a494b36e9427a5784f780f51f1eb3022032872b99e881eb16d2563c75c4c85cd5bb564ab3b94c426a710c941c5a9a9991"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "642d47747de077074f5e5f07720c808733ea67cef5ddd25bbeb4e54222404ef7"
    assert(transaction[:id] == expected_id)
  end

end
