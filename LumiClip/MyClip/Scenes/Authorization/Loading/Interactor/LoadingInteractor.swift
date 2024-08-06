//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation

class LoadingInteractor: LoadingInteractorInputProtocol {
    weak var presenter: LoadingInteractorOutputProtocol?
    let service = UserService()
    init() {
    }

    //mark: -- LoadingInteractorInputProtocol    
    func authorize(type: LoginType,
                   username: String?,
                   password: String?,
                   captcha: String?,
                   accessToken: String?,
                   completion: @escaping (Result<APIResponse<MemberModel>>) -> (Void)) {
        service.authorize(type: type, username: username, password: password, captcha: captcha, accessToken: accessToken) { (result) -> (Void) in
            completion(result)
        }
    }
}
