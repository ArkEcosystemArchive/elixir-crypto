defmodule ArkElixirCrypto.EcKeyTest do
  use ExUnit.Case
  import ArkElixirCrypto.EcKey

  test 'sign' do
    private_key = 'this is a top secret passphrase'
    expected = "304402206d3a4716995a97a6ef7a21d159e7c3ffb85e542aa095cd890aab06cda3db4be702202a122d0f5f827db1faa850ea4a719a9a9f351ae63714ba7b459cbdf6fb5e8fc6"
    assert(sign('a', private_key) == expected)

    expected = "304402201dc0c6e81f7aa26c28bfed7a999ad7059368ffe039f40052e9cd7b45c03d717102207f2e988b406a3916f22c05734fdb68d4e79377b3a2f905ca3fb1923dfb715393"
    assert(sign('some message', private_key) == expected)

    expected = "3044022013cb636a73572ddc3e779853f488492dc735991548d10a028b6424265b0453c302204d9b71d1ac770d18549f4362ba542c8299e3b3e0eae8b460903c3c47ce3e52aa"
    assert(sign('pina colada', private_key) == expected)
  end

  test 'secret_to_address' do
    secret = "this is a top secret passphrase"
    assert(secret_to_address(secret, <<0x17>>) == "AGeYmgbg2LgGxRW2vNNJvQ88PknEJsYizC")
    assert(secret_to_address(secret, <<0x1e>>) == "D61mfSggzbvQgTUe6JhYKH2doHaqJ3Dyib")
  end
end
