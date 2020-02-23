//
//  FilePresenter.swift
//  FaceLib
//
//  Created by Steven W. Riggins on 1/25/20.
//  Copyright © 2020 Steven W. Riggins. All rights reserved.
//

import Foundation

class FilePresenter: NSObject, NSFilePresenter {
    var presentedItemURL: URL?
    
    var primaryPresentedItemURL: URL?
    
    var presentedItemOperationQueue: OperationQueue {
        OperationQueue.main
    }
}
