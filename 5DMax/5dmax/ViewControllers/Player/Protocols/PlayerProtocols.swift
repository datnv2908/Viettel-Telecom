//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerViewProtocol: class {
    weak var delegate: PlayerViewDelegate? { get set }
    var presenter: PlayerPresenterProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
    func reset()
    func reloadView()
    func playStreaming(_ url: URL, previewImage: String, timeToSeek: Float64, changeQuality: Bool)
//    func playStreaming(_ url: URL, playedPercent: Double)
//    func playTranslatedUrl(_ url: URL)
    func checkCurrentTime() -> Float64
    func showSMSConfirm(_ fromView: PlayerViewProtocol?, message: String, number: String, content: String)
    func getCurrentTime() -> Float64
}

protocol PlayerWireFrameProtocol: class {
    var view: BaseViewController? { get set }
    var presenter: PlayerWireFrameOutputProtocol? { get set }
    static func presentPlayerModule(_ fromView: UIViewController, filmModel: FilmModel, fromNoti : Bool,sendView : Bool)
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
    
    func dismissPlayer(_ fromView: PlayerViewProtocol?)
    func presentEpisodeList(_ fromView: PlayerViewProtocol?, _ playListModel: PlayListModel)
    func showAlert(_ fromView: PlayerViewProtocol?, _ title: String?, _ message: String?)
    func showError(_ fromView: PlayerViewProtocol?, _ title: String?, _ message: String?)
    func showHud(_ fromView: PlayerViewProtocol?)
    func hideHud(_ fromView: PlayerViewProtocol?)
    func doShowSelectQuality(fromVC: UIViewController, _ quality: QualityModel?, list: [QualityModel])
}

protocol PlayerWireFrameOutputProtocol {
    func didSelectQuality(_ quality: QualityModel)
}

protocol PlayerPresenterProtocol: class {
    var view: PlayerViewProtocol? { get set }
    var interactor: PlayerInteractorInputProtocol? { get set }
    var wireFrame: PlayerWireFrameProtocol? { get set }
    var viewModel: PlayerViewModel { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    func viewDidLoad()
    func viewWillAppear()
    func deallocView()
    func didFinishPlayback()
    func didEnterBackground()
    func gotInvalidUrl(_ url: String)
    func unableToPlayUrl(_ url: String)
    func didSelectPart(_ model: PartModel)
    func didTapOnEpisode(_ sender: Any)
    func didTapOnClose(_ sender: Any)
    func onPause()
    func onSeeked()
    func onBuffering()
    func onFinishBuffering()
    func onPlay()
    func startKPITimer()
    func endKPITimer()
    func doShowSelectQuality()
    func nextSeason()
    func previousSeason()
    func setCurrentTime(currentTimePlaying : Double)
}

protocol PlayerInteractorInputProtocol: class {
    var presenter: PlayerInteractorOutputProtocol? { get set }
    /**
     * Add here your methods for communication PRESENTER -> INTERACTOR
     */
//    func getStream(_ filmId: String, partId: String?)
    func getPlayListDetail(_ filmId: String, partId: String?,noti :Bool, sendNoti : Bool)
    func getRelateFilmBySeason(_ itemId : String , completion: @escaping(Result<[PartModel]>) -> Void)
    func requestM3u8(_ url: String)
    func registPackage(_ id: String, contentType: String, contentName: String)
    func buyRetail(_ id: String, type: String, completion: @escaping (Result<Any>) -> Void)
    func cancelAllRequests()
    func KPITrace(_ model: KPIModel, completion: @escaping((NSError?) -> Void))
    
}

protocol PlayerInteractorOutputProtocol: class {
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
    func didGetPlayListDetail(_ result: Result<Any>)
    func didGetM3u8File(content: String?)
    func didRegistPackage(_ result: Result<Any>)
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String)
}
