//
//  PlaylistHeaderView.swift
//  MyClip
//
//  Created by hnc on 11/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PlaylistHeaderViewDelegate: NSObjectProtocol {
    func onSuffer(_ view: PlaylistHeaderView)
    func onEdit(_ view: PlaylistHeaderView)
    func onRemove(_ view: PlaylistHeaderView)
    func onPlayAll(_ view: PlaylistHeaderView)
}

class PlaylistHeaderView: BaseTableHeaderView {
    weak var delegate: PlaylistHeaderViewDelegate?
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
   
    @IBOutlet var contentBg: [UIView]!
    @IBOutlet weak var removeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for item in contentBg {
            item.backgroundColor = UIColor.setViewColor()
        }
      
    }
    @IBAction func onSuffer(_ sender: Any) {
        delegate?.onSuffer(self)
    }
    @IBAction func onEdit(_ sender: Any) {
        delegate?.onEdit(self)
    }
    
    @IBAction func onRemove(_ sender: Any) {
        delegate?.onRemove(self)
    }
    @IBAction func onPlayAll(_ sender: Any) {
        delegate?.onPlayAll(self)
    }
}
