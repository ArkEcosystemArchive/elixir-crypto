defmodule ArkEcosystem.Crypto.Utils.Slot do
  def get_time do
    DateTime.diff(DateTime.utc_now(), get_epoch())
  end

  def get_epoch do
    ArkEcosystem.Crypto.Configuration.Network.get().epoch
    |> DateTime.from_iso8601()
    |> Tuple.delete_at(0)
    |> Tuple.to_list()
    |> List.first()
  end
end
