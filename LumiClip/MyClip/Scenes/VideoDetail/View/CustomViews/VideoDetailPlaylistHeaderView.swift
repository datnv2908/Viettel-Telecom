//
//  VideoDetailPlaylistHeaderView.swift
//  MyClip
//
//  Created by hnc on 12/11/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol VideoDetailPlaylistHeaderViewDelegate: NSObjectProtocol {
    func onRandom(_ view: VideoDetailPlaylistHeaderView)
    func onRepeat(_ view: VideoDetailPlaylistHeaderView)
}

class VideoDetailPlaylistHeaderView: BaseTableHeaderView {

    weak var delegate: VideoDetailPlaylistHeaderViewDelegate?
    @IBOutlet weak var sufferButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    override func bindingWithModel(_ model: PBaseHeaderModel, section index: Int) {
        super.bindingWithModel(model, section: index)
        sufferButton.isSelected = DataManager.isSufferingPlaylist()
        repeatButton.isSelected = DataManager.isRepeatPlaylist()
    }

    @IBAction func onSuffer(_ sender: UIButton) {
        sufferButton.isSelected = DataManager.toggleSufferingPlaylist()
        delegate?.onRandom(self)
    }

    @IBAction func onRepeat(_ sender: UIButton) {
        repeatButton.isSelected = DataManager.toggleRepeatPlaylist()
        delegate?.onRepeat(self)
    }
}
