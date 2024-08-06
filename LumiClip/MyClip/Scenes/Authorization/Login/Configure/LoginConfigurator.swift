//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import UIKit

class LoginConfigurator: NSObject {

    class func viewController(_ completion: LoginManagerCompletionHandler? = nil) -> LoginViewController {

        let view = LoginViewController.initWithNib()
        let presenter = LoginPresenter(completion)
        let viewModel = LoginViewModel()
        let wireFrame = LoginWireFrame()
        let interactor = LoginInteractor()

        presenter.viewModel = viewModel
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.view = view

        wireFrame.viewController = view
        view.presenter = presenter
        view.viewModel = viewModel

        interactor.presenter = presenter
        wireFrame.presenter = presenter
        return view
    }
}

//===================== VIEW ============================
//=======================================================
// MARK: 
// MARK: VIEW
protocol LoginViewControllerInput: class {
    func doRefreshView()
    func showCaptcha()
}

protocol LoginViewControllerOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func performLogin(username: String, password: String, captcha: String?)
    func performCancelLogin(_ sender: Any)
    func performLoginFB(_ sender: Any)
    func performLoginGG(_ sender: Any)
    func performAutoLogin(_ sender: Any)
}

//========================= VIEW MODEL =================
//=======================================================
// MARK: 
// MARK: VIEW MODEL
protocol LoginViewModelInput: class {
    func doUpdateImageCaptcha(image: UIImage)
}

protocol LoginViewModelOutput: class {

    func getTitle() -> String?
    var captchaImage: UIImage {get set}
}

//==================== INTERACTOR =======================
//=======================================================
// MARK: 
// MARK: INTERACTOR
protocol LoginInteractorInput: class {
    func authorize(type: LoginType,
                   username: String?,
                   password: String?,
                   captcha: String?,
                   accessToken: String?,
                   completion: @escaping (Result<APIResponse<MemberModel>>) -> (Void))
}

protocol LoginInteractorOutput: class {
}

//==================== WIRE FRAME =======================
//=======================================================
// MARK: 
// MARK: WIRE FRAME
protocol LoginWireFrameInput: class {
    func doShowHud()
    func doHideHud()
    func doShowToast(message: String)
    func doShowAlert(title: String, message: String)
    func dismiss()
     func setTheme()
}

protocol LoginWireFrameOutput: class {
}
