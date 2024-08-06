//
//  TetViewController.swift
//  MyClip
//
//  Created by Manh Hoang on 1/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class MainViewController: BaseMainSimpleTableViewController<HomeModel> {
    
    let service = VideoServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
        initChannelHeader()
        refreshData()
    }
    
    @objc func reconnectInternet() {
        if self.data.isEmpty {
            refreshData()
        }
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<HomeModel>>) -> Void){
        service.getHomeContents() { (result) in
            completion(result)
        }
    }
    
    override func getMoreData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        let contentId = "video_hot"
        service.getMoreContents(for: contentId, pager: pager) { (result) in
            completion(result)
        }
    }
    
    override func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gotoVideoDetail(self, didSelect: self.data[indexPath.row], at: indexPath)
    }
    
}
