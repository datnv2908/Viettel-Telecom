//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class LoadingWireFrame: LoadingWireFrameProtocol {
    class func presentLoadingModule(fromWindow window: UIWindow?) {
        // Generating module components
        let view: LoadingViewProtocol = LoadingView()
        let presenter: LoadingPresenterProtocol & LoadingInteractorOutputProtocol = LoadingPresenter()
        let interactor: LoadingInteractorInputProtocol = LoadingInteractor()
        let wireFrame: LoadingWireFrameProtocol = LoadingWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter

        window?.rootViewController = view as? UIViewController
    }
}
