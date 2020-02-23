//
//  main.swift
//  face
//
//  Created by Steven W. Riggins on 1/21/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import FaceLib
import Foundation

if CommandLine.arguments.count != 2 {
    print("Needs a path")
}

// Argument 0 is the path to the binary
let inputPath = CommandLine.arguments[1]
let inputURL = URL(fileURLWithPath: inputPath)

let face = Face()

face.convertAppleCardToOFX(inputURL)
