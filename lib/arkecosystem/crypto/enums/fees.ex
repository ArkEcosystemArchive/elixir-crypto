defmodule ArkEcosystem.Crypto.Enums.Fees do
  def transfer do
    Application.get_env(:arkecosystem_crypto, :transactions)[:transfer_fee] || 10_000_000
  end

  def second_signature_registration do
    Application.get_env(:arkecosystem_crypto, :transactions)[:second_signature_fee] || 500_000_000
  end

  def delegate_registration do
    Application.get_env(:arkecosystem_crypto, :transactions)[:delegate_fee] || 2_500_000_000
  end

  def vote do
    Application.get_env(:arkecosystem_crypto, :transactions)[:vote_fee] || 100_000_000
  end

  def multi_signature_registration do
    Application.get_env(:arkecosystem_crypto, :transactions)[:multisignature_base_fee] ||
      500_000_000
  end

  def ipfs do
    Application.get_env(:arkecosystem_crypto, :transactions)[:ipfs] || 0
  end

  def timelock_transfer do
    Application.get_env(:arkecosystem_crypto, :transactions)[:timelock_transfer] || 0
  end

  def multi_payment do
    Application.get_env(:arkecosystem_crypto, :transactions)[:multi_payment] || 0
  end

  def delegate_resignation do
    Application.get_env(:arkecosystem_crypto, :transactions)[:delegate_resignation] || 0
  end
end
