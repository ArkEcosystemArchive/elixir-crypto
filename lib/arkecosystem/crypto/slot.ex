defmodule ArkEcosystem.Crypto.Slot do

  def get_time do
    epoch = ArkEcosystem.Crypto.Configuration.Network.get.epoch
      |> DateTime.from_iso8601
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> List.first

    DateTime.diff(DateTime.utc_now, epoch)
  end

end
