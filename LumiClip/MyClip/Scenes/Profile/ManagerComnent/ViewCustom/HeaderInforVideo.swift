//
//  HeaderInforVideo.swift
//  MeuClip
//
//  Created by Toannx on 07/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class HeaderInforVideo: UITableViewHeaderFooterView {
    @IBOutlet weak var nameVideoInfor: UILabel!
    @IBOutlet weak var imageInforVideo: UIImageView!
     var tapHeader : ((ContentModel) -> Void)? = nil
    var inforModel : ContentModel?
    override func awakeFromNib() {
       super.awakeFromNib()
      let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
      self.addGestureRecognizer(tapGuesture)
   
    }
   @objc  func tapAction(_ sender : UITapGestureRecognizer ){
      if let model = inforModel {
         self.tapHeader?(model)
      }
      
   }
   // MARK:- Blind Model
   
   func blindModel(model : CommentModelDisplay) {
      self.nameVideoInfor.text = model.name
      self.inforModel = ContentModel(model: model)
      if let url = URL(string: model.coverImage){
         self.imageInforVideo.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
      }else{
         self.imageInforVideo.image = UIImage(named: "placeholder_video")
      }
   }
   
   
}
