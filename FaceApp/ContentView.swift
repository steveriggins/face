//
//  ContentView.swift
//  FaceApp
//
//  Created by Steven W. Riggins on 1/24/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import SwiftUI

struct ContentView: View, DropDelegate {
    var body: some View {
        Text("Drag Apple Card .csv files here")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDrop(of: [kUTTypeFileURL as String], delegate: self)
    }

    func validateDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: ["public.url-name"]).first else { return false }

        print(info.hasItemsConforming(to: [kUTTypeCommaSeparatedText as String]))
        var isCSV = true
        itemProvider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            isCSV = url.pathExtension == "csv"
        }

        return isCSV
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [kUTTypeFileURL as String]).first else { return false }

        itemProvider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            print(url)
            // Do something with the file url
            // remember to dispatch on main in case of a @State change
        }

        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
