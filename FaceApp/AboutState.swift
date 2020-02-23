//
//  AboutState.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/26/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation
import SwiftUI

public class AboutState: ObservableObject {
    @Published public var isAboutBoxShowing = false
    @Published public var isEasterEggEnabled = false
}
