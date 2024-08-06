
//
//  LoadMoreTableViewCell.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 10/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol WatchMoreTableViewCellDelegate: NSObjectProtocol {
    func watchMoreTableViewCell(_ cell: WatchMoreTableViewCell, didSelectLoadMore sender: UIButton)
}

class WatchMoreTableViewCell: BaseTableViewCell {
    weak var delegate: WatchMoreTableViewCellDelegate?
    @IBOutlet weak var btnClickLoadMore: UIButton!
    var identifier: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onClickLoadmoreButton(_ sender: Any) {
        delegate?.watchMoreTableViewCell(self, didSelectLoadMore: sender as! UIButton)
    }
    
    func setupBtn(numVideo: Int) {
        if numVideo < 2 {
            btnClickLoadMore.setTitle("\(String.xem_tat_ca) \(numVideo) \(String.video.lowercased())", for: .normal)
        } else {
            btnClickLoadMore.setTitle("\(String.xem_tat_ca) \(numVideo) \(String.videos.lowercased())", for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
