//
//  OFX.swift
//  face
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

typealias OFXTransactions = [OFXTransaction]

struct OFXTransaction: Codable {
    let TRNTYPE: String
    let DTPOSTED: String
    let DTUSER: String
    let TRNAMT: String
    var NAME: String

    init(transaction: Transaction) {
        self.DTPOSTED = transaction.datePosted
        self.DTUSER = transaction.datePosted
        self.NAME = transaction.payee
        self.TRNAMT = transaction.amount
        switch transaction.type {
        case .payment:
            self.TRNTYPE = "CREDIT"
        case .purchase:
            self.TRNTYPE = "DEBIT"
        }
    }
}

struct BANKTRANLIST: Codable {
    let value: [OFXTransaction]

    enum CodingKeys: String, CodingKey {
        case value = "STMTTRN"
    }
}

struct CCSTMTRS: Codable {
    let value: BANKTRANLIST

    enum CodingKeys: String, CodingKey {
        case value = "BANKTRANLIST"
    }
}

struct CCSTMTTRNRS: Codable {
    let value: CCSTMTRS

    enum CodingKeys: String, CodingKey {
        case value = "CCSTMTRS"
    }
}

struct CREDITCARDMSGSRSV1: Codable {
    let value: CCSTMTTRNRS

    enum CodingKeys: String, CodingKey {
        case value = "CCSTMTTRNRS"
    }
}

struct OFX: Codable {
    let value: CREDITCARDMSGSRSV1

    enum CodingKeys: String, CodingKey {
        case value = "CREDITCARDMSGSRSV1"
    }
}
