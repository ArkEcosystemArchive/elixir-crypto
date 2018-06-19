defmodule ArkCrypto.Transactions.Transaction do
  alias ArkCrypto.Utils.{Base58Check, EcKey}
  alias ArkCrypto.Transactions.Enums.Types

  @delegate Types.delegate_registration
  @multisignature Types.multi_signature_registration
  @second_signature Types.second_signature_registration
  @transfer Types.transfer
  @vote Types.vote

  @spec transaction_to_params(Map.t()) :: Map.t()
  def transaction_to_params(transaction) do
    valid_param_keys = [:amount, :fee, :id, :signature, :timestamp, :type]

    sign_signature =
      if transaction[:sign_signature] do
        %{ :signSignature => transaction[:sign_signature] }
      else
        %{}
      end

    transformed = %{
      :recipientId => transaction[:recipient_id],
      :vendorField => transaction[:vendor_field],
      :senderPublicKey => transaction[:sender_public_key]
    }

    asset = get_asset(transaction)

    transaction
    |> Map.take(valid_param_keys)
    |> Map.merge(sign_signature)
    |> Map.merge(transformed)
    |> Map.merge(asset)
  end

  # private

  def add_signatures_and_create_id(
    transaction,
    secret,
    second_secret \\ nil
  ) do
    signature =
      transaction
      |> get_bytes
      |> EcKey.sign(secret)

    transaction =
      transaction
      |> Map.put(:signature, signature)
      |> second_signing(second_secret)

    bytes = get_bytes(transaction, false, false)
    id = :sha256 |> :crypto.hash(bytes) |> Base.encode16 |> String.downcase

    Map.put(transaction, :id, id)
  end

  defp get_asset(%{asset: asset, type: type}) do
    case type do
      @delegate ->
        %{
          :asset => %{
            :delegate => %{
              :username => asset[:delegate][:username],
              :publicKey => asset[:delegate][:public_key]
            }
          }
        }

      @multisignature ->
        %{:asset => asset}

      @second_signature ->
        %{
          :asset => %{
            :signature => %{
              :publicKey => asset[:signature][:public_key]
            }
          }
        }

      @transfer ->
        %{}

      @vote ->
        %{:asset => asset}
    end
  end

  defp get_asset(%{type: type}) do
    get_asset(%{asset: nil, type: type})
  end

  defp get_asset_info(%{asset: asset, type: type}) do
    case type do
      @delegate ->
        asset
        |> Map.get(:delegate)
        |> Map.get(:username)

      @multisignature ->
        ms_asset = asset[:multisignature]
        keysgroup = Enum.join(ms_asset[:keysgroup], "")
        <<ms_asset[:min]>> <> <<ms_asset[:lifetime]>> <> keysgroup

      @second_signature ->
        asset
        |> Map.get(:signature)
        |> Map.get(:public_key)
        |> String.upcase
        |> Base.decode16!

      @transfer ->
        <<>>

      @vote ->
        asset
        |> Map.get(:votes)
        |> Enum.join("")
    end
  end

  defp get_asset_info(%{type: type}) do
    get_asset_info(%{asset: nil, type: type})
  end

  defp get_bytes(
    transaction,
    skip_signature \\ true,
    skip_second_signature \\ true
  ) do
    amount = <<transaction[:amount]::little-64>>
    asset_info = get_asset_info(transaction)
    fee = <<transaction[:fee]::little-64>>
    recipient_id = get_recipient_id(transaction)
    second_signature = get_second_signature(transaction, skip_second_signature)
    sender_public_key = get_sender_public_key(transaction)
    signature = get_signature(transaction, skip_signature)
    timestamp =  <<transaction[:timestamp]::little-32>>
    type = <<transaction[:type]>>
    vendor_field = get_vendor_field(transaction)

    type <>
    timestamp <>
    sender_public_key <>
    recipient_id <>
    vendor_field <>
    amount <>
    asset_info <>
    fee <>
    signature <>
    second_signature
  end

  defp get_recipient_id(%{recipient_id: recipient_id}) do
    Base58Check.decode58check(recipient_id)
  end

  defp get_recipient_id(_transaction) do
    String.duplicate(<<0>>, 21)
  end

  defp get_sender_public_key(%{sender_public_key: sender_public_key}) do
    sender_public_key |> String.upcase |> Base.decode16!
  end

  defp get_second_signature(%{sign_signature: signature}, false)
  when is_bitstring(signature) do
    signature |> String.upcase |> Base.decode16!
  end

  defp get_second_signature(_transaction, _true) do
    <<>>
  end

  defp get_signature(%{signature: signature}, false) do
    signature |> String.upcase |> Base.decode16!
  end

  defp get_signature(_transaction, _true) do
    <<>>
  end

  defp get_vendor_field(%{vendor_field: vf}) do
    vf_length = String.length(vf)

    if vf_length >= 64 do
      String.slice(vf, 0..63)
    else
      vf <> String.duplicate(<<0>>, 64 - vf_length)
    end
  end

  defp get_vendor_field(_) do
    String.duplicate(<<0>>, 64)
  end

  defp second_signing(transaction, nil) do
    transaction
  end

  defp second_signing(transaction, second_secret) do
    sign_signature =
      transaction
      |> get_bytes(false)
      |> EcKey.sign(second_secret)

    Map.put(transaction, :sign_signature, sign_signature)
  end
end
