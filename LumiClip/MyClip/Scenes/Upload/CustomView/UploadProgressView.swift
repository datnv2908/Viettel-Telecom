//
//  UploadProgressView.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 11/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class UploadProgressView: UIView {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var percent = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.text = String.dang_xu_ly
    }
    func updateView() {
        if percent == 1 {
            statusLabel.text = String.dang_xu_ly
        }
        percentLabel.text = "\(Int(percent*100))%"
        progressView.progress = Float(percent)
    }
}
