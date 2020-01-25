//
//  String+Extensions.swift
//  face
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

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
