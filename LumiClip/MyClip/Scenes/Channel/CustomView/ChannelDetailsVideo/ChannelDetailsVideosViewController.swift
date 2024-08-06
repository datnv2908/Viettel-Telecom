//
//  ChannelVideosViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FirebasePerformance

class ChannelDetailsVideosViewController: BaseSimpleTableViewController<ContentModel> {
    
    @IBOutlet weak var lbFilerType: UILabel!
    @IBOutlet weak var filerTypeLabel: UILabel!
   @IBOutlet weak var filterView: UIView!
   
    weak var parentVC: ChannelDetailsViewController?
    let service = VideoServices()
    var id: String?
    var trace: Trace?
   @IBOutlet weak var filterBgView: UIView!
   var isUser : Bool = false
   weak var ChannelViewModel: ChannelViewModel?
   weak var mutilChannelModel: ChannelDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
      filterBgView.backgroundColor = UIColor.setViewColor()
       filterView.backgroundColor = UIColor.setViewColor()
        trace = Performance.startTrace(name:"Chitietkenh_video")
        lbFilerType.text = String.moi_nhat
      lbFilerType.textColor = UIColor.settitleColor()
      filerTypeLabel.textColor = UIColor.settitleColor()
        filerTypeLabel.text = "\(String.sap_xep_theo):"
      self.tableView.backgroundColor = UIColor.setViewColor()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if id != nil {
            if(self.id?.contains("video_most_view"))!{
                lbFilerType.text = String.xem_nhieu_nhat
            }else{
                lbFilerType.text = String.moi_nhat
            }
            self.refreshData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupView() {
        super.setupView()
        tableView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView?.tableFooterView = UIView(frame: .zero)
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
      if self.isUser {
          if let model = self.mutilChannelModel {
              var categoryId: String
              if let itemId = id {
                  categoryId = itemId
              } else {
                  categoryId = "\(MoreContentForUser.newestVideo.rawValue)\(model.id)"
              }
              service.getMoreContents(for: categoryId, pager: pager) { (result) in
                  switch result {
                  case .success(let respond):
                      completion(result)
                      self.reloadData()
                     if respond.data.count == 0 {
                        self.tableView.backgroundView = self.emptyView()
                     }
                  case .failure(let error):
                      self.handleError(error as NSError, completion: { (handleResult) in
                          if handleResult.isSuccess {
                              self.getData(pager: pager, completion)
                          } else {
                              completion(result)
                          }
                      })
                  }
                  self.trace?.stop()
              }
          }
      }else{
          if let model = self.ChannelViewModel?.channelModel {
              var categoryId: String
            if let itemId = id {
                categoryId = itemId
            } else {
               categoryId = "\(MoreContentForChannel.newestVideo.rawValue)\(model.id)"
            }
              service.getMoreContents(for: categoryId, pager: pager) { (result) in
                  switch result {
                  case .success(let respond):
                      completion(result)
                     if respond.data.count == 0 {
                        self.tableView.backgroundView = self.emptyView()
                     }
                  case .failure(let error):
                      self.handleError(error as NSError, completion: { (handleResult) in
                          if handleResult.isSuccess {
                              self.getData(pager: pager, completion)
                          } else {
                              completion(result)
                          }
                      })
                  }
                  self.trace?.stop()
              }
          }
      }
    }
    override func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item, identifier: VideoSmallImageTableViewCell.nibName())
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        showVideoDetails(model)
    }
    
    @IBAction func onClickFilter(_ sender: Any) {
      if isUser {
          let actionController = ActionSheetViewController()
          actionController.addSection(Section())
          let filterTypes = [String.moi_nhat, String.cu_nhat, String.xem_nhieu_nhat]
          for i in 0 ... (filterTypes.count - 1) {
              let actionData = ActionData(title: filterTypes[i])
              let action = Action(actionData, style: .default, handler: { (_) in
                  if let model = self.mutilChannelModel{
                      self.lbFilerType.text = filterTypes[i]
                      if(i == 0){
                          if(self.id != nil && self.id != MoreContentForUser.newestVideo.rawValue + model.id){
                              self.id = MoreContentForUser.newestVideo.rawValue + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }else if(i == 1){
                          if( self.id != MoreContentForUser.oldVideo.rawValue + model.id){
                              self.id = MoreContentForUser.oldVideo.rawValue + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }else{
                          if(self.id != MoreContentForUser.mostOfView.rawValue + model.id){
                              self.id = MoreContentForUser.mostOfView.rawValue + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }
                  }
              })
              actionController.addAction(action)
          }
          present(actionController, animated: true, completion: nil)
      }else{
          let actionController = ActionSheetViewController()
          actionController.addSection(Section())
          let filterTypes = [String.moi_nhat, String.cu_nhat, String.xem_nhieu_nhat]
          for i in 0 ... (filterTypes.count - 1) {
              let actionData = ActionData(title: filterTypes[i])
              let action = Action(actionData, style: .default, handler: { (_) in
                  if let model = self.ChannelViewModel?.channelModel{
                      self.lbFilerType.text = filterTypes[i]
                      if(i == 0){
                          if(self.id != nil && self.id != "video_new_of_channel_" + model.id){
                              self.id = "video_new_of_channel_" + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }else if(i == 1){
                          if( self.id != "video_old_of_channel_" + model.id){
                              self.id = "video_old_of_channel_" + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }else{
                          if(self.id != "video_most_view_of_channel_" + model.id){
                              self.id = "video_most_view_of_channel_" + model.id;
                              self.showHud()
                              self.refreshData()
                          }
                      }
                  }
              })
              actionController.addAction(action)
          }
          present(actionController, animated: true, completion: nil)
      }
    }
    
    deinit {
        service.cancelAllRequests()
    }
}
