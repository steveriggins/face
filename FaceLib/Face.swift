//
//  Face.swift
//  Fix Apple Card Export
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import CodableCSV
import Foundation
import XMLParsing

public class Face {
    
    public init() { }

    public func convertAppleCardToCSV(_ inputURL: URL) {
        let inputPath = inputURL.path
        let outputPath = String(inputPath.deletingPathExtension() + "(fixed).csv")
        let outputURL = URL(fileURLWithPath: outputPath)

        let transactions = importAppleCardTransactions(from: inputURL)
        exportCSV(transactions, to: outputURL)
    }
    
    public func convertAppleCardToOFX(_ inputURL: URL) {
        let inputPath = inputURL.path
        let outputPath = String(inputPath.deletingPathExtension() + ".ofx")
        let outputURL = URL(fileURLWithPath: outputPath)
        
        let transactions = importAppleCardTransactions(from: inputURL)
        exportOFX(transactions, outputURL: outputURL)
    }

    private func importAppleCardTransactions(from inputURL: URL) -> AppleCardTransactions {
        guard let data = try? Data(contentsOf: inputURL) else {
            print("Could not create a file from: \(inputURL)")
            exit(1)
        }

        let decoder = CSVDecoder()
        decoder.delimiters = (.comma, .lineFeed)
        decoder.headerStrategy = .firstLine

        guard let transactions = try? decoder.decode([AppleCardTransaction].self, from: data) else { return [] }

        /// Fix them up

        var fixedTransactions: [AppleCardTransaction] = []
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

        return fixedTransactions
    }

    private func exportCSV(_ transactions: AppleCardTransactions, to outputURL: URL) {
        let headers = ["Date", "Note", "Payee", "Category", "Amount"]

        let encoder = CSVEncoder()
        encoder.headers = headers

        do {
            let outputData = try encoder.encode(transactions)
            try outputData.write(to: outputURL)
        } catch {
            print("Ooops! \(error)")
        }
    }

    private func exportOFX(_ transactions: AppleCardTransactions, outputURL: URL) {
        var xmlTransactions = [StatementTransaction]()
        for transaction in transactions {
            xmlTransactions.append(StatementTransaction(transaction: transaction))
        }

        let ofx = OFX(value: CREDITCARDMSGSRSV1(value: CCSTMTTRNRS(value: CCSTMTRS(value: BANKTRANLIST(value: xmlTransactions)))))

        do {
            let returnData = try XMLEncoder().encode(ofx, withRootKey: "OFX")
            let stringData = """
            <?xml version="1.0" encoding="utf-8" ?>
            <?OFX OFXHEADER="200" VERSION="202" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>

            """ + String(data: returnData, encoding: .utf8)!
            let xmlData = stringData.data(using: .utf8)!
            try xmlData.write(to: outputURL)

        } catch {
            print("XML Error: \(error)")
        }
    }
}
