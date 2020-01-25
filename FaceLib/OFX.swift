//
//  OFX.swift
//  face
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

struct StatementTransaction: Codable {
    let TRNTYPE: String
    let DTPOSTED: String
    let DTUSER: String
    let TRNAMT: String
    var NAME: String
    
    init(transaction: AppleCardTransaction) {
        self.DTPOSTED = transaction.date.csvToXMLDate()
        self.DTUSER = transaction.date.csvToXMLDate()
        self.NAME = transaction.merchant
        self.TRNAMT = transaction.amount
        self.TRNTYPE = transaction.type.lowercased() == "purchase" ? "DEBIT" : "CREDIT"
    }
}

struct BANKTRANLIST: Codable {
    let value: [StatementTransaction]

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
