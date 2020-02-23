//
//  FaceWindow.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Cocoa
import Foundation

@objc @objcMembers
class FaceWindow: NSWindow {
    /// Stop that incessant beeping, unless a command key is pressed
    public override func keyDown(with event: NSEvent) {
        if event.modifierFlags.contains(.command) {
            super.keyDown(with: event)
        }
    }

    public override func flagsChanged(with event: NSEvent) {
        guard let delly = NSApplication.shared.delegate as? AppDelegate else {
            super.flagsChanged(with: event)
            return
        }
        delly.aboutState.isEasterEggEnabled = event.modifierFlags.contains(.option)
        super.flagsChanged(with: event)
    }
}
