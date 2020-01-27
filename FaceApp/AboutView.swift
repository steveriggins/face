//
//  AboutView.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @ObservedObject var aboutState: AboutState
    @State var isFlipped = false

    var body: some View {
        VStack(alignment: .center) {
            Text("About FACE")
                .font(.largeTitle)
                .padding(.top, 15)
            Image("Avatar")
                .resizable()
                .frame(width: 128, height: 128, alignment: .center)
                .border(Color.white, width: 2)
                .padding(.bottom, 15)
            Text("FACE - Fix Apple Card Exports")
            Text("Copyright © 2020 Steven W. Riggins. All rights reserved.")
            Button(action: {
                self.aboutState.isAboutBoxShowing = false
            }) {
                Text("Close")
            }
            .padding(15)
        }
        .rotation3DEffect(Angle(degrees: aboutState.isEasterEggEnabled ? 180 : 0), axis: (x: 0, y: 1.0, z: 0))
        .animation(.spring())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(true)
        .contentShape(Rectangle())
        .onTapGesture {
            self.aboutState.isAboutBoxShowing = false
        }
    }
}

struct AboutFace_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(aboutState: AboutState())
    }
}
