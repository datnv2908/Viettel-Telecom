//
//  AuditDataManager.swift
//  5dmax
//
//  Created by Huy Nguyen on 2/23/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    //mark: Shared Instance
    static let sharedInstance: Singleton = {
        let instance = Singleton()
        return instance
    }()

    //mark: Local Variable
}
