//
//  Transaction.swift
//  FaceLib
//
//  Created by Steven W. Riggins on 2/1/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

typealias Transactions = [Transaction]

enum TransactionType {
    case purchase
    case payment
}

struct Transaction {
    let type: TransactionType
    let datePosted: String /// XML Format 20200101000000.000
    let description: String
    let amount: String
    let payee: String
    let category: String

    /// Apple exports weird data
    /// A positive amount is a purchase
    /// A negative amount is a payment
    /// This initializer will correct that and set a proper type
    /// and normalize the amount
    init(csv: AppleCardCSVWireModel) {
        self.datePosted = csv.date.csvToXMLDate()
        self.payee = csv.merchant
        self.description = csv.description
        if csv.amount.first == "-" {
            self.amount = String(csv.amount.dropFirst())
            self.type = .payment
        } else {
            self.amount = csv.amount
            self.type = .purchase
        }
        self.category = csv.category
    }
}
