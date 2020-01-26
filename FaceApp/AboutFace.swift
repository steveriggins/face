//
//  AboutFace.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import SwiftUI

public class AboutState: ObservableObject {
    @Published public var aboutFace = false
}

struct AboutFace: View {
    @ObservedObject var aboutState: AboutState
    @State var isFlipped = false

    var body: some View {
        VStack(alignment: .center) {
            Text("FACE - Fix Apple Card Exports")
            Text("Copyright © 2020 Steven W. Riggins. All rights reserved.")
        }
        .rotation3DEffect(Angle(degrees: isFlipped ? 180 : 0), axis: (x: 0, y: 1.0, z: 0))
        .animation(.spring())
    }
}

struct AboutFace_Previews: PreviewProvider {
    static var previews: some View {
        AboutFace(aboutState: AboutState())
    }
}
