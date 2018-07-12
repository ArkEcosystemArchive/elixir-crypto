defmodule ArkEcosystem.Crypto.Serializer do
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Serializers.Transfer
  alias ArkEcosystem.Crypto.Serializers.SecondSignatureRegistration
  alias ArkEcosystem.Crypto.Serializers.DelegateRegistration
  alias ArkEcosystem.Crypto.Serializers.Vote
  alias ArkEcosystem.Crypto.Serializers.MultiSignatureRegistration
  alias ArkEcosystem.Crypto.Serializers.IPFS
  alias ArkEcosystem.Crypto.Serializers.TimelockTransfer
  alias ArkEcosystem.Crypto.Serializers.MultiPayment
  alias ArkEcosystem.Crypto.Serializers.DelegateResignation

  @transfer Types.transfer()
  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()
  @ipfs Types.ipfs()
  @timelock_transfer Types.timelock_transfer()
  @multi_payment Types.multi_payment()
  @delegate_resignation Types.delegate_resignation()


  def serialize(transaction) when is_map transaction do

    transaction
      |> serialize_header
      |> serialize_vendor_field(transaction)
      |> serialize_type(transaction)
      |> serialize_signatures(transaction)
      |> Base.encode16(case: :lower)

  end

  defp serialize_header(transaction) do
    header = << 255::little-unsigned-integer-size(8) >>
    version = if Map.has_key?(transaction, :version) do
      << transaction.version::little-unsigned-integer-size(8) >>
    else
      << 1::little-unsigned-integer-size(8) >>
    end

    network = << transaction.network::little-unsigned-integer-size(8) >>
    type = << transaction.type::little-unsigned-integer-size(8) >>
    timestamp = << transaction.timestamp::little-unsigned-integer-size(32) >>
    sender_public_key = transaction.sender_public_key
      |> Base.decode16!(case: :lower)

    fee = << transaction.fee::little-unsigned-integer-size(64) >>

    header
      <> version
      <> network
      <> type
      <> timestamp
      <> sender_public_key
      <> fee
  end

  defp serialize_vendor_field(bytes, transaction) do

    bytes <> cond do
      Map.has_key?(transaction, :vendor_field) ->
        length = byte_size transaction.vendor_field
        << length::little-unsigned-integer-size(length) >>
        <> transaction.vendor_field

      Map.has_key?(transaction, :vendor_field_hex) ->
        length = byte_size transaction.vendor_field_hex

        << length::little-unsigned-integer-size(8) >>
        <> transaction.vendor_field_hex

      true ->
        << 0::little-unsigned-integer-size(8) >>
    end

  end

  defp serialize_type(bytes, transaction) do

    case transaction.type do
      @transfer -> Transfer.serialize(bytes, transaction)
      @second_signature_registration -> SecondSignatureRegistration.serialize(bytes, transaction)
      @delegate_registration -> DelegateRegistration.serialize(bytes, transaction)
      @vote -> Vote.serialize(bytes, transaction)
      @multi_signature_registration -> MultiSignatureRegistration.serialize(bytes, transaction)
      @ipfs -> IPFS.serialize(bytes, transaction)
      @timelock_transfer -> TimelockTransfer.serialize(bytes, transaction)
      @multi_payment -> MultiPayment.serialize(bytes, transaction)
      @delegate_resignation -> DelegateResignation.serialize(bytes, transaction)
    end

  end

  defp serialize_signatures(bytes, transaction) do

    signature = if Map.has_key?(transaction, :signature) do
      transaction.signature
        |>Base.decode16!(case: :lower)

    else
      <<>>
    end

    second_signature = cond do
      Map.has_key?(transaction, :second_signature) ->
        transaction.second_signature
          |>Base.decode16!(case: :lower)

      Map.has_key?(transaction, :sign_signature) ->
        transaction.sign_signature
          |>Base.decode16!(case: :lower)

      true ->
        <<>>
    end

    signatures = if Map.has_key?(transaction, :signatures) do
      << 255::little-unsigned-integer-size(8) >>
      <> (
        transaction.signatures
          |> Enum.join
          |> Base.decode16!(case: :lower)
      )
    else
      <<>>
    end

    bytes
      <> signature
      <> second_signature
      <> signatures
  end

end
