//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class PlayerWireFrame: PlayerWireFrameProtocol {

    
    var view: BaseViewController?
    var presenter: PlayerWireFrameOutputProtocol?
    
    static func presentPlayerModule(_ fromView: UIViewController, filmModel: FilmModel, fromNoti : Bool,sendView : Bool) {
        // Generating module components
        let view = PlayerView.initWithNib()
        if let delegate = fromView as? PlayerViewDelegate {
            view.delegate = delegate
        }
        let presenter = PlayerPresenter(fromView, model: filmModel, fromNoti: fromNoti, sendView: sendView )
        let interactor: PlayerInteractorInputProtocol = PlayerInteractor()
        let wireFrame: PlayerWireFrameProtocol = PlayerWireFrame()
        wireFrame.view = view
        wireFrame.presenter = presenter
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        fromView.present(view as! UIViewController, animated: true, completion: nil)
    }

    static func presentPlayerModule(_ fromView: UIViewController, playListModel: PlayListModel,fromNoti : Bool ,sendView : Bool) {
        // Generating module components
        let view = PlayerView.initWithNib()
        if let delegate = fromView as? PlayerViewDelegate {
            view.delegate = delegate
        }
        let presenter = PlayerPresenter(fromView, model: playListModel, fromNoti: fromNoti, sendView: sendView)
        let interactor: PlayerInteractorInputProtocol = PlayerInteractor()
        let wireFrame: PlayerWireFrameProtocol = PlayerWireFrame()
        wireFrame.view = view
        wireFrame.presenter = presenter
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        fromView.present(view as! UIViewController, animated: true, completion: nil)
    }
    
    static func presentPlayerModule(_ fromView: UIViewController, trailer: TrailersModel?, trailerStream: StreamModel, title: String?) {
        // Generating module components
        let view = PlayerView.initWithNib()
        if let delegate = fromView as? PlayerViewDelegate {
            view.delegate = delegate
        }
        
        let presenter = PlayerPresenter(trailer: trailer, withStream: trailerStream, sendView: false)
        presenter.viewModel.filmName = title
        
        let interactor: PlayerInteractorInputProtocol = PlayerInteractor()
        let wireFrame: PlayerWireFrameProtocol = PlayerWireFrame()
        wireFrame.view = view
        wireFrame.presenter = presenter
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        fromView.present(view as! UIViewController, animated: true, completion: nil)
    }
    
    static func presentPlayerModule(_ fromView: UIViewController, trailerStream: StreamModel) {
        // Generating module components
        let view = PlayerView.initWithNib()
        let presenter = PlayerPresenter(trailerStream: trailerStream)
        let interactor: PlayerInteractorInputProtocol = PlayerInteractor()
        let wireFrame: PlayerWireFrameProtocol = PlayerWireFrame()
        wireFrame.view = view
        wireFrame.presenter = presenter
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        fromView.present(view as! UIViewController, animated: true, completion: nil)
    }
    
    //mark: -- PlayerWireFrameProtocol
    func dismissPlayer(_ fromView: PlayerViewProtocol?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.dismiss(animated: true, completion: nil)
    }

    func presentEpisodeList(_ fromView: PlayerViewProtocol?, _ playListModel: PlayListModel) {
        let fromViewController = fromView as! UIViewController
        let viewcontroller = ListEpisodeViewController(playListModel)
        viewcontroller.delegate = fromViewController as? ListEpisodeViewDelegate
        fromViewController.present(viewcontroller, animated: true, completion: nil)
    }

    func showAlert(_ fromView: PlayerViewProtocol?, _ title: String?, _ message: String?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.alertWithTitle(title, message: message)
    }

    func showError(_ fromView: PlayerViewProtocol?, _ title: String?, _ message: String?) {
        let aletController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.dong_y, style: .cancel) { (_) in
            self.dismissPlayer(fromView)
        }
        aletController.addAction(okAction)
        let fromViewController = fromView as! UIViewController
        fromViewController.present(aletController, animated: true, completion: nil)
    }

    func showHud(_ fromView: PlayerViewProtocol?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.showHud()
    }

    func hideHud(_ fromView: PlayerViewProtocol?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.hideHude()
    }
    
    func doShowSelectQuality(fromVC: UIViewController, _ quality: QualityModel?, list: [QualityModel]) {
        if let fromViewController = fromVC as? BaseViewController {
            let vc = FilmDetailSelectQualityViewController(quality: quality, listQuality: list)
            vc.delegate = self
            fromViewController.presentPopOverDailog(viewController: vc)
        }
    }
}

extension PlayerWireFrame: FilmDetailSelectQualityViewControllerDelegate {
    func didSelectQuality(viewController: FilmDetailSelectQualityViewController?, quality: QualityModel) {
        self.view?.dismissPopOver()
        presenter?.didSelectQuality(quality)
    }
}
