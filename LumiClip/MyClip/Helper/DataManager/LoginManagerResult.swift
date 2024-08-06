//
//  LoginManagerResult.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class LoginManagerResult: NSObject {
    var isCancelled: Bool = true
    var memberModel: MemberModel?
    init(_ canclled: Bool, _ model: MemberModel?) {
        isCancelled = canclled
        memberModel = model
    }
}
