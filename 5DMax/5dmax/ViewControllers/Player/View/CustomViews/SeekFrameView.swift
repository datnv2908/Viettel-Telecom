//
//  SeekFrameView.swift
//  5dmax
//
//  Created by Macintosh on 11/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

class SeekFrameView: UIView {

    @IBOutlet weak var framePaddingTop: NSLayoutConstraint!
    @IBOutlet weak var framePaddingLeft: NSLayoutConstraint!
    @IBOutlet weak var iImageView: UIImageView!
    
    static let kSeekFrameWidth     = 160.0
    static let kSeekFrameHeight    = 90.0
    static let kSeekFrameInSecond  = 5.0
    static let kSeekFrameborder    = 1.0
    
    func displayFrameAt(second: Double, frameLink: String) {
        let kSeekFrameInSecond = 5.0
        let index: Int = Int(second/kSeekFrameInSecond)
        let currentPage = Int(index/24) + 1
        
        var component: [String] = frameLink.components(separatedBy: "/")
        if component.count > 0 {
            component.removeLast()
        }
        
        var lastComponent = ""
        if currentPage > 99 {
            lastComponent = "P\(currentPage).png"
        } else if currentPage > 9 {
            lastComponent = "P0\(currentPage).png"
        } else {
            lastComponent = "P00\(currentPage).png"
        }
        component.append(lastComponent)
        let fullLink = component.joined(separator: "/")
        self.displayWithLink(link: fullLink, index: Int(index%24))
    }
    
    private func displayWithLink(link: String, index: Int) {
        let indexX: Int = index%5
        let indexY: Int = Int(index/5)
        let paddingTop: Float = -Float(SeekFrameView.kSeekFrameHeight)*Float(indexY) - Float(SeekFrameView.kSeekFrameborder)*Float(indexY + 1)
        let paddingLeft: Float = -Float(SeekFrameView.kSeekFrameWidth)*Float(indexX) - Float(SeekFrameView.kSeekFrameborder)*Float(indexX + 1)
        framePaddingTop.constant = CGFloat(paddingTop)
        framePaddingLeft.constant = CGFloat(paddingLeft)
   
        if let url = URL(string: link),
            let thumb = iImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
