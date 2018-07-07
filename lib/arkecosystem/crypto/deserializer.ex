defmodule ArkEcosystem.Crypto.Deserializer do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Deserializers.Transfer
  alias ArkEcosystem.Crypto.Deserializers.SecondSignatureRegistration
  alias ArkEcosystem.Crypto.Deserializers.DelegateRegistration
  alias ArkEcosystem.Crypto.Deserializers.Vote
  alias ArkEcosystem.Crypto.Deserializers.MultiSignatureRegistration
  alias ArkEcosystem.Crypto.Deserializers.IPFS
  alias ArkEcosystem.Crypto.Deserializers.TimelockTransfer
  alias ArkEcosystem.Crypto.Deserializers.MultiPayment
  alias ArkEcosystem.Crypto.Deserializers.DelegateResignation

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
    IO.puts serialized

    bytes = Base.decode16!(serialized, case: :lower)
    { bytes, serialized }
    IO.inspect bytes

    data = [ serialized, bytes ]

    transaction = data
      |> deserialize_header
      |> deserialize_type
      |> parse_signatures

    if !Map.has_key?(transaction, :amount) do
      transaction = Map.put(transaction, :amount, 0)
    end

    if transaction.version == 1 do
      transaction = handle_version_one(transaction)
    end

    transaction
  end

  defp deserialize_header(data) do
    [serialized, bytes] = data

    <<
      _header             :: binary-size(1),
      version             :: little-unsigned-size(8),
      network             :: little-unsigned-size(8),
      type                :: little-unsigned-size(8),
      timestamp           :: little-unsigned-integer-size(32),
      sender_public_key   :: binary-size(33),
      fee                 :: little-unsigned-integer-size(64),
      vendor_field_length :: little-unsigned-integer-size(8),
      vendor_bytes        :: binary
    >> = bytes

    vendor_field_hex = <<>>

    if vendor_field_length > 0 do
      <<
        vendor_field_hex  :: binary-size(vendor_field_length),
        _                 :: binary
      >> = vendor_bytes
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
        :vendor_field_hex => vendor_field_hex,
        :asset => %{}
      },

      asset_offset,
      serialized,
      bytes
    ]
  end

  defp deserialize_type(data) do
    [ transaction, _, _, _ ] = data

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
    [ transaction, start_offset, serialized, _] = data

    <<
      _             :: binary-size(start_offset),
      signature     :: binary
    >> = serialized

    multi_signature_offset = 0
    if String.length(signature) == 0 do
      transaction = Map.delete(transaction, :signature)
    else

      IO.inspect "MOO"
      IO.inspect signature
      # First Signature / Second Signature
      <<
        _                     :: binary-size(2),
        signature_length      :: binary-size(2),
        _                     :: binary
      >> = signature

      signature_length = calc_signature_size(signature_length)

      <<
        first_signature       :: binary-size(signature_length),
        second_signature      :: binary
      >> = signature

      transaction = Map.put(transaction, :signature, first_signature)
      transaction = Map.put(transaction, :second_signature, second_signature)

      # Multi Signature
      multi_signature_offset = multi_signature_offset + signature_length

      if String.length(second_signature) == 0 or
         String.starts_with?(second_signature, "ff") do

        transaction = Map.delete(transaction, :second_signature)
      else

        # Second Signature
        <<
          _                       :: binary-size(2),
          second_signature_length :: binary-size(2),
          _                       :: binary
        >> = signature

        second_signature_length = calc_signature_size(second_signature_length)

        <<
          second_signature  :: binary-size(second_signature_length),
          _                 :: binary
        >> = transaction.second_signature

        transaction = Map.put(transaction, :second_signature, second_signature)

        # Multi Signature
        multi_signature_offset = multi_signature_offset + second_signature_length
      end

      # All Signatures
      <<
        _           :: binary-size(start_offset),
        _           :: binary-size(multi_signature_offset),
        signatures  :: binary
      >> = serialized

      if String.length(second_signature) > 0 and !String.starts_with?(second_signature, "ff") do

        # Parse Multi Signatures
        <<
          _                     :: binary-size(2),
          multi_signature_bytes :: binary
        >> = signatures
        multi_signatures = parse_multi_signatures(multi_signature_bytes, [])

        if length(multi_signatures) > 0 do
          transaction = Map.put(transaction, :signatures, multi_signatures)
        end

      end
    end

    IO.inspect transaction

    transaction
  end

  defp parse_multi_signatures(bytes, signatures) when byte_size(bytes) > 0 do
    <<
      _                       :: binary-size(2),
      multi_signature_length  :: binary-size(2),
      _                       :: binary
    >> = bytes

    multi_signature_length = calc_signature_size(multi_signature_length)
    if multi_signature_length > 0 do
      <<
        signature :: binary-size(multi_signature_length),
        rest      :: binary
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
    if Map.has_key?(transaction, :second_signature) do
      transaction = Map.put(transaction, :sign_signature, transaction.second_signature)
    end

    case transaction.type do
      @second_signature_registration ->
        recipient_id = EcKey.public_key_to_address(transaction.sender_public_key)
        transaction = Map.put(transaction, :recipient_id, recipient_id)

      @vote ->
        recipient_id = EcKey.public_key_to_address(transaction.sender_public_key)
        transaction = Map.put(transaction, :recipient_id, recipient_id)

      @multi_signature_registration ->
        keysgroup = transaction.asset.multisignature.keysgroup
          |> Enum.map(fn(key) ->
              if String.starts_with?(key, "+"), do: key, else: "+" <> key
            end)

        transaction = Kernel.put_in(transaction, [:asset, :multisignature, :keysgroup], keysgroup)

      _ ->
        true
    end

    if Map.has_key?(transaction, :vendor_field_hex) and byte_size(transaction.vendor_field_hex) > 0  do
      vendor_field = Base.decode16!(transaction.vendor_field_hex, case: :lower)
      transaction = Map.put(transaction, :vendor_field, vendor_field)
    end

    if !Map.has_key?(transaction, :id) do
      id = Crypto.get_id(transaction)
      transaction = Map.put(transaction, :id, id)
    end

    transaction
  end

  defp calc_signature_size(hex) do
    hex
      |> Integer.parse(16)
      |> Tuple.to_list
      |> List.first
      |> (&(&1 + 2)).()
      |> (&(&1 * 2)).()
  end

end
