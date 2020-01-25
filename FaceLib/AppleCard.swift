//
//  AppleCard.swift
//  face
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

typealias AppleCardTransactions = [AppleCardTransaction]

struct AppleCardTransaction: Codable {
    let date: String
    let description: String
    let merchant: String
    let category: String
    let type: String
    var amount: String

    init(from decoder: Decoder) throws {
        var row = try decoder.unkeyedContainer()
        self.date = try row.decode(String.self)
        _ = try row.decode(String.self) // Clearing date column that I want to ignore
        self.description = try row.decode(String.self)
        self.merchant = try row.decode(String.self)
        self.category = try row.decode(String.self)
        self.type = try row.decode(String.self)
        self.amount = try row.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var row = encoder.unkeyedContainer()
        try row.encode(self.date)
        try row.encode(self.description)
        try row.encode(self.merchant)
        try row.encode(self.category)
        try row.encode(self.amount)
    }
}

