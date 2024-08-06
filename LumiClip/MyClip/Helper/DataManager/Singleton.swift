//
//  AuditDataManager.swift
//  MyClip
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
    var isAcceptLossData: Bool = false
    var isConnectedInternet: Bool = false
    
    var totalAPIError: Int = 0
    var totalAPISuccess: Int = 0
    var totalAPICallTimes: Int = 0
    var totalAPICallDuration: Double = 0
    var isHasVideo: Int = 0
    var userStatus: Int = 0
}
