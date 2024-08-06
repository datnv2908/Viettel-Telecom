//
//  NotificationTableViewCell.swift
//  5dmax
//
//  Created by Os on 4/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Nuke
import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgNotify: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var statusNotifyView: UIView!
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var widthConstrantImgNotify: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.textColor = UIColor.white
        labelMessage.textColor = AppColor.e5e5e6Color()
        labelDate.textColor = AppColor.warmGrey()
        statusNotifyView.layer.masksToBounds = true
        statusNotifyView.layer.cornerRadius = statusNotifyView.frame.size.width / 2
        statusNotifyView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func billData(model: NotificationModel) {
        labelTitle.text = model.name
        labelMessage.text = model.message
        let date = model.senttime  as NSDate
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        labelDate.text = "\(formater.string(from: date as Date))"
//        "\((model.senttime as NSDate).day()) \(String.getLocalizeMonth(monthStr: (model.senttime as NSDate).month()))"
//
        if let url = URL(string: model.imageH),
            let thumb = imgNotify {
                self.widthConstrantImgNotify.constant = 120
                let request = ImageRequest(url: url)
                Nuke.loadImage(with: request, into: thumb)
        }else{
            self.widthConstrantImgNotify.constant = 0
        }
        statusNotifyView.isHidden = model.isRead
    }
    
    func billData2(model: NotificationModel) {
        labelTitle.text = model.name
        labelMessage.text = nil
        labelDate.text = "\((model.senttime as NSDate).day()) \(String.getLocalizeMonth(monthStr: (model.senttime as NSDate).month()))"
        
        if let url = URL(string: model.imageH),
            let thumb = imgNotify {
            if model.imageH != "" {
                self.widthConstrantImgNotify.constant = 120
                let request = ImageRequest(url: url)
                Nuke.loadImage(with: request, into: thumb)
            }else{
                self.widthConstrantImgNotify.constant = 0
            }
           
        }
        
        statusNotifyView.isHidden = model.isRead
    }
}
extension String {
   static func getLocalizeMonth(monthStr : Int) -> String{
    return RTLocalizationSystem.rtLocalize(String(monthStr), comment: "")
    }
}
