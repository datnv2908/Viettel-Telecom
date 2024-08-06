//
//  MyListViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SVPullToRefresh
import CropViewController
import Photos
import AssetsLibrary
import MobileCoreServices
import FirebasePerformance

class MyListViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var feedbackTextView: RSKGrowingTextView!
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var attackImageView: UIImageView!
    @IBOutlet weak var attackImageWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var attackImageHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnDeleteImage: UIButton!
    
    
    fileprivate var refreshControl = UIRefreshControl()
    var viewModel = MyListViewModel()
    let service = VideoServices()
    var currentOffset = Constants.kFirstOffset
    var currentLimit = Constants.kDefaultLimit
    var timer: Timer?
    private var isVisibleKeyboard = false
    let picker = UIImagePickerController()
    var lastTextViewHeight: CGFloat = 0.0
    var currentItemIndex : ContentModel?
    var curFeedBackId: String = ""
    var curFeedBackImage: UIImage?
    var trace: Trace?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: UploadTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: UploadTableViewCell.nibName())
        tableView.register(UINib(nibName: MyListTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: MyListTableViewCell.nibName())
        startTimer()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getData),
                                               name: .uploadSuccess,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scheduleReloadTableView),
                                               name: .kNotificationUploadStarted,
                                               object: nil)
        
        trace = Performance.startTrace(name:"Videocuatoi")
      feedbackTextView.backgroundColor = UIColor.setViewColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        self.registerForKeyboardNotifications()
        commentView.isHidden = true
      commentView.backgroundColor = UIColor.setViewColor()
        commentViewHeightContraint.constant = 52
        attackImageHeightContraint.constant = 0
        
        feedbackTextView.delegate = self
        lastTextViewHeight = 36
        btnDeleteImage.isHidden = true
        
        addRefreshControl()
        addScrollToLoadMore()
        self.navigationItem.title = String.video_cua_toi
        showHud()
        getData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let offset = (textView.frame.size.height - lastTextViewHeight)
        print ("Text view change ", offset)
        if(offset != 0){
            commentViewHeightContraint.constant = commentViewHeightContraint.constant + offset
            lastTextViewHeight = textView.frame.size.height
        }
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        commentView.isHidden = true
        commentViewHeightContraint.constant = commentViewHeightContraint.constant  - attackImageHeightContraint.constant
        attackImageHeightContraint.constant = 0
        btnDeleteImage.isHidden = true
    }
    
    private func adjustContent(for keyboardRect: CGRect) {
       
        let keyboardHeight = keyboardRect.height
        print("My list adjust Content ", keyboardHeight )
        let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight : 0.0;
        if(keyboardYPosition > 50){
            self.bottomSpacing.constant = keyboardYPosition - 50
        }else{
            self.bottomSpacing.constant = keyboardYPosition
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardYPosition, right: 0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.commentView.isHidden = !self.isVisibleKeyboard
        self.view.layoutIfNeeded()
    }
    
    private func registerForKeyboardNotifications() {
        weak var wself = self
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        wself?.isVisibleKeyboard = isShowing
                                        wself?.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                print("Manhhx keyboard ", isShown)
                self.isVisibleKeyboard = isShown
                if (self.isVisibleKeyboard) {
                    self.commentView.isHidden = false
                } else {
//                    self.commentView.isHidden = true
                }
        })
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        tableView?.addSubview(refreshControl)
    }
    
    func addScrollToLoadMore() {
        weak var wself = self
        tableView?.addInfiniteScrolling(actionHandler: {
            wself?.getNextPage()
        })
        tableView?.showsInfiniteScrolling = false
    }
    
    func doShowActionSheetUpload(_ model: UploadModel) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        actionController.addAction(Action(ActionData(title: String.xoa_tai_len,
                                                     image: #imageLiteral(resourceName: "iconRemoveGray")),
                                          style: .default,
                                          handler: { _ in
                                            UploadService.sharedInstance.removeItem(model)
                                            self.reloadTableView()
        }))
        present(actionController, animated: true, completion: nil)
    }

    func doShowActionSheetVideo(_ model: ContentModel) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        let watchLaterAction = Action(ActionData(title: String.them_vao_xem_sau, image: #imageLiteral(resourceName: "iconLater")),
                                      style: .default) { (action) in
                                        self.addToWatchLater(model)
        }
        let addToPlaylistAction = Action(ActionData(title: String.them_vao_danh_sach_phat, image: #imageLiteral(resourceName: "iconAddToPlaylist")),
                                         style: .default) { (action) in
                                            self.addToPlaylist(model)
        }
        let shareAction = Action(ActionData(title: String.chia_se, image: #imageLiteral(resourceName: "iconShare")),
                                 style: .default) { (action) in
                                    self.share(model)
        }
       let onTriggerComment = Action(ActionData(title: "Bat tinh nang comment", image: #imageLiteral(resourceName: "iconShare")),
                                style: .default) { (action) in
                                   self.share(model)
       }
       let offTriggerComment = Action(ActionData(title: "Tat tinh nang comment", image: #imageLiteral(resourceName: "iconShare")),
                                 style: .default) { (action) in
                                    self.share(model)
        }
        if model.status == .approved {
//            actionController.addAction(watchLaterAction)
            actionController.addAction(addToPlaylistAction)
            actionController.addAction(shareAction)
//            if DownloadManager.shared.isDownloaded(video: model.id) {
//                let downloadAction = Action(ActionData(title: String.xoa_noi_dung_khoi_thu_muc_tai_xuong, image: #imageLiteral(resourceName: "iconRemoveGray")),
//                                            style: .default) { (action) in
//                                                self.downloadVideo(model)
//                }
//                actionController.addAction(downloadAction)
//            } else {
//                let downloadAction = Action(ActionData(title: String.tai_xuong, image: #imageLiteral(resourceName: "iconDownload")),
//                                            style: .default) { (action) in
//                                                self.downloadVideo(model)
//                }
//                actionController.addAction(downloadAction)
//            }
        }
      let dispatch = DispatchGroup()
     
      dispatch.enter()
      self.showHud()
      let categoryId = "\(MoreContentType.owner.rawValue)"
      let pager = Pager(offset: Constants.kFirstOffset, limit: currentOffset + currentLimit)
      service.getMoreContents(for: categoryId, pager: pager) { (result) in
          switch result {
          case .success(let response):
            for item in response.data{
               if item.id ==  self.currentItemIndex?.id {
                  if item.status == VideoState.approved {
                  if !item.canComment {
                     let enableComment = Action(ActionData(title: String.enable_Comment,
                                                          image: #imageLiteral(resourceName: "iconComment")),
                                               style: .default,
                                               handler: { _ in
                                                 self.showHud()
                                                self.service.alowCommentForVideo(idVideo: model.id, enableComment: true) { (resurt)  in
                                                   switch resurt {
                                                   case .success(let json ) :
                                                     self.toast(json.message)
                                                      model.canComment = true
                                                      
                                                     
                                                   case .failure(let err) :
                                                      self.toast(err.localizedDescription)
                                                   }
                                                   self.hideHude()
                                                }
                                 
                     })
                     actionController.addAction(enableComment)
                  } else{
                     let diableComment = Action(ActionData(title: String.disable_Comment,
                                                          image: #imageLiteral(resourceName: "ic_not_comment")),
                                               style: .default,
                                               handler: { _ in
                                                self.showHud()
                                               self.service.alowCommentForVideo(idVideo: model.id, enableComment: false) { (resurt)  in
                                                  switch resurt {
                                                  case .success(let json ):
                                                    self.toast(json.message)
                                                    model.canComment = true
                                                  case .failure(let err) :
                                                     self.toast(err.localizedDescription)
                                                  }
                                                  self.hideHude()
                                               }
                     })
                     actionController.addAction(diableComment)
                  }
                  }
               }
            }
            self.hideHude()
            dispatch.leave()
          case .failure(_):
            self.hideHude()
            dispatch.leave()
           
          }
      }
     
        let deleteAction = Action(ActionData(title: String.xoa_video,
                                             image: #imageLiteral(resourceName: "iconRemoveGray")),
                                  style: .default,
                                  handler: { _ in
                                    self.showHud()
                                    self.service.deleteVideo(id: model.id) { (result) in
                                        self.hideHude()
                                        switch result {
                                        case .success(let response):
                                            self.viewModel.removeContent(model)
                                            self.tableView.reloadData()
                                            self.toast(response.message)
                                        case .failure(let error):
                                            self.toast(error.localizedDescription)
                                        }
                                    }
        })
      dispatch.notify(queue: .main) {
         actionController.addAction(deleteAction)
         self.present(actionController, animated: true, completion: nil)
      }
    }
    
    @objc func getData() {
        let categoryId = "\(MoreContentType.owner.rawValue)"
        let pager = Pager(offset: Constants.kFirstOffset, limit: currentLimit)
        service.getMoreContents(for: categoryId, pager: pager) { (result) in
            switch result {
            case .success(let response):
                self.viewModel.contents = response.data
                self.reloadTableView()
                self.currentOffset = pager.offset
                if response.data.count < pager.limit {
                    self.tableView.showsInfiniteScrolling = false
                    
                    if(response.data.count == 0){
                        self.tableView?.backgroundView = self.emptyView()
                    }
                    
                } else {
                    self.tableView.showsInfiniteScrolling = true
                }
                LoggingRecommend.viewMyVideos(noVideos: response.data.count)
            case .failure(_):
                break
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView?.infiniteScrollingView.stopAnimating()
            self.hideHude()
            self.trace?.stop()
        }
    }
    
    func getNextPage() {
        let categoryId = "\(MoreContentType.owner.rawValue)"
        let pager = Pager(offset: currentOffset + currentLimit, limit: currentLimit)
        service.getMoreContents(for: categoryId, pager: pager) { (result) in
            switch result {
            case .success(let response):
                let  newViewModel = MyListViewModel()
                newViewModel.doUpdateWithData(response.data)
                self.viewModel.contents.append(contentsOf: newViewModel.contents)
                self.reloadTableView()
                self.currentOffset = pager.offset
                if response.data.count < pager.limit {
                    self.tableView.showsInfiniteScrolling = false
                } else {
                    self.tableView.showsInfiniteScrolling = true
                }
            case .failure(_):
                break
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView?.infiniteScrollingView.stopAnimating()
            self.hideHude()
        }
    }
    func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item, identifier: MyListTableViewCell.nibName())
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = nil
        weak var wself = self
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                wself?.scheduleReloadTableView()
            })
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(scheduleReloadTableView),
                                         userInfo: nil,
                                         repeats: true)
        }
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func reloadTableView() {
        viewModel.doUpdateWithData(viewModel.contents)
        self.tableView.reloadData()
    }
    
    @objc func scheduleReloadTableView() {
        if UploadService.sharedInstance.listVideoUpload.isEmpty {
            stopTimer()
            return
        }
        if timer == nil {
            startTimer()
        }
        viewModel.doUpdateWithData(viewModel.contents)
        self.tableView.reloadData()
    }
    
    @IBAction func actionPickImage(_ sender: Any) {
        picker.delegate = self
        let alertController = UIAlertController(title: String.chon_anh,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: String.chon_tu_thu_vien, style: .default) { (_) in
            self.takePhotoFromLibrary(sender as! UIButton)
        }
        let takePhotoAction = UIAlertAction(title: String.chup_anh, style: .default) { (_) in
            self.shootPhoto(sender as! UIButton)
        }
        let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in
            
        }
        alertController.addAction(galleryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoFromLibrary(_ sender: UIButton) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
        picker.modalPresentationStyle = .fullScreen
        picker.popoverPresentationController?.sourceView = view
        let midX = view.bounds.midX
        let midY = view.bounds.midY
        picker.popoverPresentationController?.sourceRect = CGRect(x: midX, y: midY, width: 0, height: 0)
        present(picker, animated: true, completion: nil)
    }
    
    func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.popoverPresentationController?.sourceView = view
            let midX = view.bounds.midX
            let midY = view.bounds.midY
            picker.popoverPresentationController?.sourceRect = CGRect(x: midX, y: midY, width: 0, height: 0)
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        alertWithTitle(nil, message: String.thiet_bi_cua_ban_khong_the_chup_anh)
    }
    
    
    @IBAction func actionDeleteImage(_ sender: Any) {
        commentViewHeightContraint.constant = commentViewHeightContraint.constant  - attackImageHeightContraint.constant
        attackImageHeightContraint.constant = 0
        btnDeleteImage.isHidden = true
        curFeedBackImage = nil
    }
    
    @IBAction func actionSendFeedback(_ sender: Any) {
        if (!self.feedbackTextView.hasText)
        {
            self.toast(String.nhap_noi_dung_phan_hoi)
            return
        }
        self.showHud()
        APIRequestProvider.shareInstance.sendVideoFeedBack(videoId: curFeedBackId, feedbackContent: feedbackTextView.text, feedbackFile: curFeedBackImage){ (result) in
            switch result {
            case .success(_):
                self.toast(String.gui_phan_hoi_thanh_cong)
                self.dismissKeyboard()
                self.getData()
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
    
    deinit {
        service.cancelAllRequests()
        stopTimer()
        NotificationCenter.default.removeObserver(self)
        self.rsk_unsubscribeKeyboard()
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.viewModel.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        cell.bindingWithModel(model)
        if let cell = cell as? MyListTableViewCell {
            cell.delegate = self
            if let rowModel = model as? VideoRowModel {
                cell.viewCountLabel.text = rowModel.postedAt
                if rowModel.videoState == .pending {
                    cell.postedByLabel.text = rowModel.videoState.value()
                    cell.postedByLabel.numberOfLines = 2
                    cell.titleLabel?.numberOfLines = 1
                    cell.feedbackButton.isHidden = true
                } else if rowModel.videoState == . refuse {
                    if !rowModel.reason.isEmpty {
                        cell.postedByLabel.text = rowModel.videoState.value() + " (\(String.ly_do): \(rowModel.reason))"
                    } else {
                        cell.postedByLabel.text = rowModel.videoState.value()
                    }
                    cell.postedByLabel.numberOfLines = 2
                    cell.titleLabel?.numberOfLines = 1
                    
                    cell.feedbackButton.isHidden = false
                    if(rowModel.feedbackStatus != ""){
                        cell.feedbackButton.setTitle(String.da_gui_y_kien.uppercased(),for: .normal)
                        cell.feedbackButton.setTitleColor(UIColor.colorFromHexa("9b9b9b"), for: .normal)
                    }else{
                        cell.feedbackButton.setTitle(String.gui_y_kien.uppercased(),for: .normal)
                        cell.feedbackButton.setTitleColor(UIColor.colorFromHexa(Constants.mainColorHex), for: .normal)
                    }
                    
                } else {
                    cell.postedByLabel.text = rowModel.viewCount
                    cell.postedByLabel.numberOfLines = 1
                    cell.titleLabel?.numberOfLines = 2
                    cell.feedbackButton.isHidden = true
                }
            }
        }
        if let cell = cell as? UploadTableViewCell {
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if viewModel.sections.count > 1 {
            if indexPath.section == 0 {
                return 70
            } else {
                return 89
            }
        }
        return 89
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.sections.count > 1 {
            if section == 0 {
                let headerView = Bundle.main.loadNibNamed("UploadHeaderView",
                                                          owner: self,
                                                          options: nil)![0] as? UploadHeaderView

                let count = UploadService.sharedInstance.listVideoUpload.count
                headerView?.titleLabel?.text = "\(String.dang_tai_len.uppercased()) (\(count))"
                return headerView
            } else {
                return UIView()
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sections.count > 1 {
            if section == 0 {
                return 40
            } else {
                return 0.01
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = AppColor.grayBackgroundColor()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.sections.count > 1 {
            if section == 0 {
                return 1
            } else {
                return 0.01
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        if let rowModel = viewModel.sections[indexPath.section].rows[indexPath.row] as? VideoRowModel {
            if tableView.cellForRow(at: indexPath) is MyListTableViewCell
                && rowModel.videoState == .approved {
                showVideoDetails(viewModel.contents[indexPath.row])
            }
        }
    }
    
}

extension MyListViewController: MyListTableViewCellDelegate {
    func videoFeedbackRejectReason(_ cell: MyListTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let model = self.viewModel.sections[indexPath.section].rows[indexPath.row]
            if let rowModel = model as? VideoRowModel {
                if(rowModel.feedbackStatus == ""){
                    if(commentView.isHidden){
                        if(curFeedBackId != rowModel.objectID){
                           curFeedBackId = rowModel.objectID
                           feedbackTextView.text = ""
                        }
                        feedbackTextView.becomeFirstResponder()
                    }
                }else{
                    if(rowModel.feedbackStatus == "1"){
                        let alert = UIAlertController(title:  String.notification, message: String.phan_hoi_dang_duoc_quan_tri_vien_xem_xet, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: String.dong, style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }else if(rowModel.feedbackStatus == "3"){
                        
                        let alert = UIAlertController(title:  String.notification, message: "\(String.noi_dung_khong_duoc_chap_nhan_voi_ly_do): " + rowModel.feedbackRejectReason, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: String.dong, style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func videoSmallImageTableViewCell(_ cell: MyListTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
           self.currentItemIndex = viewModel.contents[indexPath.row]
            doShowActionSheetVideo(viewModel.contents[indexPath.row])
           
        }
    }
}

extension MyListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) else { return }
        
        curFeedBackImage = image
        
        if(image.size.height / image.size.width > 1){
            attackImageWidthContraint.constant = 80
            attackImageHeightContraint.constant = 80 * image.size.height / image.size.width
        }else{
            attackImageWidthContraint.constant = 100
            attackImageHeightContraint.constant = 100 * image.size.height / image.size.width
        }
        attackImageView.image = image
        commentViewHeightContraint.constant = attackImageHeightContraint.constant  + lastTextViewHeight + 14
        btnDeleteImage.isHidden = false
        
        self.dismiss(animated: true, completion: nil)
        self.commentView.isHidden = false
        self.feedbackTextView.becomeFirstResponder()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.commentView.isHidden = false
        self.feedbackTextView.becomeFirstResponder()
    }
}

extension MyListViewController: UploadTableViewCellDelegate {
    func uploadTableViewCell(_ cell: UploadTableViewCell, didSelectEditButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            doShowActionSheetUpload(UploadService.sharedInstance.listVideoUpload[indexPath.row])
        }
    }
    
    func uploadTableViewCell(_ cell: UploadTableViewCell, didSelectRetryButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            UploadService.sharedInstance.retry(at: indexPath.row)
        }
    }
}
