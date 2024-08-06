//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import UIKit
import SwiftyJSON
class VideoDetailConfigurator: NSObject {
    
    class func videoViewController(with content: ContentModel,
                              and playlist: PlaylistModel? = nil) -> VideoDetailViewController {
        let view = VideoDetailViewController.initWithNib()
        let presenter = VideoDetailPresenter()
        let viewModel = VideoDetailViewModel(with: content, and: playlist)
        let wireFrame = VideoDetailWireFrame()
        let interactor = VideoDetailInteractor()
        
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

    class func playlistViewController(with content: ContentModel? = nil,
                              and playlist: PlaylistModel) -> VideoDetailViewController {
        let view = VideoDetailViewController.initWithNib()
        let presenter = VideoDetailPresenter()
        let viewModel = VideoDetailViewModel(with: content, and: playlist)
        let wireFrame = VideoDetailWireFrame()
        let interactor = VideoDetailInteractor()

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

    class func detailViewController(with model: DownloadModel) -> VideoDetailViewController {
        let view = VideoDetailViewController.initWithNib()
        let presenter = VideoDetailPresenter()
        let viewModel = VideoDetailViewModel(download: model)
        let wireFrame = VideoDetailWireFrame()
        let interactor = VideoDetailInteractor()

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
protocol VideoDetailViewControllerInput: class {
    var myPlayer: MyCustomPlayer? {set get}
    func doReloadPlayer()
    func doReloadPlaylistView()
    func doReloadTableView()
    func doReloadTableView(_ error: NSError?)
    func doCloseSubComment()
    func doChangePlaybackRate(_ rate: Double)
    func didSelectQuality(_ model: QualityModel)
}

protocol VideoDetailViewControllerOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didSelectPlaylistItem(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didSelectPostComment(comment: String)
    func didSelectToggleFollowChannel(channelId: String)
    func didSelectFollowSuggestionChannel(channelId: String, channelName: String)
    func didSelectToggleLikeVideo(videoId: String, isSelectedLike: Bool)
    func didSelectToggleLikeComment(at indexPath: IndexPath)
    func didSelectToggleDisLikeComment(at indexPath: IndexPath)
    func didSelectShare()
    func didSelectExpandButton()
    func didSelectWatchLater()
    func didSelectActionButton(at indexPath: IndexPath)
    func didSelectPlaylistActionButton(at indexPath: IndexPath)
    func didSelectRetryButton()
    func didSelectRelatedVideo(at index: Int)
    func didSelectEditComment(id: String, comment: String)
    func doShowSubComment(at indexPath: IndexPath)
    func doDeleteComment(id: String)
    func doUpdateComment(id: String, comment: String)
    func toggleShowPlaylistItems()

    //mark: -- player delegate
    func onPlayAttempt()
    func onQualitySettings(for currentPlay: MyCustomPlayer?)
    func onSpeedSettings()
    func onReportContent()
    func onDownloadVideo()
    func onPlayerLevelAvaiable(_ levels: [QualityModel])
    func onComplete()
    func onCompleCountdown()
    func onPrevious()
    func onNext()
    func onSetupError(_ error: NSError)
    // relate video header delegate
    func onToggleAutoPlay()
    func onPause()
    func onSeeked()
    func onBuffering()
    func onFinishBuffering()
    func onPlay()
    func onReady(_ setupTime: Int)
    func onChangePlayingStrategy()
}

//========================= VIEW MODEL =================
//=======================================================
// MARK: 
// MARK: VIEW MODEL
protocol VideoDetailViewModelInput: class {
    func doUpdateWithListComment(models: [CommentModel])
    func doUpdateWithComment(model: CommentModel)
    func doUpdateWithToggleLikeVideo(isSelectLike: Bool)
    func doUpdateWithToggleLikeComment(at indexPath: IndexPath)
    func checkDownloadStatus()
}

protocol VideoDetailViewModelOutput: class {
    var contentModel: ContentModel? {get set}
    var playlistModel: PlaylistModel? {get set}
    func getVideoId() -> String
    var sections: [SectionModel] {get set}
    var playlistSections: [SectionModel] {get set}
    var playerConfig: MyCustomPlayerConfig {get set}
    var detailModel: VideoDetailModel? {get set}
    var isExpandDesc: Bool {get set}
    var isExpandPlaylist: Bool {get set}
    var changeItemWithinPlaylist: Bool {get set}
    func currentItemIndexInPlaylist() -> Int?
    func currentItemIndexInPlaylistString() -> String?    
    var isFollowChannel: Bool {get set}
    var followCount: Int {get set}
    var listComment: [CommentModel] {get set}
    var isShowCommentView: Bool {get set}
    var kpiToken: KPIToken? {get set}
    var kpiModel: KPIModel? {get set}
    var currentIndexPath: IndexPath {get set}
    var currentComment: String {get set}
    var isUpdateComment: Bool {get set}
    var currentParentComment: String {get set}
    var listPlayedVideos: [String] {get set}
    var listRemainingVideos: [String] {get set}
    var playlistName: String {get set}
    var playlistOwner: String {get set}
    var isShowSuggestions: Bool {get set}
    var listSuggestionChannel: [ChannelModel] {get set}
}

//==================== INTERACTOR =======================
//=======================================================
// MARK: 
// MARK: INTERACTOR
protocol VideoDetailInteractorInput: class {
    func getData(videoId: String, playlistId: String?, acceptLostData: Bool, completion: @escaping (Result<APIResponse<VideoDetailModel>>) -> Void)
   func postComment(type: String , parentId: String , contentID: String, comment: String, completion: @escaping (Result<APIResponse<CommentModel>>) -> Void)
    func toggleLikeVideo(videoId: String,
                         status: LikeStatus,
                         completion: @escaping (Result<APIResponse<Int>>) -> Void)
    func toggleLikeComment(type: String,
                           contentID: String,
                           commentId: String,
                           completion: @escaping (Result<Any>) -> Void)
   func toggleDisLikeComment(type: String,
                          contentID: String,
                          commentId: String,
                          completion: @escaping (Result<Any>) -> Void)
     func toggleRejectComment(isApprove: Bool, id: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void)
    func toggleFollowChannel(channelId: String,
                             status: Int,
                             notificationType: Int,
                             completion: @escaping (Result<Any>) -> Void)
    func getSuggestionsChannel(
                             completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void)
    func getListComment(type: ContentType,
                        contentId: String,
                        pager: Pager,
                        completion: @escaping (Result<APIResponse<[CommentModel]>>) -> Void)
    func registPackage(_ id: String, contentId: String, completion: @escaping(Result<APIResponse<String>>) -> Void)
    func buyRetail(_ id: String, type: ContentType, completion: @escaping (Result<APIResponse<String>>) -> Void)
    func sendWatchTime(id: String, time: Double, type: ContentType, completion: @escaping(Result<Any>) -> Void)
    func deleteComment(commentId: String, completion: @escaping (Result<APIResponse<Bool>>) -> Void)
    func updateComment(commentId: String, comment: String, completion: @escaping (Result<APIResponse<Bool>>) -> Void)
}

protocol VideoDetailInteractorOutput: class {
}

//==================== WIRE FRAME =======================
//=======================================================
// MARK: 
// MARK: WIRE FRAME
protocol VideoDetailWireFrameInput: class {
    func doShowProgress()
    func doHideProgress()
    func doShowToast(message: String)
    func doShowChannelDetail(model: ChannelModel)    
    func doShare(_ model: ContentModel)
    func doShareWithLink(_ link: String)
}

protocol VideoDetailWireFrameOutput: class {

}
