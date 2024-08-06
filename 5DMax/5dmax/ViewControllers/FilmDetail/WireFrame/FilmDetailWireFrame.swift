//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import GoogleCast

class FilmDetailWireFrame: FilmDetailWireFrameProtocol {
    
    class func presentFilmDetailModule(_ viewController: UIViewController, film: String, part: String?, noti: Bool, sendView: Bool) {
        // Generating module components
        let view: FilmDetailViewProtocol = FilmDetailView.initWithNib()
        let presenter: FilmDetailPresenterProtocol & FilmDetailInteractorOutputProtocol = FilmDetailPresenter(film, part, noti: noti , sendNotify: sendView)
        let interactor: FilmDetailInteractorInputProtocol = FilmDetailInteractor()
        let wireFrame: FilmDetailWireFrameProtocol = FilmDetailWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        if let vc = view as? UIViewController {
            vc.modalPresentationStyle = .overCurrentContext
            viewController.present(vc, animated: true, completion: nil)
        }
    }
    class func reloadDataFromNotifi (_ viewController: UIViewController, film: String, part: String?, noti : Bool , sendView: Bool){
        let view: FilmDetailViewProtocol = FilmDetailView.initWithNib()
        let presenter: FilmDetailPresenterProtocol & FilmDetailInteractorOutputProtocol = FilmDetailPresenter(film, part, noti: noti, sendNotify: sendView)
        let interactor: FilmDetailInteractorInputProtocol = FilmDetailInteractor()
        let wireFrame: FilmDetailWireFrameProtocol = FilmDetailWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.reloadDetaifromNotifi()
    }
    class func presentFilmDetailModule(_ viewController: UIViewController, film: FilmModel, noti : Bool, sendView: Bool) {
        // Generating module components
        let view: FilmDetailViewProtocol = FilmDetailView.initWithNib()
        let presenter: FilmDetailPresenterProtocol & FilmDetailInteractorOutputProtocol = FilmDetailPresenter(film.id, film.partId, noti: noti, sendNotify:sendView)
        let interactor: FilmDetailInteractorInputProtocol = FilmDetailInteractor()
        let wireFrame: FilmDetailWireFrameProtocol = FilmDetailWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        if let vc = view as? UIViewController {
            vc.modalPresentationStyle = .overCurrentContext
            viewController.present(vc, animated: true, completion: nil)
        }
    }

    //mark: -- FilmDetailWireFrameProtocol
    func closeDetailView(_ fromView: FilmDetailViewProtocol?) {
        let fromViewController = fromView as! FilmDetailView
        fromViewController.dismiss(animated: true, completion: nil)
    }

    func showLoginView(_ fromView: FilmDetailViewProtocol?) {
        let fromViewController = fromView as! FilmDetailView
        LoginViewController.performLogin(fromViewController: fromViewController)
    }

    // Play film
    func playFilm(_ fromView: FilmDetailViewProtocol?, _ playlistModel: PlayListModel ,isNoti : Bool ,sendView : Bool) {
        PlayerWireFrame.presentPlayerModule(fromView as! UIViewController, playListModel: playlistModel, fromNoti: isNoti, sendView: sendView)
    }
    
    func playTrailer(_ fromView: FilmDetailViewProtocol?, trailer: TrailersModel?, trailerStream: StreamModel) {
        PlayerWireFrame.presentPlayerModule(fromView as! UIViewController,
                                            trailer: trailer,
                                            trailerStream: trailerStream,
                                            title: "")
    }
    
    func playFilmWithChromeCast(_ fromView: FilmDetailViewProtocol?, _ playlistModel: PlayListModel) {
        GoogleChromcastHelper.shareInstance.playFilmWithChromeCast(playlistModel)
    }

    func share(_ fromView: FilmDetailViewProtocol?, shareItems items: [Any], _ sender: UIButton) {
        let fromViewController = fromView as! FilmDetailView
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let wPPC = controller.popoverPresentationController {
            wPPC.sourceView = sender
        }
        fromViewController.present(controller, animated: true, completion: nil)
    }

    func showAlert(_ fromView: FilmDetailViewProtocol?, _ title: String?, _ message: String?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.alertView(title, message: message)
    }

    func showToast(_ fromView: FilmDetailViewProtocol?, _ message: String) {
        let fromViewController = fromView as! UIViewController
        fromViewController.toast(message)
    }

    func showHud(_ fromView: FilmDetailViewProtocol?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.showHud()
    }

    func hideHud(_ fromView: FilmDetailViewProtocol?) {
        let fromViewController = fromView as! UIViewController
        fromViewController.hideHude()
    }
    
    deinit {
        
    }
}

extension FilmDetailWireFrame {

}
