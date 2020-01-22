//
//  main.swift
//  face
//
//  Created by Steven W. Riggins on 1/21/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import CodableCSV
import Foundation

struct Transaction: Codable {
    let date: String
    let description: String
    let merchant: String
    let category: String
    var amount: String

    init(from decoder: Decoder) throws {
        var row = try decoder.unkeyedContainer()
        self.date = try row.decode(String.self)
        let _ = try row.decode(String.self) // Clearing date column that I want to ignore
        self.description = try row.decode(String.self)
        self.merchant = try row.decode(String.self)
        self.category = try row.decode(String.self)
        let _ = try row.decode(String.self) // Type column that I want to ignore
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

struct AppleCardTransactions: Decodable {
    let transactions: [Transaction]
}

if CommandLine.arguments.count != 2 {
    print("Needs a path")
}

// Argument 0 is the path to the binary
let inputPath = CommandLine.arguments[1]
let inputUrl = URL(fileURLWithPath: inputPath)

guard let data = try? Data(contentsOf: inputUrl) else {
    print("Could not create a file from: \(inputPath)")
    exit(1)
}

let decoder = CSVDecoder()
decoder.delimiters = (.comma, .lineFeed)
decoder.headerStrategy = .firstLine
var transactions = try decoder.decode([Transaction].self, from: data)

/// Fix them up

var fixedTransactions: [Transaction] = []
for transaction in transactions {
    var fixedTransaction = transaction
    let amount = fixedTransaction.amount
    var fixedAmount = ""
    if amount.first == "-" {
        fixedAmount = String(amount.dropFirst())
    } else {
        fixedAmount = "-" + amount
    }
    fixedTransaction.amount = fixedAmount
    fixedTransactions.append(fixedTransaction)
}

/// Write it out

let outputPath = inputPath + ".fixed.csv"
let outputUrl = URL(fileURLWithPath: outputPath)
let headers = ["Date", "Note", "Payee", "Category", "Amount"]

let encoder = CSVEncoder()
encoder.headers = headers

do {
    let outputData = try encoder.encode(fixedTransactions)
    try outputData.write(to: outputUrl)
} catch (let error) {
    print("Ooops! \(error)")
}
