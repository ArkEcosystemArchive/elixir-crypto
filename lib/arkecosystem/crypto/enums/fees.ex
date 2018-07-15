defmodule ArkEcosystem.Crypto.Enums.Fees do

  def transfer do
    Application.get_env(:ark_crypto, :transactions)[:transfer_fee] || 10000000
  end

  def second_signature_registration do
    Application.get_env(:ark_crypto, :transactions)[:second_signature_fee] || 500000000
  end

  def delegate_registration do
    Application.get_env(:ark_crypto, :transactions)[:delegate_fee] || 2500000000
  end

  def vote do
    Application.get_env(:ark_crypto, :transactions)[:vote_fee] || 100000000
  end

  def multi_signature_registration do
    Application.get_env(:ark_crypto, :transactions)[:multisignature_base_fee] || 500000000
  end

  def ipfs do
    Application.get_env(:ark_crypto, :transactions)[:ipfs] || 0
  end

  def timelock_transfer do
    Application.get_env(:ark_crypto, :transactions)[:timelock_transfer] || 0
  end

  def multi_payment do
    Application.get_env(:ark_crypto, :transactions)[:multi_payment] || 0
  end

  def delegate_resignation do
    Application.get_env(:ark_crypto, :transactions)[:delegate_resignation] || 0
  end

end
