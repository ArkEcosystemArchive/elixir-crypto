defmodule ArkEcosystem.Crypto.Builder.VoteTest do
  use ExUnit.Case, async: false
  import ArkEcosystem.Crypto.Builder.Vote
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

  @tag :skip
  test "create_vote", context do
    votes = ["+034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"]

    transaction = create(votes, context[:secret], nil, <<0x1e>>)

    expected_signature = "3045022100f4149f952e62d4b3ca5927d4e5a2651caf590f6460a84c7b0f19e14d062eaa2202202fe504ad32853d51e61c2c5c8847880212995fc126d9ce846bb806746b54c1d9"
    assert(transaction[:signature] == expected_signature)

    expected_id = "415e2adf375bd1110783850de13a92513acb66372462ee94054012f9af6a25d7"
    assert(transaction[:id] == expected_id)
  end

  @tag :skip
  test "create_vote with second signature", context do
    votes = ["+034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"]

    transaction = create(votes, context[:secret], context[:second_secret], <<0x1e>>)

    expected_sign_signature = "3045022100cb551914a376935af714a23b3fdbbb2435e6498ef16060db8c9574376148aeae0220690c422f953ff46d93334d6fb3be0e7a148ff50fa997985c13d6a9cd5ec53f73"
    assert(transaction[:sign_signature] == expected_sign_signature)

    expected_id = "84e4487eb23908b9849817a25b6804cb7aab5f13beaaa2ca2ef37c5c855db9d1"
    assert(transaction[:id] == expected_id)
  end

end
