//
//  DownloadViewController.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 11/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class DownloadViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel = DownloadViewModel()
    var timer: Timer?

    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setupView() {
        let nibName = DownloadVideoTableViewCell.nibName()
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
        self.title = String.video_tai_xuong
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.tableView.tableHeaderView = view
        tableView.register(UINib(nibName: DownloadVideoTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: DownloadVideoTableViewCell.nibName())
        tableView.register(UINib(nibName: VideoSmallImageTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: VideoSmallImageTableViewCell.nibName())
        tableView.register(UINib(nibName: UploadHeaderView.nibName(), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: UploadHeaderView.nibName())
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scheduleReloadTableView),
                                               name: .kNotificationDownloadStarted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchAllVideo),
                                               name: .kNotificationDownloadCompleted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchAllVideo),
                                               name: .kNotificationRemovedDownloadItem,
                                               object: nil)
        fetchAllVideo()
        startTimer()
    }
    
    @objc func fetchAllVideo() {
        viewModel = DownloadViewModel()
        reloadData()
    }

    func reloadData() {
        var count: Int = 0
        for item in viewModel.sections {
            count += item.rows.count
        }
        if count == 0 {
            tableView.backgroundView = self.emptyView()
        } else {
            tableView.backgroundView = nil
        }
        self.tableView.reloadData()
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

    @objc func scheduleReloadTableView() {
        if DownloadManager.shared.downloadingVideos.isEmpty {
            stopTimer()
            return
        }
        if timer == nil {
            startTimer()
        }
        fetchAllVideo()
    }

    func doShowActionSheetDownload(_ model: DownloadModel) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        actionController.addAction(Action(ActionData(title: String.xoa_tai_xuong,
                                                     image: #imageLiteral(resourceName: "iconRemoveGray")),
                                          style: .default,
                                          handler: { _ in
                                            DownloadManager.shared.cancelDownload(model)
                                            NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem, object: nil)
                                            self.fetchAllVideo()
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    func doShowActionSheetVideo(_ model: DownloadModel) {
        let actionController = ActionSheetViewController()
        actionController.addSection(Section())
        actionController.addAction(Action(ActionData(title: String.xoa_tai_xuong,
                                                     image: #imageLiteral(resourceName: "iconRemoveGray")),
                                          style: .default,
                                          handler: { _ in
                                            DownloadManager.shared.deleteVideo(model.id)
                                            NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem, object: nil)
                                            self.fetchAllVideo()
        }))
        let shareAction = Action(ActionData(title: String.chia_se, image: #imageLiteral(resourceName: "iconShare")),
                                 style: .default) { (action) in
                                    self.shareWithLink(model.link)
        }
        actionController.addAction(shareAction)
        present(actionController, animated: true, completion: nil)
    }

    deinit {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
}

extension DownloadViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = viewModel.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        cell.bindingWithModel(rowModel)
        if let cell = cell as? DownloadVideoTableViewCell {
            cell.selectionStyle = .none
            cell.delegate = self
        }
        if let cell = cell as? VideoSmallImageTableViewCell {
            cell.delegate = self
            cell.viewCountLabel.isHidden = true
        }
        return cell
    }
}

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // ignore downloading video, show & play local video
        if indexPath.section == 1 {
            showLocalVideoDetails(viewModel.downloadedVideos[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = viewModel.sections[section]
        if sectionModel.header.identifier != nil && !sectionModel.rows.isEmpty {
            return 40
        } else {
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = viewModel.sections[section]
        if sectionModel.header.identifier != nil && !sectionModel.rows.isEmpty {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionModel.header.identifier!) as! BaseTableHeaderView
            view.bindingWithModel(sectionModel.header, section: section)
            return view
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0, DownloadManager.shared.downloadingVideos.count > 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.5))
            view.backgroundColor = UIColor.groupTableViewBackground
            return view
        }
        return nil
    }
    
    fileprivate func showVideoDetailWithID(_ videoID: String) {
        let viewcontroller = VideoDetailConfigurator.videoViewController(with: ContentModel(id: videoID))
        Constants.appDelegate.rootTabbarController.openDetailsView(viewcontroller)
    }
}

extension DownloadViewController: VideoSmallTableViewCellDelegate {
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            doShowActionSheetVideo(viewModel.downloadedVideos[indexPath.row])
        }
    }
}

extension DownloadViewController: DownloadVideoTableViewCellDelegate {
    func donwloadTableViewCell(_ cell: DownloadVideoTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            doShowActionSheetDownload(DownloadManager.shared.downloadingVideos[indexPath.row])
        }
    }

    func donwloadTableViewCell(_ cell: DownloadVideoTableViewCell, didSelectRetryButton sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if let indexPath = tableView.indexPath(for: cell) {
            DownloadManager.shared.resumeDownload(DownloadManager.shared.downloadingVideos[indexPath.row])
        }
    }
}
