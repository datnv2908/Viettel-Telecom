//
//  PlaylistTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol PlaylistTableViewCellDelegate: NSObjectProtocol {
    func playlistTableViewCell(_ cell: PlaylistTableViewCell, didTapOnEdit sender: UIButton)
}

class PlaylistTableViewCell: BaseTableViewCell {
    @IBOutlet weak var numberVideoLabel: UILabel!
    @IBOutlet weak var onClickEditButton_Outlet: UIButton!
    weak var delegate: PlaylistTableViewCellDelegate?
   @IBOutlet weak var lblVideoCount: UILabel!
   @IBOutlet weak var lblViewsCount: UILabel!
   var isChannel : Bool = false
    override func bindingWithModel(_ model: PBaseRowModel) {
        self.backgroundColor = UIColor.setViewColor()
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        if let image = UIImage(named: model.image) {
            thumbImageView?.image = image
        } else {
            if let url = URL(string: model.image) {
                thumbImageView?.kf.setImage(with: url,
                                            placeholder: #imageLiteral(resourceName: "placeholder_video"),
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: nil)
            } else {
                thumbImageView?.image = #imageLiteral(resourceName: "placeholder_video")
            }
        }
        if let rowModel = model as? PlaylistRowModel {
            numberVideoLabel.text = String(rowModel.numberVideo)
        }
      if isChannel {
          if let rowModel = model as? PlaylistRowModel {
              numberVideoLabel.text = String(rowModel.numberVideo)
              lblVideoCount.text = String.init(format: "%@ %@", String(rowModel.numberVideo),String.videos)
              lblViewsCount.text = String.init(format: "%@ %@", String(rowModel.viewsCount), String.luot_xem)
              descLabel?.text = ""
          }
      }
    }
    @IBAction func onClickEditButton(_ sender: UIButton) {
        delegate?.playlistTableViewCell(self, didTapOnEdit: sender)
    }
}
