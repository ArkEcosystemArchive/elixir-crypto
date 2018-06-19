defmodule ArkCrypto.Transactions.Enums.Types do
  @transfer 0
  @second_signature_registration 1
  @delegate_registration 2
  @vote 3
  @multi_signature_registration 4

  def transfer, do: @transfer
  def second_signature_registration, do: @second_signature_registration
  def delegate_registration, do: @delegate_registration
  def vote, do: @vote
  def multi_signature_registration, do: @multi_signature_registration
end
