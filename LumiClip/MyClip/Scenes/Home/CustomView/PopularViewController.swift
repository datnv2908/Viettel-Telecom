//
//  PopularViewController.swift
//  MyClip
//
//  Created by Os on 8/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PopularViewController: BasePopularSimpleTableViewController<ContentModel>{
    let service = VideoServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logScreen(GoogleAnalyticKeys.trending.rawValue)
        LoggingRecommend.viewTrendingPage()
    }
    
    override func setupView() {
        super.setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
        refreshData()
    }
    
    @objc func reconnectInternet() {
        if self.data.isEmpty {
            refreshData()
        }
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        service.getMoreContents(for: MoreContentType.recommend.rawValue, pager: pager) { (result) in
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

