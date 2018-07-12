defmodule ArkEcosystem.Crypto.Configuration.Network do
  alias ArkEcosystem.Crypto.Configuration.Configuration
  alias ArkEcosystem.Crypto.Networks

  def version() do
    get().version |> Base.decode16!(case: :lower)
  end

  def get() do
    network = Configuration.get_value(:network)
    if is_nil(network) do
      set(%Networks.Mainnet{})
    else
      network
    end
  end

  def set(network) do
    struct = Kernel.struct(network)
    Configuration.set_value(:network, struct)
  end

end
