# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ark_crypto, :transactions,
  epoch: 1490101200,
  transfer_fee: 10000000,
  second_signature_fee: 500000000,
  delegate_fee: 2500000000,
  vote_fee: 100000000,
  multisignature_base_fee: 500000000
