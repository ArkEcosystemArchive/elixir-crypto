# Ark Elixir - Crypto

<p align="center">
    <img src="https://github.com/ArkEcosystem/elixir-crypto/blob/master/banner.png" />
</p>

> A simple Elixir Cryptography Implementation for the Ark Blockchain.

[![Build Status](https://img.shields.io/travis/ArkEcosystem/elixir-crypto/master.svg?style=flat-square)](https://travis-ci.org/ArkEcosystem/elixir-crypto)
[![Latest Version](https://img.shields.io/github/release/ArkEcosystem/elixir-crypto.svg?style=flat-square)](https://github.com/ArkEcosystem/elixir-crypto/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## TO-DO

### AIP11 Serialization
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration
- [x] IPFS
- [x] Timelock Transfer
- [x] Multi Payment
- [x] Delegate Resignation

### AIP11 Deserialization
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration
- [x] IPFS
- [x] Timelock Transfer
- [x] Multi Payment
- [x] Delegate Resignation

### Transaction Signing
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration

### Transaction Verifying
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration

### Transaction
- [x] getId
- [x] sign
- [x] secondSign
- [x] verify
- [x] secondVerify
- [x] parseSignatures
- [ ] serialize
- [ ] deserialize
- [x] toBytes
- [ ] toArray
- [ ] toJson

### Message
- [x] sign
- [x] verify
- [ ] toArray
- [ ] toJson

### Address
- [x] fromPassphrase
- [x] fromPublicKey
- [x] fromPrivateKey
- [ ] validate

### Private Key
- [x] fromPassphrase
- [ ] fromHex

### Public Key
- [x] fromPassphrase
- [ ] fromHex

### WIF
- [ ] fromPassphrase

### Configuration
- [x] getNetwork
- [x] setNetwork
- [x] getFee
- [x] setFee

### Slot
- [x] time
- [x] epoch

### Networks (Mainnet, Devnet & Testnet)
- [x] epoch
- [x] version
- [x] nethash
- [x] wif

## Installation

The package can be installed by adding `ark_crypto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ark_crypto, "~> 0.1.0"}]
end
```

## Testing

``` bash
$ mix test
```

## Security

If you discover a security vulnerability within this package, please send an e-mail to security@ark.io. All security vulnerabilities will be promptly addressed.

## Credits

- [Brian Faust](https://github.com/faustbrian)
- [Christopher Wang](https://github.com/christopherjwang) **Initial Cryptography Implementation**
- [All Contributors](../../../../contributors)

## License

[MIT](LICENSE) © [ArkEcosystem](https://ark.io)
