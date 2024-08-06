



//
//  NoInternetView.swift
//  MyClip
//
//  Created by Os on 10/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol NoInternetViewDelegate: NSObjectProtocol {
    func onRetry(_ view: NoInternetView, sender: UIButton)
    func openDownloadedVideos(_ view: NoInternetView, sender: UIButton)
}
class NoInternetView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    weak var delegate: NoInternetViewDelegate?
    @IBOutlet weak var goToDownloadButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        
        titleLabel.text = String.ban_dang_ngoai_tuyen
        descriptionLabel.text = String.xem_video_tai_xuong_trong_trang_ca_nhan
        goToDownloadButton.setTitle(String.chuyen_den_video_tai_xuong, for: .normal)
        goToDownloadButton.layer.borderColor = UIColor.colorFromHexa("198DFF").cgColor
        retryButton.addTarget(self, action: #selector(retryAction(_:)), for: .touchUpInside)
        goToDownloadButton.addTarget(self, action: #selector(openDownloadedVideos(_:)), for: .touchUpInside)
      self.backgroundColor = UIColor.setViewColor()
      titleLabel.textColor = UIColor.settitleColor()
      descriptionLabel.textColor = UIColor.settitleColor()
      goToDownloadButton.setTitleColor(UIColor.settitleColor(), for: .normal)
      retryButton.setTitleColor(UIColor.settitleColor(), for: .normal)
      self.backgroundColor = UIColor.setViewColor()
        bgView.backgroundColor = UIColor.setViewColor()
      
    }
    
    @objc func retryAction(_ button: UIButton) {
        delegate?.onRetry(self, sender: button)
    }

    @objc func openDownloadedVideos(_ button: UIButton) {
        delegate?.openDownloadedVideos(self, sender: button)
    }
}
