defmodule ArkEcosystem.Crypto.Crypto do
  alias ArkEcosystem.Crypto.Utils.Base58Check

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
    0
  end

  def encode58(data) when is_binary data do
    data
      |> Base58Check.encode58check(<<>>)
  end
end
