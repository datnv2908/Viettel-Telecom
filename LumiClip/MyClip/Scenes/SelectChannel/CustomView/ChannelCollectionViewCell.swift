//
//  ChannelCollectionViewCell.swift
//  MyClip
//
//  Created by Os on 8/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var channelImageView: UIImageView!

    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var channelNameLabel: UILabel!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        let rowModel = model as! ChannelRowModel
        if let url = URL(string: rowModel.image) {
            channelImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "channel"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        channelNameLabel.text = model.title
        if rowModel.isSelected {
            checkImageView.image = #imageLiteral(resourceName: "check")
        } else {
            checkImageView.image = #imageLiteral(resourceName: "uncheck")
        }        
    }

//    override var isHighlighted: Bool {
//        didSet {
//            hilightedCover.isHidden = !isHighlighted
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        configure()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        channelImageView.frame = bounds
//        hilightedCover.frame = bounds
//        applyGradation(channelImageView)
//    }
//    
//    private func configure() {
//        channelImageView = UIImageView()
//        channelImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        channelImageView.contentMode = UIViewContentMode.scaleAspectFill
//        addSubview(channelImageView)
//        
//        hilightedCover = UIView()
//        hilightedCover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        hilightedCover.isHidden = true
//        addSubview(hilightedCover)
//    }
//    
//    private func applyGradation(_ gradientView: UIView!) {
//        gradientLayer?.removeFromSuperlayer()
//        gradientLayer = nil
//        
//        gradientLayer = CAGradientLayer()
//        gradientLayer!.frame = gradientView.bounds
//        
//        let mainColor = UIColor(white: 0, alpha: 0.3).cgColor
//        let subColor = UIColor.clear.cgColor
//        gradientLayer!.colors = [subColor, mainColor]
//        gradientLayer!.locations = [0, 1]
//        
//        gradientView.layer.addSublayer(gradientLayer!)
//    }
}
