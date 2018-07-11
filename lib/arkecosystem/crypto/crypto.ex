defmodule ArkEcosystem.Crypto.Crypto do
  alias ArkEcosystem.Crypto.Utils.{EcKey, Base58Check}
  alias ArkEcosystem.Crypto.Enums.Types

  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()

  def get_id(transaction) do
    bytes = get_bytes(transaction, false, false)
    :sha256 |> :crypto.hash(bytes) |> Base.encode16(case: :lower)
  end

  def sign_transaction(transaction, secret, second_secret \\ nil) when is_map(transaction) do
    transaction
      |> sign(secret)
      |> second_sign(second_secret)
  end

  def sign(transaction, secret) do
    public_key = EcKey.secret_to_public_key(secret)
    transaction = Map.put(transaction, :sender_public_key, public_key)

    signature = calc_signature(transaction, secret)
    transaction = Map.put(transaction, :signature, signature)

    id = get_id(transaction)
    Map.put(transaction, :id, id)
  end

  def second_sign(transaction, nil) do
    transaction
  end

  def second_sign(transaction, second_secret) do
    sign_signature = calc_signature(transaction, second_secret, true)
    transaction
      |> Map.put(:sign_signature, sign_signature)
  end

  # TODO: fix verify
  def verify(transaction) do
    get_bytes(transaction)
      #|> EcKey.ecdsa_verify(transaction.signature, transaction.sender_public_key)
  end

  # TODO: fix verify
  def second_verify(transaction) do
    get_bytes(transaction, false)
      #|> EcKey.ecdsa_verify(transaction.sign_signature, transaction.sender_public_key)
  end

  def get_bytes(transaction, skip_signature \\ true, skip_second_signature \\ true) do
    type = << transaction.type::little-unsigned-integer-size(8) >>
    timestamp = << transaction.timestamp::little-unsigned-integer-size(32) >>
    sender_public_key = transaction.sender_public_key
      |> Base.decode16!(case: :lower)

    recipient_id = if Map.has_key?(transaction, :recipient_id) do
      Base58Check.decode58check(transaction.recipient_id)
    else
      String.duplicate(<<0>>, 21)
    end

    vendor_field = if Map.has_key?(transaction, :vendor_field) do

      length = byte_size transaction.vendor_field
      cond do
        length < 64 ->
          diff = 64 - length
          transaction.vendor_field <> String.duplicate(<<0>>, diff)

        length > 64 ->
          String.slice(transaction, 0..63)

        true ->
          transaction.vendor_field
      end

    else
      String.duplicate(<<0>>, 64)
    end

    amount = << transaction.amount::little-unsigned-integer-size(64) >>
    fee = << transaction.fee::little-unsigned-integer-size(64) >>

    payload = case transaction.type do

      @second_signature_registration ->
        transaction.asset.signature.public_key
          |> Base.decode16!(case: :lower)

      @delegate_registration ->
        transaction.asset.delegate.username

      @vote ->
        Enum.join(transaction.asset.votes)

      @multi_signature_registration ->
        multi_signature = transaction.asset.multisignature
        keysgroup = transaction.asset.multisignature.keysgroup
          |> Enum.join

        <<
          multi_signature.min::little-unsigned-integer-size(8),
          multi_signature.lifetime::little-unsigned-integer-size(8),
        >> <> keysgroup

      _ ->
        <<>>
    end

    signature = if not skip_signature and Map.has_key?(transaction, :signature) do
      transaction.signature
        |> Base.decode16!(case: :lower)
    else
      <<>>
    end

    second_signature = if not skip_second_signature and Map.has_key?(transaction, :second_signature) do
      transaction.second_signature
        |> Base.decode16!(case: :lower)
    else
      <<>>
    end

    type
      <> timestamp
      <> sender_public_key
      <> recipient_id
      <> vendor_field
      <> amount
      <> fee
      <> payload
      <> signature
      <> second_signature
  end

  def encode58(data) when is_binary data do
    data
      |> Base58Check.encode58check(<<>>)
  end

  defp calc_signature(transaction, secret, second \\ false) do
    transaction
      |> get_bytes(not second)
      |> EcKey.sign(secret)
  end

end
