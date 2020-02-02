//
//  DropVIew.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/26/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import FaceLib
import SwiftUI

struct DropView: View, DropDelegate {
    @State private var targetAcquired = false

    var body: some View {
        ZStack {
            VStack {
                Text("Drag Apple Card .csv files here")
            }
            if self.targetAcquired {
                Rectangle()
                    .strokeBorder()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [kUTTypeFileURL as String], delegate: self)
    }

    func validateDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [kUTTypeFileURL as String]).first else { return false }

        print(info.hasItemsConforming(to: [kUTTypeCommaSeparatedText as String]))
        var isCSV = true
        itemProvider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            isCSV = url.pathExtension == "csv"
        }

        return isCSV
    }

    func dropEntered(info: DropInfo) {
        self.targetAcquired = true
    }

    func dropExited(info: DropInfo) {
        self.targetAcquired = false
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [kUTTypeFileURL as String]).first else { return false }

        itemProvider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            Face().convertAppleCardToCSV(url)
Face().convertAppleCardToOFX(url)
        }

        return true
    }
}

struct DropVIew_Previews: PreviewProvider {
    static var previews: some View {
        DropView()
    }
}
