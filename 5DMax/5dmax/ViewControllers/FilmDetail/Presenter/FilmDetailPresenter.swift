//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit
import GoogleCast

class FilmDetailPresenter: FilmDetailPresenterProtocol, FilmDetailInteractorOutputProtocol {
    weak var view: FilmDetailViewProtocol?
    var interactor: FilmDetailInteractorInputProtocol?
    var wireFrame: FilmDetailWireFrameProtocol?
    var viewModel = FilmDetailViewModel()
    
    init(_ film: String, _ part: String?,noti : Bool,sendNotify : Bool) {
        filmId = film
        partId = part
        isNoti = noti
        sendNoti = sendNotify
    }
    
    deinit {
        
    }

    fileprivate var filmId: String
    var partId: String?
    var isNoti: Bool
    var sendNoti: Bool
    fileprivate var playListModel: PlayListModel?
    fileprivate var videotrailerModel: StreamModel?
    private var isRegisterForPlay: Bool = false // user clicked to play button before and then login/ register package
    private var isRegisterForAddToLater: Bool = false // user clicked add to watch later before and then login
    //mark:
    //mark: -- private functions
    func getPlayListDetail(_ id: String, partId: String?,noti : Bool ,sendNoti :Bool) {
        filmId = id
        self.partId = partId
        wireFrame?.showHud(view)
        interactor?.getPlayListDetail(id, partId,noti: noti, sendNoti: sendNoti)
    }

    private func onSelectPlay() {
        if let userModel = DataManager.getCurrentMemberModel() {
            if userModel.msisdn.isEmpty {
                AuthorizeLinkAccountViewController.performLinkPhoneNumber(
                    fromViewController: (view as! BaseViewController))
            } else {
                if let model = self.playListModel {
                    let errorCode = model.stream.errorCode
                    switch errorCode {
                    case .success:
                        if URL(string: model.stream.urlStreaming) != nil {
                            performPlayFilm()
                        } else {
                            wireFrame?.showAlert(view, nil, String.badUrl)
                        }
                        isRegisterForPlay = false
                        break
                    case .fail:  //show popup if have
                        isRegisterForPlay = false
                        if let popup = model.stream.popup {
                            showConfirmPopUp(popup)
                            isRegisterForPlay = true
                        }
                        break
                    case .invalidToken: // show login
                        DataManager.clearLoginSession()
                        wireFrame?.showLoginView(view)
                        isRegisterForPlay = false
                        break
                    default:
                        break
                    }
                }
            }
        } else {
            wireFrame?.showLoginView(view)
            isRegisterForPlay = true
        }
    }
    
    private func onSelectPlayNextPart() {
        if let userModel = DataManager.getCurrentMemberModel() {
            if userModel.msisdn.isEmpty {
                AuthorizeLinkAccountViewController.performLinkPhoneNumber(
                    fromViewController: (view as! BaseViewController))
            } else {
                if let model = self.playListModel {
                    let errorCode = model.stream.errorCode
                    switch errorCode {
                    case .success:
                        if URL(string: model.stream.urlStreaming) != nil {
                            performPlayFilm()
                        } else {
                            wireFrame?.showAlert(view, nil, String.badUrl)
                        }
                        isRegisterForPlay = false
                        break
                    case .fail:
                        reloadPlayListDetail()
                        view?.scrollToTop()
                        break
                    case .invalidToken: // show login
                        DataManager.clearLoginSession()
                        wireFrame?.showLoginView(view)
                        isRegisterForPlay = true
                        break
                    default:
                        break
                    }
                }
            }
        } else {
            wireFrame?.showLoginView(view)
            isRegisterForPlay = true
        }
    }
    
    private func performPlayFilm() {
        if GCKCastContext.sharedInstance().castState == .connected {
            if let model = playListModel {
                (self.view as! BaseViewController).showHud()
                interactor?.getStream(model.detail.filmId, partId: model.detail.getCurrentVideoId(),
                                      completion: { (result) in
                    (self.view as! BaseViewController).hideHude()
                    switch result {
                    case .success(let streamModel):
                        model.stream = streamModel as! StreamModel
                        self.wireFrame?.playFilmWithChromeCast(self.view, model)
                        break
                    case .failure(let error):
                        (self.view as! BaseViewController).toast(error.localizedDescription)
                        break
                    }
                })
            }
        } else {
            if let model = playListModel {
                wireFrame?.playFilm(view, model , isNoti: self.sendNoti, sendView: isNoti)
            }
        }
    }

    private func showConfirmPopUp(_ model: PopupModel) {
        let fromViewController = view as! FilmDetailView
        weak var weakSelf = self
        if (model.isRegisterSub) {
            let titleNoti = (model.is_new_sub && model.is_temp_sub) ? String.first_month_free : String.dang_ky_sub
            let popupViewController = ListPricePopupViewController.init(title: titleNoti,
                                                                        message: model.confirm,
                                                                        confirmTitle: String.okString,
                                                                        cancelTitle: String.cancel)
            popupViewController.view.backgroundColor = .clear
            popupViewController.cancelDialog = {(_) in
                self.isRegisterForPlay = false
            }
            
            if (model.isRegisterFast == true) {
                popupViewController.confirmDialog = {(_) in
                    weakSelf?.wireFrame?.showHud(weakSelf?.view)
//                    weakSelf?.interactor?.registPackage(model, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!)
                    weakSelf?.interactor?.registPackage(model, contentType: "", contentName: "")
                }
                fromViewController.present(popupViewController, animated: true, completion: nil)
            } else {
                popupViewController.confirmButtonTitle = String.register
                popupViewController.confirmDialog = {(_) in
                    weakSelf?.showRegisterPackgerPopup(model)
                }
                fromViewController.present(popupViewController, animated: true, completion: nil)
            }
        } else {
            let popupViewController = ListPricePopupViewController.init(title: String.rentFilm,
                                                                        message: model.confirm,
                                                                        confirmTitle: String.rentFilm,
                                                                        cancelTitle: String.cancel)
            popupViewController.view.backgroundColor = .clear
            popupViewController.cancelDialog = {(_) in
                self.isRegisterForPlay = false
            }
            if model.isBuyVideo || model.isBuyPlaylist {
                popupViewController.confirmButtonTitle = String.rentFilm
                popupViewController.confirmDialog = {(_) in
                    weakSelf?.showBuyRetailPopup(model)
                }
                fromViewController.present(popupViewController, animated: true, completion: nil)
            }
        }
        
//        if model.isBuyPlaylist {
//            popupViewController.confirmButtonTitle = String.rentFilm
//            popupViewController.confirmDialog = {(_) in
//                weakSelf?.showBuyRetailPopup(model)
//            }
//            fromViewController.present(popupViewController, animated: true, completion: nil)
//        } else if(model.isRegisterFast == true && model.isRegisterSub == true){
//            popupViewController.confirmDialog = {(_) in
//                weakSelf?.wireFrame?.showHud(weakSelf?.view)
//                weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!)
//            }
//            fromViewController.present(popupViewController, animated: true, completion: nil)
//        } else if (model.isRegisterSub == true) {
//            popupViewController.confirmButtonTitle = String.register
//            popupViewController.confirmDialog = {(_) in
//                weakSelf?.showRegisterPackgerPopup(model)
//            }
//            fromViewController.present(popupViewController, animated: true, completion: nil)
//        } else {
//            let cancelPopupViewController = CancelPopupViewController.init(title: String.registerSubTitle)
//            cancelPopupViewController.view.backgroundColor = .clear
//            fromViewController.present(cancelPopupViewController, animated: true, completion: nil)
//        }
    }

    private func showRegisterPackgerPopup(_ model: PopupModel) {
        weak var weakSelf = self
        if(model.isConfirmSMS == false){
            let fromViewController = view as! FilmDetailView
            let popupViewController = ListPricePopupViewController.init(title: String.registerSubTitle,
                                                                        message: model.confirmRegisterSub,
                                                                        confirmTitle: String.okString,
                                                                        cancelTitle: String.ignore)
            popupViewController.view.backgroundColor = .clear
            popupViewController.cancelDialog = {(_) in
                self.isRegisterForPlay = false
            }
            popupViewController.confirmDialog = {(_) in
                weakSelf?.wireFrame?.showHud(weakSelf?.view)
                weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!, isRegisterFast: false)
            }
            fromViewController.present(popupViewController, animated: true, completion: nil)
        }else{
            weakSelf?.wireFrame?.showHud(weakSelf?.view)
            weakSelf?.interactor?.registPackage(model.packageId, contentType: (self.playListModel?.detail.type)!, contentName: (self.playListModel?.detail.name)!, isRegisterFast: false)
        }
    }

    private func showBuyRetailPopup(_ model: PopupModel) {
        guard let playlist = playListModel else {
            return
        }
        let fromViewController = view as! FilmDetailView
        let popupViewController = ListPricePopupViewController.init(title: String.rentFilm,
                                                                    message: model.confirmBuyPlaylist,
                                                                    confirmTitle: String.okString,
                                                                    cancelTitle: String.ignore)
        popupViewController.view.backgroundColor = .clear
        popupViewController.cancelDialog = {(_) in
            self.isRegisterForPlay = false
        }
        weak var weakSelf = self
        popupViewController.confirmDialog = {(_) in
            weakSelf?.wireFrame?.showHud(weakSelf?.view)
            weakSelf?.interactor?.buyRetail(playlist.detail.filmId, type: Constants.PlayList, completion: { (result) in
                weakSelf?.didRegistPackage(result)
            })
        }
        fromViewController.present(popupViewController, animated: true, completion: nil)
    }

    //mark: -- FilmDetailPresenterProtocol
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPlayListDetail), name:NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        self.reloadPlayListDetail()
    }
    
    @objc func reloadPlayListDetail() {
        getPlayListDetail(filmId, partId: partId, noti: false, sendNoti: sendNoti)
    }

    func didTapOnCloseButton(_ sender: Any) {
        wireFrame?.closeDetailView(view)
    }

    func didSelectPart(_ model: PartModel) {
        self.playListModel?.detail.setCurrentVideoId(model.partId)
        viewModel = FilmDetailViewModel(self.playListModel!, self.playListModel?.parts)
        view?.reloadData()
    }

    func onShare(_ sender: UIButton) {
        if let model = playListModel {
            var shareItems = [Any]()
            shareItems.append(model.detail.name)
            shareItems.append("\(String.share_1) \"\(model.detail.name)\".\n")
            shareItems.append("\(String.share_2).\n\n")
            if let url = URL(string: model.detail.link) {
                shareItems.append(url)
            }
            self.wireFrame?.share(view, shareItems: shareItems, sender)
        } else {
            // do nothing. because play list model is nil
        }
    }
    func reloadDetaifromNotifi() {
           self.reloadPlayListDetail()
       }
    func onAddToFavorite() {
        if DataManager.isLoggedIn() {
            interactor?.addOrRemoveFilmToMyList(filmId)
        } else {
            wireFrame?.showLoginView(view)
            isRegisterForAddToLater = true
        }
    }

    func onSelectItem(_ type: FilmDetailSectionType, _ index: Int) {
        
        switch type {
        case .cover:
            let filter = ContentLevel(rawValue: self.playListModel!.detail.contentFilter) ?? .all
            let pinModel = DataManager.getPinModel()
            if pinModel.isOn && pinModel.contentLevel.intValue() < filter.intValue() {
                weak var weakSelf = self
                ConfirmPINViewController.showConfirmPIN(fromViewController: (view as! BaseViewController),
                                                        sender: nil,
                                                        complete: { () -> (Void) in
                                                            weakSelf?.onSelectPlay()
                }, cancel: nil)
            } else {
                onSelectPlay()
            }
            break
        case .price:
            weak var weakSelf = self
            weakSelf?.wireFrame?.showHud(view)
            if DataManager.isLoggedIn() {
                if let filmID = viewModel.detailModel?.detail.filmId {
                    interactor?.buyRetail(filmID, type: Constants.PlayList, completion: { (result) in
                        weakSelf?.wireFrame?.hideHud(weakSelf?.view)
                        weakSelf?.didRentFilm(result)
                    })
                }
            } else {
                wireFrame?.showLoginView(view)
            }
            break
        case .part:
            if let model = playListModel {
                partId = model.parts[index].partId
                if partId == playListModel!.detail.getCurrentVideoId() { // select the current part
                    return
                }
                // update current video id of playlist model
                playListModel!.choosePartAtIndex(index)
                // reload view
                viewModel = FilmDetailViewModel(playListModel!, playListModel?.parts)
                view?.reloadData()
                
                isRegisterForPlay = true
                reloadPlayListDetail()
                view?.scrollToTop()
//                onSelectPlayNextPart()
            }
            break
        case .related:
            if let model = playListModel {
                partId = nil
                // reload view
                viewModel = FilmDetailViewModel()
                view?.isShowFullDesc = false
                view?.reloadData()
                // perform get detail
                getPlayListDetail(model.related.content[index].id, partId: partId, noti: false, sendNoti: false)
            }
            break
        default:
            break
        }
    }
    
    func onRentESFilm() {
        weak var weakSelf = self
        weakSelf?.wireFrame?.showHud(view)
        if DataManager.isLoggedIn() {
            if let filmID = viewModel.detailModel?.stream.videoId {
                interactor?.buyRetail(filmID, type: Constants.Video, completion: { (result) in
                    weakSelf?.wireFrame?.hideHud(weakSelf?.view)
                    weakSelf?.didRentFilm(result)
                })
            }
        } else {
            wireFrame?.showLoginView(view)
        }
    }

    func onChoosePart(_ index: Int) {
        if playListModel != nil {
            if index < 0 || index > playListModel!.parts.count - 1 { // next/ prev out of index
                return
            }
            partId = playListModel!.parts[index].partId

            if partId == playListModel!.detail.getCurrentVideoId() { // select the current part
                return
            }
            // update current video id of playlist model
            playListModel!.choosePartAtIndex(index)
            // reload view
            viewModel = FilmDetailViewModel(playListModel!, playListModel?.parts)
            view?.reloadData()
        }
    }

    //mark: -- FilmDetailInteractorOutputProtocol
    func didGetPlayListDetail(_ result: Result<Any>) {
        wireFrame?.hideHud(view)
        switch result {
        case .success(let model):
            if let playlist = model as? PlayListModel {
//                for test series
//                playlist.detail.attributes = .series
                
                playListModel = playlist
                for (index,item) in playlist.lisSeasons.enumerated() {
                    if item.id == Int(playlist.idSeasonSelected ?? 0) {
                        playlist.seasonIndex = index
                    }
                }
                viewModel = FilmDetailViewModel(playlist, playlist.parts)
                
                view?.reloadData()
                if let seasonId = playlist.idSeasonSelected, seasonId > 0 && playlist.detail.attributes == .series {
                    onSelectSeason(id: seasonId)
                }
            }

            if isRegisterForPlay {
                isRegisterForPlay = false
                onSelectPlay()
            }
            
            if playListModel?.detail.isFavourite == false && isRegisterForAddToLater {
                interactor?.addOrRemoveFilmToMyList(filmId)
                isRegisterForAddToLater = false
            }
            break
        case .failure(let error):
            if (error as NSError).code == APIErrorCode.notExist.rawValue {
                let fromViewController = view as! FilmDetailView
                let popupViewController = ListPricePopupViewController.init(title: "",
                                                                            message: "",
                                                                            confirmTitle: String.okString,
                                                                            cancelTitle: String.cancel)
                popupViewController.view.backgroundColor = .clear
                popupViewController.titleLabel.text = ""
                popupViewController.desLabel.text = (error as NSError).localizedDescription
                popupViewController.confirmDialog = {(_) in
                    self.wireFrame?.closeDetailView(self.view)
                }
                popupViewController.cancelDialog = {(_) in
                    self.wireFrame?.closeDetailView(self.view)
                }
                fromViewController.present(popupViewController, animated: true, completion: nil)
            } else if !error.localizedDescription.isEmpty {
                wireFrame?.showAlert(view, nil, error.localizedDescription)
            }
            break
        }
    }

    func didAddOrRemoveFilmToMyList(err: NSError?, isAdd: Bool) {
        if err == nil {
            self.playListModel?.detail.isFavourite = isAdd
            viewModel = FilmDetailViewModel(self.playListModel!, self.playListModel?.parts)
            view?.reloadData()
            if isAdd {
                self.wireFrame?.showToast(self.view, String.addedToWatchLater)
            }
        } else {
            wireFrame?.showAlert(view, nil, err?.localizedDescription)
        }
    }
    
    func didRentFilm(_ result: Result<Any>) {
        (view as! BaseViewController).logPurchaseEevent(Constants.fire_base_detail)
        wireFrame?.hideHud(view)
        isRegisterForPlay = true
        switch result {
        case .success(_ ):
            wireFrame?.showToast(view, String.rentSuccess)
            interactor?.getPlayListDetail(filmId, partId, noti: false, sendNoti: false)
            break
        case .failure(let error):
            wireFrame?.showToast(view, error.localizedDescription)
            break
        }
    }

    func didRegistPackage(_ result: Result<Any>) {
        (view as! BaseViewController).logPurchaseEevent(Constants.fire_base_detail)
        wireFrame?.hideHud(view)
        isRegisterForPlay = true
        switch result {
        case .success(_ ):
            wireFrame?.showToast(view, String.registerSuccess)
            interactor?.getPlayListDetail(filmId, partId, noti: false, sendNoti: false)
            break
        case .failure(let error):
            wireFrame?.showToast(view, error.localizedDescription)
            break
        }
    }
    
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String) {
        //(view as! BaseViewController).logPurchaseEevent(Constants.fire_base_detail)
        wireFrame?.hideHud(view)
        view?.showSMSConfirm(view, message: message, number: number, content: smsContent)
    }
    
    func didRegistPackageWithSMS(message: String, number: String, smsContent: String, isRegisterFast: Bool){
        //(view as! BaseViewController).logPurchaseEevent(Constants.fire_base_detail)
        if (isRegisterFast) {
            wireFrame?.hideHud(view)
            view?.showSMSConfirm(view, message: message, number: number, content: smsContent)
        } else {
            let fromViewController = view as! FilmDetailView
            let popupViewController = ListPricePopupViewController.init(title: String.register, message: String.cancel)
            popupViewController.view.backgroundColor = .clear
            popupViewController.desLabel.attributedText = message.convertHtml()
            popupViewController.desLabel.textColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
            popupViewController.desLabel.font = AppFont.museoSanFont(style: .regular, size: 15.0)
            popupViewController.confirmDialog = {(_) in
                self.wireFrame?.hideHud(self.view)
                popupViewController.dismiss(animated: true, completion: nil)
                self.view?.showSMSConfirm(self.view, message: message, number: number, content: smsContent)
            }
            popupViewController.cancelDialog = {(_) in
                self.wireFrame?.hideHud(self.view)
                popupViewController.dismiss(animated: true, completion: nil)
            }
            fromViewController.present(popupViewController, animated: true, completion: nil)
        }
    }
    
    func doChangeDisplay(_ displayType: FilmDetailSectionType) {
        viewModel.displayType = displayType
        self.view?.reloadData()
    }
    func didReceiveCateNoti (id : String, type : ContentType ,model : NotifyModel?) {
        let fromViewController = view as! FilmDetailView
        let groupModel = GroupModel(groupId:id, name: model?.message ?? "")
        let category = CategoryModel(group: groupModel)
        if type == .collection {
            let viewcontroller = GetMoreCollectionViewController(category, fromNoti: true)
            fromViewController.navigationController?.pushViewController(viewcontroller, animated: true)
        }else if type == .category{
            let viewcontroller = MoreContentViewController(category, fromNoti: true)
            fromViewController.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    func onSelectSeason(id : Int) {
        interactor?.getSerriFilm("\(id)", completion: { (result) in
            switch result {
            case .success(let json):
                self.playListModel!.parts = json.parts
                self.playListModel?.detail.desc = json.descSeri
                self.viewModel = FilmDetailViewModel(self.playListModel!, json.parts)
                self.view?.reloadData()
                DLog("play trailer")
            case .failure(let err):
                self.wireFrame?.showToast(self.view, err.localizedDescription)
                break
            }
        })    }
    func doPlayTrailer() {
        if let trailerStreamItem = videotrailerModel {
            DLog("play trailer")
            self.wireFrame?.playTrailer(self.view, trailer: self.viewModel.detailModel?.trailers, trailerStream: trailerStreamItem)
        } else if let trailer = viewModel.trailer {
            if Int(trailer.id) != 0 {
                interactor?.getVideoTrailer(trailer.id, completion: { (result) in
                    switch result {
                    case .success(let _videotrailerModel):
                        if let item = _videotrailerModel as? StreamModel {
                            self.videotrailerModel = item
                            self.wireFrame?.playTrailer(self.view, trailer: self.viewModel.detailModel?.trailers, trailerStream: item)
                        }
                        DLog("play trailer")
                    case .failure(let err):
                        self.wireFrame?.showToast(self.view, err.localizedDescription)
                        break
                    }
                })
            }
        }
        
//        interactor?.getVideoTrailer(model.videoId, completion: { (result) in
//            (self.view as! BaseViewController).hideHude()
//            switch result {
//            case .success(let videotrailerModel):
//                self.wireFrame?.playTrailer(self.view, videotrailerModel as! VideoTrailerModel)
//            case .failure(let err):
//                (self.view as! BaseViewController).toast(err.localizedDescription)
//                break
//            }
//        })
        
//        if GCKCastContext.sharedInstance().castState == .connected {
//            if let model = videotrailerModel {
//                (self.view as! BaseViewController).showHud()
//                interactor?.getVideoTrailer(model.videoId, completion: { (result) in
//                    (self.view as! BaseViewController).hideHude()
//                    switch result {
//                    case .success(let videotrailerModel):
//                        self.wireFrame?.playTrailer(self.view, videotrailerModel as! VideoTrailerModel)
//                    case .failure(let err):
//                        (self.view as! BaseViewController).toast(err.localizedDescription)
//                        break
//                    }
//                })
//            }
//        } else {
//            if let model = videotrailerModel {
//                wireFrame?.playTrailer(view, model)
//            }
//        }
    }
}
