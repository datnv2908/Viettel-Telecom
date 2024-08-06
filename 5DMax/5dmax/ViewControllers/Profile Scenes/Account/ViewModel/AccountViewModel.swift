//
//  AccountViewModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject {

    let title: String
    let value: String
    let type: AccountFieldType
    var user: MemberModel? = DataManager.getCurrentMemberModel()

    init(title: String, value: String, type: AccountFieldType) {
        self.title = title
        self.value = value
        self.type = type
    }
}
