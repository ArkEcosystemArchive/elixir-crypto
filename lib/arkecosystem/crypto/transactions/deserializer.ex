defmodule ArkEcosystem.Crypto.Transactions.Deserializer do
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Identities.Address
  alias ArkEcosystem.Crypto.Transactions.Deserializers.DelegateRegistration
  alias ArkEcosystem.Crypto.Transactions.Deserializers.DelegateResignation
  alias ArkEcosystem.Crypto.Transactions.Deserializers.IPFS
  alias ArkEcosystem.Crypto.Transactions.Deserializers.MultiPayment
  alias ArkEcosystem.Crypto.Transactions.Deserializers.MultiSignatureRegistration
  alias ArkEcosystem.Crypto.Transactions.Deserializers.SecondSignatureRegistration
  alias ArkEcosystem.Crypto.Transactions.Deserializers.TimelockTransfer
  alias ArkEcosystem.Crypto.Transactions.Deserializers.Transfer
  alias ArkEcosystem.Crypto.Transactions.Deserializers.Vote
  alias ArkEcosystem.Crypto.Transactions.Transaction

  @transfer Types.transfer()
  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()
  @ipfs Types.ipfs()
  @timelock_transfer Types.timelock_transfer()
  @multi_payment Types.multi_payment()
  @delegate_resignation Types.delegate_resignation()

  def deserialize(%{serialized: serialized}) when is_bitstring(serialized) do
    bytes = Base.decode16!(serialized, case: :lower)
    {bytes, serialized}

    data = [serialized, bytes]

    transaction =
      data
      |> deserialize_header
      |> deserialize_type
      |> parse_signatures

    transaction =
      if !Map.has_key?(transaction, :amount) do
        Map.put(transaction, :amount, 0)
      else
        transaction
      end

    if transaction.version == 1 do
      handle_version_one(transaction)
    else
      transaction
    end
  end

  defp deserialize_header(data) do
    [serialized, bytes] = data

    <<
      _header::binary-size(1),
      version::little-unsigned-size(8),
      network::little-unsigned-size(8),
      type::little-unsigned-size(8),
      timestamp::little-unsigned-integer-size(32),
      sender_public_key::binary-size(33),
      fee::little-unsigned-integer-size(64),
      vendor_field_length::little-unsigned-integer-size(8),
      vendor_bytes::binary
    >> = bytes

    vendor_field_hex =
      if vendor_field_length > 0 do
        <<vendor_field_hex::binary-size(vendor_field_length), _::binary>> = vendor_bytes
        vendor_field_hex
      else
        <<>>
      end

    asset_offset = 50 * 2 + vendor_field_length * 2

    [
      %{
        :version => version,
        :network => network,
        :type => type,
        :timestamp => timestamp,
        :sender_public_key => sender_public_key |> Base.encode16(case: :lower),
        :fee => fee,
        :vendor_field_hex => vendor_field_hex |> Base.encode16(case: :lower),
        :asset => %{}
      },
      asset_offset,
      serialized,
      bytes
    ]
  end

  defp deserialize_type(data) do
    [transaction, _, _, _] = data

    case transaction.type do
      @transfer -> Transfer.deserialize(data)
      @second_signature_registration -> SecondSignatureRegistration.deserialize(data)
      @delegate_registration -> DelegateRegistration.deserialize(data)
      @vote -> Vote.deserialize(data)
      @multi_signature_registration -> MultiSignatureRegistration.deserialize(data)
      @ipfs -> IPFS.deserialize(data)
      @timelock_transfer -> TimelockTransfer.deserialize(data)
      @multi_payment -> MultiPayment.deserialize(data)
      @delegate_resignation -> DelegateResignation.deserialize(data)
    end
  end

  def parse_signatures(data) do
    [transaction, start_offset, serialized, _] = data

    <<
      _::binary-size(start_offset),
      signature::binary
    >> = serialized

    multi_signature_offset = 0

    transaction =
      if String.length(signature) == 0 do
        Map.delete(transaction, :signature)
      else
        # First Signature / Second Signature
        <<
          _::binary-size(2),
          signature_length::binary-size(2),
          _::binary
        >> = signature

        signature_length = calc_signature_size(signature_length)

        <<
          first_signature::binary-size(signature_length),
          second_signature::binary
        >> = signature

        transaction =
          transaction
          |> Map.put(:signature, first_signature)
          |> Map.put(:second_signature, second_signature)

        # Multi Signature
        multi_signature_offset = multi_signature_offset + signature_length

        {transaction, multi_signature_offset} =
          if String.length(second_signature) == 0 or String.starts_with?(second_signature, "ff") do
            {Map.delete(transaction, :second_signature), multi_signature_offset}
          else
            # Second Signature
            <<
              _::binary-size(2),
              second_signature_length::binary-size(2),
              _::binary
            >> = second_signature

            second_signature_length = calc_signature_size(second_signature_length)

            <<
              second_signature_data::binary-size(second_signature_length),
              _::binary
            >> = second_signature

            # Multi Signature
            multi_signature_offset = multi_signature_offset + second_signature_length

            {Map.put(transaction, :second_signature, second_signature_data),
             multi_signature_offset}
          end

        # All Signatures
        <<
          _::binary-size(start_offset),
          _::binary-size(multi_signature_offset),
          signatures::binary
        >> = serialized

        transaction =
          if String.length(signatures) > 0 and String.starts_with?(signatures, "ff") do
            # Parse Multi Signatures
            <<
              _::binary-size(2),
              multi_signature_bytes::binary
            >> = signatures

            multi_signatures = parse_multi_signatures(multi_signature_bytes, [])

            if length(multi_signatures) > 0 do
              Map.put(transaction, :signatures, multi_signatures)
            else
              transaction
            end
          else
            transaction
          end

        transaction
      end

    transaction
  end

  defp parse_multi_signatures(bytes, signatures) when byte_size(bytes) > 0 do
    <<
      _::binary-size(2),
      multi_signature_length::binary-size(2),
      _::binary
    >> = bytes

    multi_signature_length = calc_signature_size(multi_signature_length)

    if multi_signature_length > 0 do
      <<
        signature::binary-size(multi_signature_length),
        rest::binary
      >> = bytes

      signatures = signatures ++ [signature]
      parse_multi_signatures(rest, signatures)
    else
      parse_multi_signatures(<<>>, signatures)
    end
  end

  defp parse_multi_signatures(bytes, signatures) when byte_size(bytes) == 0 do
    signatures
  end

  defp handle_version_one(transaction) do
    transaction =
      if Map.has_key?(transaction, :second_signature) do
        Map.put(transaction, :sign_signature, transaction.second_signature)
      else
        transaction
      end

    transaction =
      case transaction.type do
        @vote ->
          recipient_id =
            Address.from_public_key(transaction.sender_public_key, transaction.network)

          Map.put(transaction, :recipient_id, recipient_id)

        @multi_signature_registration ->
          keysgroup =
            transaction.asset.multisignature.keysgroup
            |> Enum.map(fn key ->
              if String.starts_with?(key, "+"), do: key, else: "+" <> key
            end)

          Kernel.put_in(transaction, [:asset, :multisignature, :keysgroup], keysgroup)

        _ ->
          transaction
      end

    transaction =
      if Map.has_key?(transaction, :vendor_field_hex) and
           byte_size(transaction.vendor_field_hex) > 0 do
        vendor_field = Base.decode16!(transaction.vendor_field_hex, case: :lower)
        Map.put(transaction, :vendor_field, vendor_field)
      else
        transaction
      end

    transaction =
      if !Map.has_key?(transaction, :id) do
        id = Transaction.get_id(transaction)
        Map.put(transaction, :id, id)
      else
        transaction
      end

    # Calculate recipient_id after the transaction id has been computed, because of
    # https://github.com/ArkEcosystem/core/issues/754
    case transaction.type do
      type when type in [@second_signature_registration, @multi_signature_registration] ->
        recipient_id = Address.from_public_key(transaction.sender_public_key, transaction.network)
        Map.put(transaction, :recipient_id, recipient_id)

      _ ->
        transaction
    end
  end

  defp calc_signature_size(hex) do
    hex
    |> Integer.parse(16)
    |> Tuple.to_list()
    |> List.first()
    |> (&(&1 + 2)).()
    |> (&(&1 * 2)).()
  end
end
