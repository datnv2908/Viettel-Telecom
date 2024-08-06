//
//  LoginViewModel.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {

    var fbToken: String     = ""
    var phone: String       = ""
    var pass: String        = ""
    var captcha: String     = ""
    var captchaPlaceHolder: String? = String.nhap_ma_captcha
    var refreshToken: String = ""
    var imgCapchar: UIImage?
    var isNeedCapcha: Bool = false
}
