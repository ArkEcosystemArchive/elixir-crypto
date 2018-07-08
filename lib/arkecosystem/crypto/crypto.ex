defmodule ArkEcosystem.Crypto.Crypto do
  alias ArkEcosystem.Crypto.Utils.Base58Check
  alias ArkEcosystem.Crypto.Enums.Types

  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()

  # 13:00:00 March 21, 2017
  @ark_epoch Application.get_env(:ark_crypto, :transactions)[:epoch]

  @doc """
  Unix timestamp representing the seconds between the Unix Epoch and the Ark
  Epoch. Add this to the timestamps received from the API to make them UNIX.
  """
  @spec ark_epoch() :: Integer.t()
  def ark_epoch do
    @ark_epoch
  end

  @spec seconds_since_epoch() :: Integer.t()
  def seconds_since_epoch do
    :os.system_time(:seconds) - @ark_epoch
  end

  def get_id(transaction) do
    bytes = get_bytes(transaction, false, false)
    :sha256 |> :crypto.hash(bytes) |> Base.encode16(case: :lower)
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

    # TODO: fix vendor field
    vendor_field = if Map.has_key?(transaction, :vendor_field) do
      #
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

end
