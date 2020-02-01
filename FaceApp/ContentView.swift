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
            GeometryReader { proxy in
                AboutView(aboutState: self.aboutState)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(x: 0, y: self.aboutState.isAboutBoxShowing ? 0 : -proxy.size.height)

                DropView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .opacity(self.aboutState.isAboutBoxShowing ? 0 : 1.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(aboutState: AboutState())
    }
}
