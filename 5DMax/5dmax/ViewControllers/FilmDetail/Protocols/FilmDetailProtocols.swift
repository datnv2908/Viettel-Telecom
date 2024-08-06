//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

protocol FilmDetailViewProtocol: class {
    var presenter: FilmDetailPresenterProtocol? { get set }
    var isShowFullDesc: Bool { get set }
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
    func reloadData()
    func scrollToTop()
    func showSMSConfirm(_ fromView: FilmDetailViewProtocol?, message: String, number: String, content: String)
}

protocol FilmDetailWireFrameProtocol: class {
    static func presentFilmDetailModule(_ viewController: UIViewController, film: FilmModel, noti : Bool, sendView: Bool)
    static func presentFilmDetailModule(_ viewController: UIViewController, film: String, part: String?, noti: Bool, sendView: Bool)
    
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
    func closeDetailView(_ fromView: FilmDetailViewProtocol?)
    func showLoginView(_ fromView: FilmDetailViewProtocol?)
    func playFilm(_ fromView: FilmDetailViewProtocol?, _ playlistModel: PlayListModel ,isNoti : Bool ,sendView : Bool)
    func playTrailer(_ fromView: FilmDetailViewProtocol?, trailer: TrailersModel?, trailerStream: StreamModel)
    func playFilmWithChromeCast(_ fromView: FilmDetailViewProtocol?, _ playlistModel: PlayListModel)
    func share(_ fromView: FilmDetailViewProtocol?, shareItems items: [Any], _ sender: UIButton)
    func showAlert(_ fromView: FilmDetailViewProtocol?, _ title: String?, _ message: String?)
    func showToast(_ fromView: FilmDetailViewProtocol?, _ message: String)
    func showHud(_ fromView: FilmDetailViewProtocol?)
    func hideHud(_ fromView: FilmDetailViewProtocol?)
}

protocol FilmDetailPresenterProtocol: class {
    var view: FilmDetailViewProtocol? { get set }
    var interactor: FilmDetailInteractorInputProtocol? { get set }
    var wireFrame: FilmDetailWireFrameProtocol? { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    func viewDidLoad()
    func didTapOnCloseButton(_ sender: Any)
    func onShare(_ sender: UIButton)
    func onAddToFavorite()
    func onChoosePart(_ index: Int)
    func onRentESFilm()
    func getPlayListDetail(_ id: String, partId: String?,noti : Bool ,sendNoti :Bool) 
    func onSelectItem(_ type: FilmDetailSectionType, _ index: Int)
    func didSelectPart(_ model: PartModel)
    func doChangeDisplay(_ displayType: FilmDetailSectionType)
    func didReceiveCateNoti (id : String, type : ContentType,model : NotifyModel?)
    func doPlayTrailer()
    func onSelectSeason(id : Int)
    func reloadDetaifromNotifi()
}

protocol FilmDetailInteractorInputProtocol: class {
    var presenter: FilmDetailInteractorOutputProtocol? { get set }
    /**
     * Add here your methods for communication PRESENTER -> INTERACTOR
     */
    func getPlayListDetail(_ listId: String, _ partId: String?, noti : Bool, sendNoti : Bool)
    func getStream(_ filmId: String, partId: String?, completion: @escaping (Result<Any>) -> Void)
    func addOrRemoveFilmToMyList(_ id: String)
    func registPackage(_ id: String, contentType: String, contentName: String, isRegisterFast: Bool)
    func registPackage(_ model: PopupModel, contentType: String, contentName: String)
    func buyRetail(_ id: String, type: String, completion: @escaping (Result<Any>) -> Void)
    func getVideoTrailer(_ ItemId: String, completion: @escaping(Result<Any>) -> Void)
    func getRelateFilmBySeason(_ itemId : String , completion: @escaping(Result<[PartModel]>) -> Void)
    func getSerriFilm(_ itemId: String, completion: @escaping (Result<SeriModel>) -> Void)
    
}

protocol FilmDetailInteractorOutputProtocol: class {
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
    func didGetPlayListDetail(_ result: Result<Any>)
    func didAddOrRemoveFilmToMyList(err: NSError?, isAdd: Bool)
    func didRegistPackage(_ result: Result<Any>)
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String)
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String, isRegisterFast: Bool)
}
