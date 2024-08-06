//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class LoginViewModel: NSObject {
    var title: String? = "LoginViewController"
    var isNeedCaptcha = false
    var captchaImage: UIImage = UIImage()
    var password: String = ""
    var captcha: String = ""
}

extension LoginViewModel: LoginViewModelInput {
    func doUpdateImageCaptcha(image: UIImage) {
        captchaImage = image
    }
}

extension LoginViewModel: LoginViewModelOutput {
    func getTitle() -> String? {
        return title
    }
}
