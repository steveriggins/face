//
//  main.swift
//  face
//
//  Created by Steven W. Riggins on 1/21/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import CodableCSV
import Foundation
import XMLParsing

extension String {
    public func deletingPathExtension() -> String {
        return (self as NSString).deletingPathExtension
    }
}

extension String {
    public func csvToXMLDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let date = dateFormatter.date(from: self) else { return "###ERROR###" }
        dateFormatter.dateFormat = "yyyyMMdd000000.000"
        let xmlDate = dateFormatter.string(from: date)
        return xmlDate
    }
}

struct Transaction: Codable {
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

let outputPath = String(inputPath.deletingPathExtension() + "(fixed).csv")
print(outputPath)
let outputUrl = URL(fileURLWithPath: outputPath)
let headers = ["Date", "Note", "Payee", "Category", "Amount"]

let encoder = CSVEncoder()
encoder.headers = headers

do {
    let outputData = try encoder.encode(fixedTransactions)
    try outputData.write(to: outputUrl)
} catch {
    print("Ooops! \(error)")
}

// XML

struct STMTTRN: Codable {
    let TRNTYPE: String
    let DTPOSTED: String
    let DTUSER: String
    let TRNAMT: String
    var NAME: String
    
    init(transaction: Transaction) {
        self.DTPOSTED = transaction.date.csvToXMLDate()
        self.DTUSER = transaction.date.csvToXMLDate()
        self.NAME = transaction.merchant
        self.TRNAMT = transaction.amount
        self.TRNTYPE = transaction.type.lowercased() == "purchase" ? "DEBIT" : "CREDIT"
    }
}

struct BANKTRANLIST: Codable {
    let STMTTRN: [STMTTRN]
}

struct CCSTMTRS: Codable {
    let BANKTRANLIST: BANKTRANLIST

}

struct CCSTMTTRNRS: Codable {
    let CCSTMTRS: CCSTMTRS
}

struct CREDITCARDMSGSRSV1: Codable {
    let CCSTMTTRNRS: CCSTMTTRNRS
}

struct OFX: Codable {
    let CREDITCARDMSGSRSV1: CREDITCARDMSGSRSV1
}


let outputXMLPath = String(inputPath.deletingPathExtension() + ".ofx")
let outputXMLUrl = URL(fileURLWithPath: outputXMLPath)

var xmlTransactions = [STMTTRN]()
for transaction in fixedTransactions {
    xmlTransactions.append(STMTTRN(transaction: transaction))
}

let ofx = OFX(CREDITCARDMSGSRSV1: CREDITCARDMSGSRSV1(CCSTMTTRNRS: CCSTMTTRNRS(CCSTMTRS: CCSTMTRS(BANKTRANLIST: BANKTRANLIST(STMTTRN: xmlTransactions)))))

do {
    let returnData = try XMLEncoder().encode(ofx, withRootKey: "OFX")
    let stringData = """
<?xml version="1.0" encoding="utf-8" ?>
<?OFX OFXHEADER="200" VERSION="202" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>

""" + String(data: returnData, encoding: .utf8)!
    let xmlData = stringData.data(using: .utf8)!
    try xmlData.write(to: outputXMLUrl)

} catch {
    print("XML Error: \(error)")
}
