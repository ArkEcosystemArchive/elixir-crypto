defmodule ArkEcosystem.Crypto.Transactions.Transaction do
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Identities.{PublicKey, PrivateKey}
  alias ArkEcosystem.Crypto.Helpers.{Base58Check, MapKeyTransformer}
  alias ArkEcosystem.Crypto.Transactions.{Deserializer, Serializer}

  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()

  def get_id(transaction) do
    bytes = to_bytes(transaction, false, false)
    :sha256 |> :crypto.hash(bytes) |> Base.encode16(case: :lower)
  end

  def sign_transaction(transaction, passphrase, second_passphrase \\ nil)
      when is_map(transaction) do
    transaction
    |> sign(passphrase)
    |> second_sign(second_passphrase)
  end

  def sign(transaction, passphrase) do
    public_key = PublicKey.from_passphrase(passphrase)
    transaction = Map.put(transaction, :sender_public_key, public_key)

    signature = calc_signature(transaction, passphrase)

    transaction
    |> Map.put(:signature, signature)
    |> Map.put(:id, get_id(transaction))
  end

  def second_sign(transaction, nil) do
    transaction
  end

  def second_sign(transaction, second_passphrase) do
    sign_signature = calc_signature(transaction, second_passphrase, true)

    transaction
    |> Map.put(:sign_signature, sign_signature)
    |> Map.put(:id, get_id(transaction))
  end

  def verify(transaction) do
    to_bytes(transaction)
    |> PublicKey.verify(transaction.signature, transaction.sender_public_key)
  end

  def second_verify(transaction, second_public_key) do
    to_bytes(transaction, false)
    |> PublicKey.verify(transaction.sign_signature, second_public_key)
  end

  def to_bytes(transaction, skip_signature \\ true, skip_second_signature \\ true) do
    type = <<transaction.type::little-unsigned-integer-size(8)>>
    timestamp = <<transaction.timestamp::little-unsigned-integer-size(32)>>

    sender_public_key =
      transaction.sender_public_key
      |> Base.decode16!(case: :lower)

    skip_recipient_id =
      transaction.type in [@second_signature_registration, @multi_signature_registration]

    recipient_id =
      if Map.has_key?(transaction, :recipient_id) && not is_nil(transaction.recipient_id) &&
           not skip_recipient_id do
        Base58Check.decode58check(transaction.recipient_id)
      else
        String.duplicate(<<0>>, 21)
      end

    vendor_field =
      if Map.has_key?(transaction, :vendor_field) do
        length = byte_size(transaction.vendor_field)

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

    amount = <<transaction.amount::little-unsigned-integer-size(64)>>
    fee = <<transaction.fee::little-unsigned-integer-size(64)>>

    payload =
      case transaction.type do
        @second_signature_registration ->
          transaction.asset.signature.public_key
          |> Base.decode16!(case: :lower)

        @delegate_registration ->
          transaction.asset.delegate.username

        @vote ->
          Enum.join(transaction.asset.votes)

        @multi_signature_registration ->
          multi_signature = transaction.asset.multisignature

          keysgroup =
            transaction.asset.multisignature.keysgroup
            |> Enum.join()

          <<
            multi_signature.min::little-unsigned-integer-size(8),
            multi_signature.lifetime::little-unsigned-integer-size(8)
          >> <> keysgroup

        _ ->
          <<>>
      end

    signature =
      if not skip_signature and Map.has_key?(transaction, :signature) do
        transaction.signature
        |> Base.decode16!(case: :lower)
      else
        <<>>
      end

    second_signature =
      if not skip_second_signature and Map.has_key?(transaction, :second_signature) do
        transaction.second_signature
        |> Base.decode16!(case: :lower)
      else
        <<>>
      end

    type <>
      timestamp <>
      sender_public_key <>
      recipient_id <> vendor_field <> amount <> fee <> payload <> signature <> second_signature
  end

  def serialize(transaction) when is_map(transaction) do
    transaction |> Serializer.serialize(%{underscore: true})
  end

  def deserialize(serialized) when is_bitstring(serialized) do
    %{serialized: serialized} |> deserialize()
  end

  def deserialize(%{serialized: serialized}) when is_bitstring(serialized) do
    %{serialized: serialized} |> Deserializer.deserialize()
  end

  def to_params(transaction) when is_map(transaction) do
    param_keys = [
      :type,
      :amount,
      :fee,
      :vendor_field,
      :timestamp,
      :recipient_id,
      :sender_public_key,
      :signature,
      :id
    ]

    asset =
      if Map.has_key?(transaction, :asset) do
        %{:asset => transaction.asset}
      else
        %{:asset => %{}}
      end

    sign_signature =
      if Map.has_key?(transaction, :sign_signature) do
        %{:sign_signature => transaction.sign_signature}
      else
        %{}
      end

    Map.take(transaction, param_keys)
    |> Map.merge(asset)
    |> Map.merge(sign_signature)
    |> MapKeyTransformer.camelCase()
  end

  def to_json(transaction) when is_map(transaction) do
    transaction |> to_params |> Jason.encode!()
  end

  def encode58(data) when is_binary(data) do
    data
    |> Base58Check.encode58check(<<>>)
  end

  defp calc_signature(transaction, passphrase, second \\ false) do
    transaction
    |> to_bytes(not second)
    |> PrivateKey.sign(passphrase)
  end
end
