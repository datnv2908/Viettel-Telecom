//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation

class VideoDetailWireFrame: NSObject {
    weak var viewController: VideoDetailViewController?
    weak var presenter: VideoDetailWireFrameOutput?
}

extension VideoDetailWireFrame: VideoDetailWireFrameInput {
    func doShowProgress() {
        viewController?.hideHude()
        viewController?.showHud(in: viewController?.tableView, with: -Constants.videoPlayerHeight)
    }
    
    func doHideProgress() {
        viewController?.hideHude()
    }
    
    func doShowToast(message: String) {
        viewController?.toast(message)
    }
    
    func doShowChannelDetail(model: ChannelModel) {
      self.viewController?.showChannelDetails(model, isMyChannel: false)
    }
    
    func doShare(_ model: ContentModel) {
        self.viewController?.share(model)
    }
    
    func doShareWithLink(_ link: String) {
        self.viewController?.shareWithLink(link)
    }
}
