//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class PlayerPresenter: PlayerPresenterProtocol, PlayerInteractorOutputProtocol {
    weak var view: PlayerViewProtocol?
    var interactor: PlayerInteractorInputProtocol?
    var wireFrame: PlayerWireFrameProtocol?
    var viewModel = PlayerViewModel()
    var filmModel: FilmModel?
//    var plModel: PlayListModel?
    var baseVC: UIViewController?
    var isPlayTrailer: Bool = false
    var currentQuality: QualityModel?
     var  isLastPart = false
    var instance: ViewRightWeb?
    var fromNoti: Bool = false
    var sendView: Bool = false
    fileprivate var filmId: String = ""
    fileprivate var partId: String?
    private var streamModel: StreamModel!
    private var playListModel: PlayListModel?
    private var qualities = [QualityModel]()
    var kpiTimer: Timer?

    init(_ fromView: UIViewController, model: FilmModel ,fromNoti : Bool , sendView : Bool) {
        self.baseVC = fromView
        self.filmId = model.id
        self.partId = model.partId
        self.filmModel = model
        self.fromNoti = fromNoti
        viewModel = PlayerViewModel(model, fromNoti: fromNoti, sendView: sendView)
    }
    
    init(model: FilmModel , fromNoti : Bool,sendView : Bool) {
        self.filmId = model.id
        self.partId = model.partId
        self.filmModel = model
        self.fromNoti = fromNoti
        viewModel = PlayerViewModel(model, fromNoti: fromNoti, sendView: sendView)
    }
    
    init(_ fromView: UIViewController, model: PlayListModel ,fromNoti : Bool,sendView : Bool) {
        self.filmId = model.detail.filmId
        self.partId = model.detail.getCurrentVideoId()
//        self.plModel = model
        self.playListModel = model
        self.baseVC = fromView
        self.fromNoti = fromNoti
        self.sendView = sendView
        viewModel = PlayerViewModel(model, fromNoti: fromNoti, sendView: sendView)
    }

    init(model: PlayListModel , fromNoti : Bool,sendView : Bool) {
        self.filmId = model.detail.filmId
        self.partId = model.detail.getCurrentVideoId()
        self.playListModel = model
        viewModel = PlayerViewModel(model, fromNoti: fromNoti, sendView: sendView)
    }
    
    init(trailer: TrailersModel?, withStream: StreamModel,sendView : Bool) {
        self.streamModel = withStream
        viewModel = PlayerViewModel(trailerModel: trailer, stream: withStream, fromNoti: fromNoti)
        isPlayTrailer = true
    }
    
    init(trailerStream: StreamModel) {
        self.streamModel = trailerStream
        viewModel = PlayerViewModel(trailerModel: nil, stream: trailerStream, fromNoti: fromNoti)
        isPlayTrailer = true
    }
    
    //mark: -- PlayerPresenterProtocol
    func viewDidLoad() {
        view?.reloadView()
        if isPlayTrailer {
            self.playTrailer()
        } else {
            interactor?.getPlayListDetail(filmId, partId: partId,noti: false, sendNoti: false)
        }
    }

    func viewWillAppear() {

    }

    func deallocView() {
        interactor?.cancelAllRequests()
        stopKPITimer()
    }

    /*
     *  function is called from Episode list view
     */
    func didSelectPart(_ partModel: PartModel) {
        if playListModel == nil {
            return
        }
        if playListModel?.detail.getCurrentVideoId() == partModel.partId { // choose the same episode
            return
        } else {
            // mark the watching time of the last episode before play new one
            let objectId = playListModel?.detail.getCurrentVideoId() ?? filmId
            markWatchingTime(objectId: objectId)

            // change current current video id
            playListModel?.detail.setCurrentVideoId(partModel.partId)
            partId = partModel.partId
            viewModel.playListModel = playListModel
            viewModel.coverImage = partModel.coverImage
            self.view?.reloadView()
            interactor?.getPlayListDetail(filmId, partId: partModel.partId, noti: false, sendNoti: false)
        }
    }

    func didTapOnEpisode(_ sender: Any) {
        if let model = playListModel {
            wireFrame?.presentEpisodeList(view, model)
        }
    }
    func didEnterBackground() {
        let objectId = partId ?? filmId
        markWatchingTime(objectId: objectId)
    }

    func didFinishPlayback() {
        if let model = playListModel, let index = viewModel.currentPartIndex() {
            let nextIndex = index + 1
            if model.parts.indices.contains(nextIndex) {
                didSelectPart(model.parts[nextIndex])
            } else {
                let objectId = partId ?? filmId
                markWatchingTime(objectId: objectId)
                wireFrame?.dismissPlayer(view)
            }
        }
    }
    
    func gotInvalidUrl(_ url: String) {
        wireFrame?.showError(view, nil, String.badUrl)
    }

    func unableToPlayUrl(_ url: String) {
        wireFrame?.showError(view, nil, String.badUrl)
    }

    func didTapOnClose(_ sender: Any) {
        // mark the watching time before close view
        let objectId = partId ?? filmId
        markWatchingTime(objectId: objectId)
        wireFrame?.dismissPlayer(view)
    }

    //mark: -- PlayerInteractorOutputProtocol
    func didGetPlayListDetail(_ result: Result<Any>) {
        switch result {
        case .success(let model):
            if let item = model as? PlayListModel {
                self.playListModel = item
                viewModel = PlayerViewModel(item, fromNoti: self.fromNoti, sendView: sendView)
//                viewModel.
                view?.reloadView()
                if let seasionId = item.idSeasonSelected {
                    onSelectSeason(id: seasionId)
                }
            }
            validateStreamModel()
            break
        case .failure(let error):
            wireFrame?.showError(view, nil, error.localizedDescription)
            break
        }
    }
    func relateSeason(partNextSeason : PartModel?){
        if let partID = partNextSeason {
        self.view?.reloadView()
            self.interactor?.getPlayListDetail(self.filmId, partId: partID.partId, noti: false, sendNoti: false)
        }
    }
    func onSelectSeason(id : Int) {
        interactor?.getRelateFilmBySeason("\(id)", completion: { [weak self](result) in
            switch result {
            case .success(let json):
                if let item = self?.playListModel {
                    item.parts = json
                    self?.playListModel = item
                    self?.view?.reloadView()
                }
            case .failure(let error):
                //                self?.wireFrame?.showError(self!.view, nil, error.localizedDescription)
                break
            }
        })
    }
    func nextSeason(){
//        view?.reset()
        if let partID = playListModel?.detail.getCurrentVideoId() {
            if partID == playListModel?.parts.last?.partId {
                interactor?.getRelateFilmBySeason("\(viewModel.nextSeriesID())", completion: { [weak self](result) in
                    switch result {
                    case .success(let json):
                        if let item = self?.playListModel {
                            if let partNextSeason  = json.first {
                                self?.viewModel = PlayerViewModel(item, fromNoti: false, sendView: false)
                                self?.relateSeason(partNextSeason: partNextSeason)
                            }
                        }
                    case .failure(let error):
                        break
                    }
                })
            }else{
                relateSeason(partNextSeason: viewModel.nextPart())
            }
            
        }
    }
    func previousSeason(){
//        view?.reset()
        if let partID = playListModel?.detail.getCurrentVideoId() {
              if partID == playListModel?.parts.first?.partId {
                  interactor?.getRelateFilmBySeason("\(viewModel.previousSeriesID())", completion: { [weak self](result) in
                      switch result {
                      case .success(let json):
                          if let item = self?.playListModel {
                              if let partPreviousSeason = json.last {
                                self?.viewModel = PlayerViewModel(item, fromNoti: false, sendView: false)
                                  self?.relateSeason(partNextSeason: partPreviousSeason)
                              }
                          }
                      case .failure(let error):
                          break
                      }
                  })
              }else{
                  relateSeason(partNextSeason: viewModel.previousPart())
              }
              
          }
    }
    private func playTrailer() {
        guard let streamModel = self.viewModel.trailerStream else {
            return
        }
        
        if let url = URL(string: streamModel.urlStreaming) {
            qualities.removeAll()
            qualities.append(QualityModel.init(String.auto, streamModel.urlStreaming, isAuto: true, isSelected: true))
            view?.reloadView()
            
            viewModel.kpiToken = streamModel.traceKey
            viewModel.kpiModel?.contentId = streamModel.videoId
            viewModel.kpiModel?.playUrl = streamModel.urlStreaming
            view?.playStreaming(url, previewImage: streamModel.previewImage, timeToSeek: Float64(0), changeQuality: false)
            self.currentQuality = qualities.first
        }
    }
    
    private func validateStreamModel() {
        guard let playListModel = self.playListModel else {
            return
        }
        
        let errorCode = playListModel.stream.errorCode
        let streamModel = playListModel.stream
        
        switch errorCode {
        case .success:            
            if let url = URL(string: streamModel.urlStreaming) {
                qualities.removeAll()
                qualities.append(QualityModel.init(String.auto, streamModel.urlStreaming, isAuto: true, isSelected: true))
                view?.reloadView()
                
                viewModel.kpiToken = streamModel.traceKey
                viewModel.kpiModel?.contentId = streamModel.videoId
                viewModel.kpiModel?.playUrl = streamModel.urlStreaming
                
                // check if movie is drm content
                //Manhhx modified here
                if playListModel.isDRMContent() {
                    instance = ViewRightWeb()
                    if let translatedUrl = instance?.translateMovieUrl(streamModel.urlStreaming) {
                        view?.playStreaming(translatedUrl, previewImage: streamModel.previewImage, timeToSeek: Float64(playListModel.currentTime), changeQuality: false)
                    } else {
                        view?.playStreaming(url, previewImage: streamModel.previewImage, timeToSeek: Float64(playListModel.currentTime), changeQuality: false)
                    }
                } else {
                    view?.playStreaming(url, previewImage: streamModel.previewImage, timeToSeek: Float64(playListModel.currentTime), changeQuality: false)
                }
                
                //request for video qualities
                interactor?.requestM3u8(streamModel.urlStreaming)
            } else {
                wireFrame?.showError(view, nil, String.badUrl)
            }
            break
        case .fail:
            
            guard let vc = view as? UIViewController else {
                return
            }
            
            if let vc = self.baseVC, let fm = self.filmModel {
                let film = FilmModel(fm)
                film.partId = self.partId
                self.wireFrame?.dismissPlayer(self.view)
                
                let alertView = UIAlertController(title: String.rentFilm,
                                                  message: String.chuyen_ve_man_hinh_chi_tiet_film,
                                                  preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in

                }
                alertView.addAction(cancelAction)
                let registerPackageAction = UIAlertAction(title: String.dong_y, style: .default) { (_) in
                    FilmDetailWireFrame.presentFilmDetailModule(vc, film: film, noti: false, sendView: false)
                }
                alertView.addAction(registerPackageAction)
                vc.present(alertView, animated: true, completion: nil)
                
                return
            }
            
            let alertView = UIAlertController(title: String.rentFilm,
                                              message: String.chuyen_ve_man_hinh_chi_tiet_film,
                                              preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in
                self.wireFrame?.dismissPlayer(self.view)
            }
            alertView.addAction(cancelAction)
            let registerPackageAction = UIAlertAction(title: String.dong_y, style: .default) { (_) in
                
                if let vc = (self.baseVC as? FilmDetailViewProtocol), let _ = self.playListModel {
                    self.wireFrame?.dismissPlayer(self.view)
                    vc.presenter?.getPlayListDetail(self.filmId, partId: self.partId, noti: false, sendNoti: false)
                }
            }
            alertView.addAction(registerPackageAction)
            vc.present(alertView, animated: true, completion: nil)
            
            break
        case .invalidToken:
            DataManager.clearLoginSession()
            wireFrame?.showError(view, nil, streamModel.message)
            wireFrame?.dismissPlayer(view)
            break
        default:
            break
        }
    }

    func didGetM3u8File(content: String?) {
        if let string = content {
            parseM3U8File(content: string)
        } else {
            // there isn't HLS Streaming URL
        }
    }

    func didRegistPackage(_ result: Result<Any>) {
        wireFrame?.hideHud(view)
        switch result {
        case .success(_ ):
            interactor?.getPlayListDetail(filmId, partId: partId, noti: false, sendNoti: false)
            break
        case .failure(let error):
            wireFrame?.showError(view, nil, error.localizedDescription)
            break
        }
    }

    //mark: -- private function
    private func parseM3U8File(content: String) {
        guard playListModel != nil,
            !playListModel!.stream.urlStreaming.isEmpty else {
            return
        }
        
        var components = playListModel!.stream.urlStreaming.components(separatedBy: "?")
        
        var last = ""
        if (components.count > 1) {
            last = components.last!
            components.removeLast()
        }
        
        
        var newComponents = components.joined(separator: "?").components(separatedBy: "/")
        if (newComponents.count > 1) {
            newComponents.removeLast()
        }
        
        let baseURLStr = newComponents.joined(separator: "/")
        let lines = content.components(separatedBy: CharacterSet.newlines)
        for (index, line) in lines.enumerated() {
            let lineObj = line as NSString
            if lineObj.range(of: "#EXT-X-STREAM-INF").location != NSNotFound {
                //Find Resolution
                let regex = try! NSRegularExpression(pattern: "RESOLUTION=(\\d+)x(\\d+)",
                                                     options: NSRegularExpression.Options.caseInsensitive)
                let matches = regex.matches(in: line, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                            range: NSRange(location: 0, length: lineObj.length) )
                
                let range1 = matches[0].range(at: 1)
                let range2 = matches[0].range(at: 2)
                
                var resolution = "Unknown"
                if range1.location != NSNotFound || range2.location != NSNotFound {
                    resolution = String(format: "%@p", lineObj.substring(with: range2))
                }
                
                //Find url
                var urlString = ""
                if index + 1 < lines.count - 1 {
                    urlString = lines[index + 1]
                }
                
                var subCom = urlString.components(separatedBy: "?")
                subCom.removeLast()
                let subUrl = subCom.first
                
                if (subCom.count < 1) {
                    self.qualities.append(QualityModel.init(resolution, baseURLStr + "/" + urlString + (last.count > 0 ? "?\(last)" : ""), isAuto: false,
                                                            isSelected: false))
                } else {
                    self.qualities.append(QualityModel.init(resolution, (subUrl ?? baseURLStr) + (last.count > 0 ? "?\(last)" : ""), isAuto: false,
                                                            isSelected: false))
                }
            }
        }
        
        let currentQuality = DataManager.getSettingFilmQuality()
        if currentQuality.isAuto { // don't need to change video quality
            if let url = URL(string: playListModel!.stream.urlStreaming) {
                if self.viewModel.playListModel!.isDRMContent() {
                    instance = ViewRightWeb()
                    if let translatedUrl = instance?.translateMovieUrl(playListModel!.stream.urlStreaming) {
                        view?.playStreaming(translatedUrl, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                    } else {
                        view?.playStreaming(url, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                    }
                } else {
                    view?.playStreaming(url, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                }
            }
            
            return
        } else {
            // need to change film quality to the select setting quality
            if let quality = self.qualities.filter({ (model) -> Bool in
                return model.name == currentQuality.name
            }).first {
                self.currentQuality = quality
                if let url = URL(string: quality.url) {
                    DLog("play quality: \(self.currentQuality?.name ?? "not debug")")
                    if self.viewModel.playListModel!.isDRMContent() {
                        instance = ViewRightWeb()
                        if let translatedUrl = instance?.translateMovieUrl(quality.url) {
                            view?.playStreaming(translatedUrl, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                        } else {
                            view?.playStreaming(url, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                        }
                    } else {
                        view?.playStreaming(url, previewImage: playListModel!.stream.previewImage, timeToSeek: Float64(playListModel!.currentTime), changeQuality: true)
                    }
                }
            }
        }
    }

    private func showConfirmPopUp(_ model: PopupModel) {
        guard let vc = view as? UIViewController else {
            return
        }
        if (model.isRegisterSub) {
            
            let alertView = UIAlertController(title: String.registerSubTitle,
                                              message: model.confirm,
                                              preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.ignore, style: .cancel) { (_) in
                self.wireFrame?.dismissPlayer(self.view)
            }
            weak var weakSelf = self
            alertView.addAction(cancelAction)
            
            if model.isRegisterFast {
                weakSelf?.wireFrame?.showHud(weakSelf?.view)
                weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!)
            } else {
                let registerPackageAction = UIAlertAction(title: String.register, style: .default) { (_) in
                    weakSelf?.showRegisterPackgerPopup(model)
                }
                alertView.addAction(registerPackageAction)
            }
            let registerPackageAction = UIAlertAction(title: String.register, style: .default) { (_) in
                weakSelf?.showRegisterPackgerPopup(model)
            }
            alertView.addAction(registerPackageAction)
            
            vc.present(alertView, animated: true, completion: nil)
        } else {
            let alertView = UIAlertController(title: String.rentFilm,
                                              message: model.confirm,
                                              preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.ignore, style: .cancel) { (_) in
                self.wireFrame?.dismissPlayer(self.view)
            }
            weak var weakSelf = self
            alertView.addAction(cancelAction)
            
            if model.isBuyVideo || model.isBuyPlaylist {
                let buyRetailAction = UIAlertAction(title: String.rentFilm, style: .default) { (_) in
                    weakSelf?.showBuyRetailPopup(model)
                }
                alertView.addAction(buyRetailAction)
            }
            
            vc.present(alertView, animated: true, completion: nil)
        }
    }

    private func showRegisterPackgerPopup(_ model: PopupModel) {
        weak var weakSelf = self
        if(model.isConfirmSMS == false){
            let fromViewController = view as! PlayerView
            let alertView = UIAlertController(title: String.registerSubTitle, message: model.confirmRegisterSub,
                                              preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.ignore, style: .cancel) { (_) in
                self.wireFrame?.dismissPlayer(self.view)
            }
            let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
                weakSelf?.wireFrame?.showHud(weakSelf?.view)
                weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!)
            }
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            fromViewController.present(alertView, animated: true, completion: nil)
        }else{
            weakSelf?.wireFrame?.showHud(weakSelf?.view)
            weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!)
        }
    }

    private func showBuyRetailPopup(_ model: PopupModel) {
        guard let playlist = playListModel else {
            return
        }
        let fromViewController = view as! PlayerView
        let alertView = UIAlertController(title: String.rentFilm, message: model.confirmBuyPlaylist,
                                          preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: String.ignore, style: .cancel) { (_) in
            self.wireFrame?.dismissPlayer(self.view)
        }
        weak var weakSelf = self
        let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
            weakSelf?.wireFrame?.showHud(weakSelf?.view)
            weakSelf?.interactor?.buyRetail(playlist.detail.filmId, type: Constants.PlayList, completion: { (result) in
                weakSelf?.didRegistPackage(result)
            })
        }
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        fromViewController.present(alertView, animated: true, completion: nil)
    }

    private func markWatchingTime(objectId: String) {
        let service = UserService()
        let currentPlayedTime = view?.checkCurrentTime()
        service.watchTime(id: objectId, time: currentPlayedTime!, type: .film, completion: { (_ ) in
        })
    }
    
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String){
        wireFrame?.hideHud(view)
        view?.showSMSConfirm(view, message: message, number: number, content: smsContent)
    }
    
    func onPlay() {
        print("Manhhx Player onPlay")
        viewModel.kpiModel?.startWatching()
        
    }
    
    func onPause() {
        print("Manhhx Player onPause")
        viewModel.kpiModel?.pauseTimes += 1
        viewModel.kpiModel?.stopWatching()
    
    }
    
    func onSeeked() {
        print("Manhhx Player on Seek")
        viewModel.kpiModel?.seekTimes += 1
    }
    
    func onBuffering() {
        print("Manhhx Player on Buffering")
        viewModel.kpiModel?.waitTimes += 1
        viewModel.kpiModel?.startBuffering()
    }
    
    func onFinishBuffering() {
        print("Manhhx Player onFinishBuffering")
        viewModel.kpiModel?.stopBuffering()
    }
    func setCurrentTime(currentTimePlaying : Double){
        viewModel.kpiModel?.currentWatchingDuration = currentTimePlaying
    }
    func endKPITimer(){
        kpiTimer = nil
    }
    func startKPITimer() {
        weak var wself = self
        if #available(iOS 10.0, *) {
            if let timer = kpiTimer {
                timer.fire()
            }else{
                kpiTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10),
                                                repeats: true,
                                                block: { (_) in
                                                    wself?.sendKPIStatistic()
                                            
                })
            }
            
//            kpiTimer = nil
            kpiTimer?.fire()
            print("time fired")
        } else {
            // Fallback on earlier versions
            kpiTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10),
                                            target: self,
                                            selector: #selector(sendKPIStatistic),
                                            userInfo: nil, repeats: true)
        }
    }
    
    private func stopKPITimer() {
        kpiTimer?.invalidate()
        kpiTimer = nil
    }
    
    @objc private func sendKPIStatistic() {
        guard let model = viewModel.kpiModel else {
            return
        }
        if model.isBuffering {
            model.stopBuffering()
            model.startBuffering()
        }
        if model.isPlaying {
            model.stopWatching()
            model.startWatching()
        }
        else{
//            if(model.isBuffering == false){
//                return;
//            }
        }
        
        if isPlayTrailer == false { // only send statistic when there is changed
            print("Manhhx send kpi statistic")
            interactor?.KPITrace(model, completion: { (error) in
                if error == nil {
                    
                } else {
                    
                }
            })
        }
    }
    
    func doShowSelectQuality() {
        if let vc = self.view as? UIViewController {
            self.wireFrame?.doShowSelectQuality(fromVC: vc, self.currentQuality, list: self.qualities)
        }
    }
    
    deinit {
    }
}

extension PlayerPresenter: PlayerWireFrameOutputProtocol {
    func didSelectQuality(_ quality: QualityModel) {
        DLog("didSelectQuality \(quality.name)")
        currentQuality = quality
        var previewImage: String = ""
        if let image = self.viewModel.playListModel?.stream.previewImage {
            previewImage = image
        } else if let image = self.viewModel.trailerStream?.previewImage {
            previewImage = image
        }
        
        if let url = URL(string: quality.url), let currentTime = self.view?.getCurrentTime() {
            view?.playStreaming(url, previewImage: previewImage, timeToSeek: currentTime, changeQuality: true)
        }
    }
}
