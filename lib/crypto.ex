defmodule ArkCrypto.Crypto do
  alias ArkCrypto.Transactions.Enums.Types

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
end
