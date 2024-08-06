//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit
import RSKKeyboardAnimationObserver
import GoogleCast
import SnapKit

@objcMembers
class VideoDetailViewController: BaseViewController, UITextViewDelegate {
    var presenter: VideoDetailViewControllerOutput?
    var viewModel: VideoDetailViewModelOutput?
    @IBOutlet weak var miniPlayerControl: UIView!
    @IBOutlet weak var miniPlayerControlHeight: NSLayoutConstraint!
    @IBOutlet weak var miniPlayerControlLeft: NSLayoutConstraint!
    
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var playerViewBG: UIView!
    @IBOutlet weak var heightPlayerView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playlistTableView: UITableView!
    @IBOutlet weak var growTextView: RSKGrowingTextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    private var isVisibleKeyboard = true
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var subCommentView: UIView!
    @IBOutlet weak var subCommentBottomSpacing: NSLayoutConstraint!
    var subCommentVC: SubCommentViewController?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playlistHeaderView: UIView!
    @IBOutlet weak var playlistHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playlistContentView: UIView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playlistDescriptionLabel: UILabel!
    @IBOutlet weak var playlistIndexLabel: UILabel!
    @IBOutlet weak var playlistExpandArrow: UIImageView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDesLabel: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var detailBgView: UIView!
    @IBOutlet weak var miniChromeCastView: UIView!
    @IBOutlet weak var miniChromeCastViewHeight: NSLayoutConstraint!
    var miniChromecastPlayerVC: GCKUIMiniMediaControlsViewController!
    var castContainerVC: GCKUICastContainerViewController!
    
    var isPresented = true
    var canAutoPlay = false
    var isLive = false
    public var myPlayer: MyCustomPlayer? = MyCustomPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        commentView.backgroundColor = UIColor.setViewColor()
        initVideoPlayer()
        presenter?.viewDidLoad()
        self.view.backgroundColor = UIColor.setViewColor()
        self.btnClose.setImage(DataManager.getStatusbarVaule() ? UIImage(named: "ic_close") : UIImage(named: "ic_close_white"), for: .normal)
       self.tableView.backgroundColor = UIColor.setViewColor()
        let castContext = GCKCastContext.sharedInstance()
        miniChromecastPlayerVC = castContext.createMiniMediaControlsViewController()
        miniChromecastPlayerVC.delegate = self
        miniChromecastPlayerVC.view.backgroundColor = AppColor.blackBackgroundColor()
        let btnPlay = miniChromecastPlayerVC.customButton(at: UInt(GCKUIMediaButtonType.playPauseToggle.rawValue))
        btnPlay?.setTitleColor(UIColor.white, for: .normal)
        btnPlay?.tintColor = UIColor.white
        detailBgView.backgroundColor = UIColor.setViewColor()
        self.addChild(miniChromecastPlayerVC)
        miniChromecastPlayerVC.view.frame = miniChromeCastView.bounds
        miniChromeCastView.addSubview(miniChromecastPlayerVC.view)
        miniChromecastPlayerVC.didMove(toParent: self)
        miniChromecastPlayerVC.view.snp.remakeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
//      growTextView.
      growTextView.delegate = self
      growTextView.backgroundColor = UIColor.setViewColor()
      let str = String.viet_binh_luan
      let placehoder = str as NSString
      growTextView.placeholder = placehoder
      self.growTextView.backgroundColor = UIColor.setViewColor()
        self.videoTitleLabel.textColor = UIColor.settitleColor()
        self.videoDesLabel.textColor = UIColor.settitleColor()
        updateMiniPlayer()
        logScreen(GoogleAnalyticKeys.videoDetails.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        presenter?.viewWillDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        if let memberModel = DataManager.getCurrentMemberModel() {
            avatarImageView.kf.setImage(with: URL(string: memberModel.avatarImage), placeholder: #imageLiteral(resourceName: "iconUserCopy"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        viewModel?.isShowSuggestions = false
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.rsk_unsubscribeKeyboard()
    }
    
    func updateMiniPlayer() {
        
        if GCKCastContext.sharedInstance().castState == .connected {
            if miniChromecastPlayerVC.active {
                miniChromeCastViewHeight.constant = 60
            } else {
                miniChromeCastViewHeight.constant = 0
            }
        } else {
            miniChromeCastViewHeight.constant = 0
        }
    }
    
    @IBAction func onClickSendButton(_ sender: Any) {
        if (viewModel?.isUpdateComment)! {
            presenter?.doUpdateComment(id: (viewModel?.currentComment)!, comment: growTextView.text)
        } else {
            presenter?.didSelectPostComment(comment: growTextView.text)
        }
        growTextView.text = ""
        growTextView.resignFirstResponder()
    }
    
    @IBAction func toggleShowPlaylistItems(_ sender: Any) {
        presenter?.toggleShowPlaylistItems()
    }
    
    func initVideoPlayer() {
        myPlayer?.translatesAutoresizingMaskIntoConstraints = true
        // 10 = height of 1/2 slider in playerView
        myPlayer?.frame = CGRect(x: 0, y: 0,
                                width: Constants.screenWidth,
                                height: Constants.videoPlayerHeight + CGFloat(kSpaceForSeek))
        miniPlayerControl.dropShadow(color: UIColor.setViewColor(), opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        miniPlayerControl.backgroundColor = UIColor.setViewColor()
        heightPlayerView.constant = Constants.videoPlayerHeight + CGFloat(kSpaceForSeek)
        playerContainerView.addSubview(myPlayer!)
        myPlayer?.delegate = self
    }
    
    @IBAction func btnPlay_action(_ sender: UIButton) {
        if (self.btnPlay.isSelected) {
            myPlayer?.pause()
        } else {
            myPlayer?.play()
        }
    }
    
    @IBAction func btnClose_action(_ sender: UIButton) {

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      //300 chars restriction
      return textView.text.count + (text.count - range.length) < 1000
  }
    // MARK: 
  // MARK: METHODS
    override func setupView() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tap)
        commentView.isHidden = true
        
        let cellNibname = [VideoInfoTableViewCell.nibName(),
                           ChannelInfoTableViewCell.nibName(),
                           ChannelDescTableViewCell.nibName(),
                           VideoSmallImageTableViewCell.nibName(),
                           CommentTableViewCell.nibName(),
                           RelateVideoTableViewCell.nibName(),
                           ReplyCommentTableViewCell.nibName(),
                           CommentInfoTableViewCell.nibName()]
        
        for item in cellNibname {
            tableView.register(UINib(nibName: item, bundle: nil), forCellReuseIdentifier: item)
        }
        
        tableView.register(UINib(nibName: RelateVideoHeaderView.nibName(), bundle: nil), forHeaderFooterViewReuseIdentifier: RelateVideoHeaderView.nibName())
        playlistTableView.register(UINib(nibName: VideoDetailPlaylistHeaderView.nibName(), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: VideoDetailPlaylistHeaderView.nibName())
        setupForSubCommentView()
    }
    
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height
        // fix bug keyboard
        let offset: CGFloat = Constants.hasSafeArea ? 35 : 0
        
        let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight - offset : 0.0;
        self.bottomSpacing.constant = keyboardYPosition
        self.view.layoutIfNeeded()
    }
    
    private func registerForKeyboardNotifications() {
        weak var wself = self
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        wself?.isVisibleKeyboard = isShowing
                                        wself?.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
                if (self.isVisibleKeyboard) {
                    if (self.viewModel?.isShowCommentView) == true {
                        self.commentView.isHidden = false
                    }
                } else {
                    self.viewModel?.isShowCommentView = false
                    self.commentView.isHidden = true
                    self.growTextView.resignFirstResponder()
                  
                }
        })
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    func setupForSubCommentView() {
        subCommentVC = SubCommentViewController.init((viewModel?.getVideoId())!)
        addChild(subCommentVC!)
        subCommentView.addSubview(subCommentVC!.view)
        subCommentVC!.view.snp.makeConstraints { (constraintMaker) in
            constraintMaker.edges.equalToSuperview()
        }
        subCommentVC!.didMove(toParent: self)
        subCommentVC?.delegate = self
        subCommentBottomSpacing.constant = -self.tableView.frame.size.height
    }
    
    func reloadSubComment() {
        if !(viewModel?.currentComment.isEmpty)! {
            for item in (viewModel?.listComment)! {
                if item.id == viewModel?.currentParentComment {
                    subCommentVC?.doUpdateWithComment(item)
                }
            }
        }
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        commentView.isHidden = true
    }

    func setPlaylistContent(hidden: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0, options: hidden ? .curveEaseOut : .curveEaseIn , animations: {
            self.playlistContentView.isHidden = hidden
        }) { (success) in

        }
    }

    func setContentViewAlpha(_ alpha: CGFloat) {
        playerViewBG.alpha = alpha
        tableView.alpha = alpha
        subCommentView.alpha = alpha
//        if alpha == 1 {
//            myPlayer?.viewPlayBackControls.seekSlider.alpha = alpha;
//        }else {
//            myPlayer?.viewPlayBackControls.seekSlider.alpha = 0;
//        }
    }
    
    func setMiniPlayerViewAlpha(_ alpha: CGFloat) {
        miniPlayerControl.alpha = alpha
    }

    deinit {
        DLog("")
    }
}

extension VideoDetailViewController: VideoDetailViewControllerInput {
    func doReloadPlayer() {
        myPlayer?.loadConfig(viewModel?.playerConfig)        
    }    

    func doReloadPlaylistView() {
        guard let model = viewModel?.detailModel else {
            return
        }
        // show/hide Playlist view
        if model.playlist.videos.isEmpty {
            playlistHeaderView.isHidden = true
            playlistHeaderViewHeight.constant = 0
            setPlaylistContent(hidden: true)
        } else {
            playlistHeaderView.isHidden = false
            playlistHeaderViewHeight.constant = 40
            setPlaylistContent(hidden: !(viewModel?.isExpandPlaylist)!)
        }

        if viewModel?.isExpandPlaylist == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.playlistExpandArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.playlistExpandArrow.transform = CGAffineTransform(rotationAngle: 0)
            })
        }

        playListNameLabel.text = viewModel?.playlistName
        playlistDescriptionLabel.text = viewModel?.playlistOwner
        playlistIndexLabel.text = viewModel?.currentItemIndexInPlaylistString()
        playlistTableView.reloadData()
        if let index = viewModel?.currentItemIndexInPlaylist() {
            playlistTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        }
    }

    func doReloadTableView() {
        self.tableView.reloadData()
        self.playlistTableView.reloadData()
        doReloadPlaylistView()
    }
    
    func doReloadTableView(_ error: NSError?) {
        if viewModel?.detailModel != nil { // detail model != nil => donot show empty view.
            self.tableView.reloadData()
            return
        }
        if error?.code == NSURLErrorNotConnectedToInternet ||
            error?.code == NSURLErrorNetworkConnectionLost || viewModel?.detailModel == nil {
            tableView.backgroundView = emptyView()
        } else {
            self.toast((error?.localizedDescription)!)
        }
        self.tableView.reloadData()
    }

    func doCloseSubComment() {
        viewModel?.currentParentComment = ""
        growTextView.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.subCommentBottomSpacing.constant = -self.tableView.frame.size.height
            self.subCommentView.isHidden = true
        }, completion: nil)
    }
    
    func doChangePlaybackRate(_ rate: Double) {
        myPlayer?.playbackRate = CGFloat(rate)
    }
    
    func didSelectQuality(_ model: QualityModel) {
        myPlayer?.loadQuality(model)
    }
}

extension VideoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == playlistTableView {
            return (viewModel?.playlistSections.count)!
        } else {
            return (viewModel?.sections.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == playlistTableView {
            let section = viewModel?.playlistSections[section]
            return (section?.rows.count)!
        } else {
            let section = viewModel?.sections[section]
            return (section?.rows.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var rowModel: PBaseRowModel?
        if tableView == playlistTableView {
            rowModel = viewModel?.playlistSections[indexPath.section].rows[indexPath.row]
        } else {
            rowModel = viewModel?.sections[indexPath.section].rows[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: (rowModel?.identifier)!,
                                                 for: indexPath) as! BaseTableViewCell
        cell.bindingWithModel(rowModel!)
        
        if let commentCell = cell as? CommentTableViewCell {
            if (viewModel?.detailModel?.relates.videos.isEmpty)!  {
                commentCell.topLineView.isHidden = true
            } else {
                commentCell.topLineView.isHidden = false
            }
         if let model = (viewModel?.detailModel?.detail) {
            commentCell.CommentBtn.isUserInteractionEnabled = model.canComment
         }
         
         
            commentCell.setImageAvatar()
            commentCell.delegate = self
        }
        
        if let channelInfoCell = cell as? ChannelInfoTableViewCell {
            videoDesLabel.text = rowModel?.title
            channelInfoCell.delegate = self
            channelInfoCell.bindingWithModel((viewModel?.isFollowChannel)!,
                                             followCount: (viewModel?.followCount)!,
                                             isShowSuggestions: (viewModel?.isShowSuggestions)!,
                                             suggestionsList: (viewModel?.listSuggestionChannel)!)
        }
        if let videoInfoCell = cell as? VideoInfoTableViewCell {
            videoTitleLabel.text = rowModel?.title
            videoInfoCell.delagate = self
        }
        if let commentInfoCell = cell as? CommentInfoTableViewCell {
         if let model = (viewModel?.detailModel?.detail) {
         commentInfoCell.commentButton.isUserInteractionEnabled = model.canComment
           
         }
         commentInfoCell.delegate = self
        }
        if let cell = cell as? VideoSmallImageTableViewCell {
            cell.delegate = self
        }
        if let cell = cell as? VideoPlaylistItemTableViewCell {
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let model = viewModel else {
            return 0.01
        }
        var headerModel: PBaseHeaderModel?
        if tableView == playlistTableView {
            headerModel = model.playlistSections[section].header
        } else {
            headerModel = model.sections[section].header
        }
        if let identifier = headerModel?.identifier {
            return UITableView.automaticDimension
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = viewModel else {
            return nil
        }
        var headerModel: PBaseHeaderModel?
        var sectionModel: SectionModel?
        if tableView == playlistTableView {
            headerModel = model.playlistSections[section].header
            sectionModel = model.playlistSections[section]
        } else {
            headerModel = model.sections[section].header
            sectionModel = model.sections[section]
        }

        if (sectionModel?.rows.isEmpty)! {
            return nil
        }
        if let header = headerModel, let identifier = headerModel?.identifier {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! BaseTableHeaderView
            headerView.bindingWithModel(header, section: section)
            if let view = headerView as? RelateVideoHeaderView {
                view.delegate = self
            }
            if let view = headerView as? VideoDetailPlaylistHeaderView {
                view.delegate = self
            }
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        myPlayer?.viewPlayBackControls.viewNextVideo.isHidden = true
        if tableView == playlistTableView {
            presenter?.didSelectPlaylistItem(at: indexPath)
        } else {
            presenter?.didSelectRow(at: indexPath)
        }
    }
    
    func showActionComment(_ id: String, comment: String = "") {
        let actionsheetController = ActionSheetViewController()
        let updateComment = Action(ActionData(title: String.chinh_sua, image: UIImage()),
                                      style: .default) { (action) in
                                        self.viewModel?.isUpdateComment = true
                                        self.viewModel?.isShowCommentView = true
                                        self.growTextView.becomeFirstResponder()
                                        self.viewModel?.currentComment = id
                                        if !comment.isEmpty {
                                            self.growTextView.text = comment
                                        }
        }
        let deleteComment = Action(ActionData(title: String.xoa, image: UIImage()),
                                         style: .default) { (action) in
                                        self.presenter?.doDeleteComment(id: id)
        }
        actionsheetController.addAction(updateComment)
        actionsheetController.addAction(deleteComment)
        present(actionsheetController, animated: true, completion: nil)
    }
}

extension VideoDetailViewController: VideoSmallTableViewCellDelegate {
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter?.didSelectActionButton(at: indexPath)
        }
    }
}

extension VideoDetailViewController: CommentTableViewCellDelegate {
    func commentTableViewCell(_ cell: CommentTableViewCell, didClickComment sender: UIButton) {
        if !DataManager.isLoggedIn() {
            weak var wself = self
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.viewModel?.currentComment = ""
                    wself?.viewModel?.isShowCommentView = true
//                    self.growTextView.becomeFirstResponder()
                }
            })
        } else {
            viewModel?.currentComment = ""
            viewModel?.currentParentComment = ""
            viewModel?.currentIndexPath = IndexPath(row: 0, section: 0)
            self.viewModel?.isShowCommentView = true
            if growTextView.canBecomeFirstResponder {
                growTextView.becomeFirstResponder()
            }
        }
    }
}

extension VideoDetailViewController: ChannelInfoTableViewCellDelegate {
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell, didClickOnFollow sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if let _ = tableView.indexPath(for: cell), let model = viewModel?.detailModel {
            self.presenter?.didSelectToggleFollowChannel(channelId: model.detail.owner.id)
        }
    }
    
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell, didClickOnCloseSuggestion sender: UIButton) {
        viewModel?.isShowSuggestions = false
        tableView.reloadData()
    }
    
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell, didClickOnFollowSuggestionChannel channelModel: ChannelModel) {
         self.presenter?.didSelectFollowSuggestionChannel(channelId: channelModel.id, channelName: channelModel.name)
    }
    
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell, didClickGoSuggestionChannelDetail channelModel: ChannelModel) {
      self.showChannelDetails(channelModel, isMyChannel: false)
    }
}

extension VideoDetailViewController: VideoInfoTableViewCellDelegate {
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnDislike sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        self.presenter?.didSelectToggleLikeVideo(videoId: (viewModel?.getVideoId())!, isSelectedLike: false)
    }
    
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnLike sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        self.presenter?.didSelectToggleLikeVideo(videoId: (viewModel?.getVideoId())!, isSelectedLike: true)
    }
    
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnShare sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        self.presenter?.didSelectShare()
    }
    
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnDownload sender: UIButton) {
        self.presenter?.onDownloadVideo()
    }
    
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnWatchLater sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        presenter?.didSelectWatchLater()
    }
    
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell, didClickOnExpandButton sender: UIButton) {
        presenter?.didSelectExpandButton()
    }
}

extension VideoDetailViewController: CommentInfoTableViewCellDelegate {
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickLike sender: UIButton) {
        if let path = tableView.indexPath(for: cell) {
            self.presenter?.didSelectToggleLikeComment(at: path)
        }
    }
    
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickComment sender: UIButton) {
        if let path = tableView.indexPath(for: cell) {
            let model = viewModel?.listComment[path.row-1]
            self.viewModel?.isShowCommentView = true
            growTextView.becomeFirstResponder()
            viewModel?.currentComment = (model?.id)!
            subCommentView.isHidden = false
         subCommentVC?.doUpdateWithComment(model!)
            viewModel?.currentParentComment = (model?.id)!
            viewModel?.currentIndexPath = path
            UIView.animate(withDuration: 0.2, animations: {
                self.subCommentBottomSpacing.constant = 0
            }, completion: nil)
        }
    }
    
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didSelectEdit sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let model = self.viewModel?.listComment[indexPath.row-1]
            if let user = DataManager.getCurrentMemberModel() {
                if model?.userId == user.userId {
                    viewModel?.currentParentComment = (model?.id)!
                    viewModel?.currentIndexPath = indexPath
                    presenter?.didSelectEditComment(id: (model?.id)!, comment: (model?.comment)!)
                }
            }
        }
    }
   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectRejectComment sender: UIButton) {
   }
   func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, didClickDisLike sender: UIButton) {
      if let path = tableView.indexPath(for: cell) {
          self.presenter?.didSelectToggleDisLikeComment(at: path)
      }
      
   }
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell, onSelectShowSubComment sender: UIButton) {
        if let path = tableView.indexPath(for: cell) {
            let model = viewModel?.listComment[path.row-1]
            self.viewModel?.isShowCommentView = true
            
            viewModel?.currentComment = (model?.id)!
            viewModel?.currentParentComment = (model?.id)!
            viewModel?.currentIndexPath = path
            subCommentView.isHidden = false
         if let data = (viewModel?.detailModel?.detail) {
            subCommentVC?.canComment = data.canComment
         }
         subCommentVC?.doUpdateWithComment(model!)
            UIView.animate(withDuration: 0.2, animations: {
                self.subCommentBottomSpacing.constant = 0
            }, completion: nil)
        }
    }
}

extension VideoDetailViewController: RelateVideoHeaderViewDelegate {
    func relatedVideoHeaderView(_ view: RelateVideoHeaderView, toggleAutoPlay sender: UISwitch) {
        presenter?.onToggleAutoPlay()
    }
}

extension VideoDetailViewController: SubCommentViewControllerDelegate {
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectClose sender: UIButton) {
        viewModel?.currentParentComment = ""
        growTextView.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.subCommentBottomSpacing.constant = -self.tableView.frame.size.height
            self.subCommentView.isHidden = true
        }, completion: nil)
    }
    
    func subCommentViewController(_ viewController: SubCommentViewController,
                                  didSelectLikeComment sender: UIButton, 
                                  at indexPath: IndexPath) {
        guard let viewModel = self.viewModel else {
            return
        }
        var tmp: CommentModel?
        var tmpIndex = 0
        if !(viewModel.currentComment.isEmpty) {
            for (index,comment) in (viewModel.listComment).enumerated() where comment.id == viewModel.currentComment {
                if indexPath.row == 0 {
                    self.presenter?.didSelectToggleLikeComment(at: viewModel.currentIndexPath)
                    tmp = viewModel.listComment[viewModel.currentIndexPath.row - 1]
                    tmpIndex = viewModel.currentIndexPath.row - 1
                } else {
                    let subComment = comment.subComments[indexPath.row-1]
                    if subComment.isLike {
                        subComment.likeCount -= 1
                    } else {
                        subComment.likeCount += 1
                    }
                  if subComment.isDisLike {
                     var data = Int(subComment.disLikeCount) ?? 0
                     data -= 1
                     subComment.isDisLike = false
                  }
                    subComment.isLike = !subComment.isLike
                    comment.subComments[indexPath.row-1] = subComment
                    tmp = comment
                    tmpIndex = index
                }
            }
            if let value = tmp {
                self.viewModel?.listComment[tmpIndex] = value
            }
        }
    }
   func subCommentViewController(_ viewController: SubCommentViewController,
                                 didSelectDisLikeComment sender: UIButton,
                                 at indexPath: IndexPath) {
       guard let viewModel = self.viewModel else {
           return
       }
       var tmp: CommentModel?
       var tmpIndex = 0
       if !(viewModel.currentComment.isEmpty) {
           for (index,comment) in (viewModel.listComment).enumerated() where comment.id == viewModel.currentComment {
               if indexPath.row == 0 {
                   self.presenter?.didSelectToggleDisLikeComment(at: viewModel.currentIndexPath)
                   tmp = viewModel.listComment[viewModel.currentIndexPath.row - 1]
                   tmpIndex = viewModel.currentIndexPath.row - 1
               } else {
                   let subComment = comment.subComments[indexPath.row-1]
                  var disLikeCount = Int(subComment.disLikeCount) ?? 0
                   if subComment.isDisLike {
                     disLikeCount -= 1
                   } else {
                     disLikeCount += 1
                   }
                  if subComment.isLike {
                      subComment.likeCount -= 1
                     subComment.isLike = false
                  }
                  subComment.isDisLike = !subComment.isDisLike
                   comment.subComments[indexPath.row-1] = subComment
                   tmp = comment
                   tmpIndex = index
               }
           }
           if let value = tmp {
               self.viewModel?.listComment[tmpIndex] = value
           }
       }
   }
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectEditCommentId id: String, comment: String) {
        showActionComment(id, comment: comment)
    }
    
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectEditCommentId comment: CommentModel) {
        if let user = DataManager.getCurrentMemberModel() {
            if comment.userId == user.userId {
                showActionComment(comment.id, comment: comment.comment)
            }
        }
    }
    
    func subCommentViewController(_ viewController: SubCommentViewController, didSelectShowTextView sender: UIButton) {
        self.viewModel?.isShowCommentView = true
        growTextView.becomeFirstResponder()
    }
}

extension VideoDetailViewController: MyCustomPlayerDelegate {
    func onPlayAttempt() {
        presenter?.onPlayAttempt()
    }
    
    func onComplete() {
        presenter?.onComplete()
    }

    func onCompleCountdown() {
        presenter?.onCompleCountdown()
    }

    func onSetupError(_ error: Error!) {
//        self.toast(error.localizedDescription)
    }
    
    func onRequestToShowQualitySettings() {
        presenter?.onQualitySettings(for: myPlayer)
    }
    
    func onRequestToShowSpeedSettings() {
        presenter?.onSpeedSettings()
    }
    
    func onRequestToShowReport() {
        presenter?.onReportContent()
    }
    
    func onLevels(_ levels: [Any]!) {
        presenter?.onPlayerLevelAvaiable(levels as! [QualityModel])
    }
    
    func selectRelatedItem(at index: Int) {
        presenter?.didSelectRelatedVideo(at: index)
    }

    func onPrevious() {
        presenter?.onPrevious()
    }

    func onNext() {
        presenter?.onNext()
    }
    
    func onPause(_ oldState: String!) {
        presenter?.onPause()
        self.btnPlay.isSelected = false
    }
    
    func onSeeked() {
        presenter?.onSeeked()
    }
    
    func onBuffering() {
        presenter?.onBuffering()
    }
    
    func onFinishBuffering() {
        presenter?.onFinishBuffering()
    }
    
    func onPlay(_ oldState: String!) {
        presenter?.onPlay()
        self.btnPlay.isSelected = true
    }
    
    func onAddToPlaylist() {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        presenter?.didSelectWatchLater()
    }
    
    func onShare() {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        presenter?.didSelectShare()
    }
    
    func onReady(_ setupTime: Int) {
        presenter?.onReady(setupTime)
    }
}

extension VideoDetailViewController: VideoPlaylistTableViewCellDelegate {
    func didClickOnAction(_ cell: VideoPlaylistItemTableViewCell) {
        if let indexPath = playlistTableView.indexPath(for: cell) {
            presenter?.didSelectPlaylistActionButton(at: indexPath)
        }
    }
}

extension VideoDetailViewController: VideoDetailPlaylistHeaderViewDelegate {
    func onRandom(_ view: VideoDetailPlaylistHeaderView) {
        presenter?.onChangePlayingStrategy()
    }

    func onRepeat(_ view: VideoDetailPlaylistHeaderView) {
        presenter?.onChangePlayingStrategy()
    }
}

extension VideoDetailViewController: GCKUIMiniMediaControlsViewControllerDelegate {
    public func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                                shouldAppear: Bool) {
        updateMiniPlayer()
    }
}
