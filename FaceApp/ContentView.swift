//
//  ContentView.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/24/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var aboutState: AboutState

    var body: some View {
        ZStack {
            if aboutState.isAboutBoxShowing {
                AboutView(aboutState: aboutState)
            } else {
                DropView()
            }
        }
        .animation(.spring())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(aboutState: AboutState())
    }
}
