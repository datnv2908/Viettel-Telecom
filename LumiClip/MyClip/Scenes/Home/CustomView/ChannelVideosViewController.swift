//
//  HomePageViewController.swift
//  MyClip
//
//  Created by Os on 8/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol ChannelVideosViewControllerDelegate: NSObjectProtocol {
    func channelVideosViewController(_ viewController: ChannelVideosViewController,
                                     didSelect item: ContentModel,
                                     at indexPath: IndexPath)
}

class ChannelVideosViewController: BaseSimpleTableViewController<ContentModel> {
    let service = VideoServices()
    weak var delegate: ChannelVideosViewControllerDelegate?
    var id: String
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(_ id: String) {
        self.id = id
        super.init(nibName: "ChannelVideosViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        let contentId = "video_new_of_channel_\(self.id)"
        service.getMoreContents(for: contentId, pager: pager) { (result) in
            completion(result)
        }
    }
    
    override func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.channelVideosViewController(self, didSelect: self.data[indexPath.row], at: indexPath)
    }
}
