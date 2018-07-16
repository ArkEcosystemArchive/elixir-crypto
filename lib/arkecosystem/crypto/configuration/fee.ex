defmodule ArkEcosystem.Crypto.Configuration.Fee do
  alias ArkEcosystem.Crypto.Configuration.Configuration
  alias ArkEcosystem.Crypto.Enums.Fees
  alias ArkEcosystem.Crypto.Enums.Types

  @transfer Types.transfer()
  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()
  @ipfs Types.ipfs()
  @timelock_transfer Types.timelock_transfer()
  @multi_payment Types.multi_payment()
  @delegate_resignation Types.delegate_resignation()

  def get(type) when is_integer(type) do
    type |> type_to_atom |> get
  end

  def get(type) when is_atom(type) do
    fee = Configuration.get_value(type)

    if is_nil(fee) do
      apply(Fees, type, [])
    else
      fee
    end
  end

  def set(type, fee) do
    Configuration.set_value(type, fee)
  end

  defp type_to_atom(type) do
    case type do
      @transfer -> :transfer
      @second_signature_registration -> :second_signature_registration
      @delegate_registration -> :delegate_registration
      @vote -> :vote
      @multi_signature_registration -> :multi_signature_registration
      @ipfs -> :ipfs
      @timelock_transfer -> :timelock_transfer
      @multi_payment -> :multi_payment
      @delegate_resignation -> :delegate_resignation
    end
  end
end
