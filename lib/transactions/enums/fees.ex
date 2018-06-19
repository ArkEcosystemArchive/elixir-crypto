defmodule ArkCrypto.Transactions.Enums.Fees do
  @transfer Application.get_env(:ark_crypto, :transactions)[:transfer_fee]
  @second_signature_registration Application.get_env(:ark_crypto, :transactions)[:second_signature_fee]
  @delegate_registration Application.get_env(:ark_crypto, :transactions)[:delegate_fee]
  @vote Application.get_env(:ark_crypto, :transactions)[:vote_fee]
  @multi_signature_registration Application.get_env(:ark_crypto, :transactions)[:multisignature_base_fee]

  def transfer, do: @transfer
  def second_signature_registration, do: @second_signature_registration
  def delegate_registration, do: @delegate_registration
  def vote, do: @vote
  def multi_signature_registration, do: @multi_signature_registration
end
