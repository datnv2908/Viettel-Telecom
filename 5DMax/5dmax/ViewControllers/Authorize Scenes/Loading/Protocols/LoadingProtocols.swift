//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingViewProtocol: class {
    var presenter: LoadingPresenterProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
}

protocol LoadingWireFrameProtocol: class {
    static func presentLoadingModule(fromWindow window: UIWindow?)
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
}

protocol LoadingPresenterProtocol: class {
    var view: LoadingViewProtocol? { get set }
    var interactor: LoadingInteractorInputProtocol? { get set }
    var wireFrame: LoadingWireFrameProtocol? { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    func viewDidLoad()
}

protocol LoadingInteractorOutputProtocol: class {
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
}

protocol LoadingInteractorInputProtocol: class {
    weak var presenter: LoadingInteractorOutputProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> INTERACTOR
    */
    func performRefreshToken(_ completion:@escaping (Result<Any>) -> Void)
    func performAutoLogin(_ completion:@escaping (Result<Any>) -> Void)
}
