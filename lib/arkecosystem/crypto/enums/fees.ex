defmodule ArkEcosystem.Crypto.Enums.Fees do
  def transfer do
    Application.get_env(:ark_crypto, :transactions)[:transfer_fee]
  end

  def second_signature_registration do
    Application.get_env(:ark_crypto, :transactions)[:second_signature_fee]
  end

  def delegate_registration do
    Application.get_env(:ark_crypto, :transactions)[:delegate_fee]
  end

  def vote do
    Application.get_env(:ark_crypto, :transactions)[:vote_fee]
  end

  def multi_signature_registration do
    Application.get_env(:ark_crypto, :transactions)[:multisignature_base_fee]
  end
end
