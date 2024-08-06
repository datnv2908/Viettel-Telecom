//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation

class SearchWireFrame: NSObject {
    weak var viewController: SearchViewController?
    var presenter: SearchWireFrameOutput?
    
}

extension SearchWireFrame: SearchWireFrameInput {
    func doShowVideoDetail(model: ContentModel) {
        viewController?.showVideoDetails(model)
    }
    
    func doShowChannelDetail(model: ChannelModel) {
        let vc = ChannelDetailsViewController.init(model,isMyChannel: false)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doShowActionMore(model: ContentModel) {
        viewController?.showMoreAction(for: model)
    }
}
