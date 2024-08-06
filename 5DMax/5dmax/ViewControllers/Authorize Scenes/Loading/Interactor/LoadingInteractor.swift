//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation

class LoadingInteractor: LoadingInteractorInputProtocol {
    weak var presenter: LoadingInteractorOutputProtocol?
    var service: LoginInteractor
    init() {
        service = LoginInteractor()
    }

    //mark: -- LoadingInteractorInputProtocol
    func performRefreshToken(_ completion: @escaping (Result<Any>) -> Void) {
        service.performRefreshAccessToken(done: { () -> (Void) in
            completion(Result.success(true))
        }) { (error) -> (Void) in
            completion(Result.failure(error ?? NSError()))
        }
    }

    func performAutoLogin(_ completion: @escaping (Result<Any>) -> Void) {
        service.performLogin3G(done: { () -> (Void) in
            completion(Result.success(true))
        }) { (error) -> (Void) in
            completion(Result.failure(error ?? NSError()))
        }
    }
}
