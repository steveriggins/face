//
//  AppDelegate.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/24/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    var aboutState = AboutState()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(aboutState: aboutState)

        // Create the window and set the content view.
        window = FaceWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 360),
            styleMask: [.titled, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.title = "FACE, THE FINAL FRONTIER"
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
}
