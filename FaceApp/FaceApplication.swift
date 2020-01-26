//
//  FaceApplication.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Cocoa
import Foundation

@objc(FaceApplication) @objcMembers
public class FaceApplication: NSApplication {
    @IBAction public override func orderFrontStandardAboutPanel(options optionsDictionary: [NSApplication.AboutPanelOptionKey: Any] = [:]) {
        guard let delly = delegate as? AppDelegate else {
            super.orderFrontStandardAboutPanel(options: optionsDictionary)
            return
        }

        delly.aboutState.isAboutBoxShowing = !delly.aboutState.isAboutBoxShowing
    }
}
