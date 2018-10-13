// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Bitcoin blockchain.
///
/// Bitcoin-based blockchains should inherit from this class.
open class Bitcoin: Blockchain {
    /// SLIP-044 coin type.
    override open var coinType: SLIP.CoinType {
        return .bitcoin
    }

    override open var coinPurpose: Purpose {
        return .bip84
    }

    /// Public key hash address prefix.
    open var publicKeyHashAddressPrefix: UInt8 {
        return 0x00
    }

    /// Private key prefix.
    open var privateKeyPrefix: UInt8 { return 0x80 }

    /// Pay to script hash (P2SH) address prefix.
    open var payToScriptHashAddressPrefix: UInt8 {
        return 0x05
    }

    open override func address(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.bitcoinBech32Address()
    }

    open override func address(string: String) -> Address? {
        if let bech32Address = BitcoinSegwitAddress(string: string) {
            return bech32Address
        } else {
            return BitcoinAddress(string: string)
        }
    }

    open override func address(data: Data) -> Address? {
        if let bech32Address = BitcoinSegwitAddress(data: data) {
            return bech32Address
        } else {
            return BitcoinAddress(data: data)
        }
    }

    open func compatibleAddress(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.compatibleBitcoinAddress(prefix: payToScriptHashAddressPrefix)
    }

    open func compatibleAddress(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open func compatibleAddress(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }

    open func legacyAddress(for publicKey: PublicKey, prefix: UInt8) -> Address {
        return publicKey.compressed.legacyBitcoinAddress(prefix: prefix)
    }

    open func legacyAddress(string: String) -> Address? {
        return BitcoinAddress(string: string)
    }

    open func legacyAddress(data: Data) -> Address? {
        return BitcoinAddress(data: data)
    }
}

public final class Litecoin: Bitcoin {
    public override var coinType: SLIP.CoinType {
        return .litecoin
    }

    public override var payToScriptHashAddressPrefix: UInt8 {
        return 0x32
    }
}

public final class Dash: Bitcoin {
    public override var coinType: SLIP.CoinType {
        return .dash
    }

    override open var coinPurpose: Purpose {
        return .bip44
    }

    public override var payToScriptHashAddressPrefix: UInt8 {
        return 0x4C
    }
}
