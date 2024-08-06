//
//  HeaderView.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol headerDelegate {
    func getMoreContent(id : String,name : String,model :NotifyModel?)
}
class SectionHeaderView: UITableViewHeaderFooterView, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allButton: UIButton!
    var delegate : headerDelegate!
    var viewAllClosure: ((Any) -> Void)?
    var model : HomeViewModel.HomeSectionModel!
    var tapGesture : UITapGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = AppColor.e5e5e6Color()
        self.tapGesture  = UITapGestureRecognizer(target: self, action: #selector(tabHeader(gesture:)))
        tapGesture.cancelsTouchesInView = false
    self.addGestureRecognizer(tapGesture)
    }
    @objc func tabHeader( gesture : UITapGestureRecognizer) {
        if gesture.state == .ended {
            if model.blockType != .banner {
                delegate.getMoreContent(id: self.model.groupId, name: self.model.title, model: nil)
                gesture.isEnabled = true
            }else{
                return
            }
        }
        self.tapGesture.cancelsTouchesInView = false
    }
    func bindingWith(_ model: HomeViewModel.HomeSectionModel) {
        titleLabel.text = model.title
        self.model = model
        
    }
    
    func bindingWithCharges(_ model: HomeViewModel.HomeSectionModel) {
        titleLabel.text = model.title
        allButton.isHidden = true
    }
    
    @IBAction func onViewAll(_ sender: Any) {
        if let closure = viewAllClosure {
            closure(sender)
        }
    }
}
