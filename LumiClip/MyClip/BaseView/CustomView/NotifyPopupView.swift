//
//  GoToMyListView.swift
//  MyClip
//
//  Created by hnc on 11/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class NotifyPopupView: XibViewSwift {
    let animationDuration: TimeInterval = 0.3
    init() {
        super.init(frame: CGRect(x: 0,
                                 y: UIScreen.main.bounds.size.height,
                                 width: UIScreen.main.bounds.size.width,
                                 height: Constants.notifyBarHeight))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet fileprivate weak var hiddenButton: UIButton!
    @IBOutlet fileprivate weak var actionButton: UIButton!
    @IBOutlet fileprivate weak var titleLabel: UILabel!

    var notice: String = ""
    var actionTitle: String = ""

    var autoDismiss: Bool = true
    var actionBlock: ((UIButton) -> Void)?
    var bottomConstraint: Constraint?

    var autoHideTimer: Timer?

    fileprivate var isDisplaying: Bool = false
    
    @IBOutlet weak var contraintSeeBtn: NSLayoutConstraint!
    
    @IBOutlet weak var contraintHideBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupNotifyView(from viewcontroller: NewRootTabbarViewController) {
        viewcontroller.view.addSubview(self)
        self.titleLabel.text = String.dang_tai_len
        self.actionButton.setTitle(String.xem.uppercased(), for: .normal)
        self.hiddenButton.setTitle(String.an.uppercased(), for: .normal)
      self.backgroundColor = UIColor.setViewColor()
      self.titleLabel.textColor = UIColor.settitleColor()
      self.hiddenButton.setTitleColor(UIColor.settitleColor(), for: .normal)
      self.actionButton.setTitleColor(UIColor.settitleColor(), for: .normal)
        self.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(Constants.notifyBarHeight)
            bottomConstraint = maker.top.equalTo(viewcontroller.view.snp.bottom).offset(Constants.notifyBarHeight).constraint
            super.updateConstraints()
        }
    }

    func update(with title: String,
                actionTitle: String,
                margin: CGFloat = Constants.tabbarHeight,
                actionBlock: @escaping (UIButton) -> ()) {
        self.notice = title
        self.actionTitle = actionTitle
        self.actionBlock = actionBlock

        if(actionTitle == "") {
            contraintSeeBtn.constant = 0
        } else {
            contraintSeeBtn.constant = 58
        }

        if(autoDismiss){
            contraintHideBtn.constant = 0
        }else{
            contraintHideBtn.constant = 58
        }
    }

    @IBAction func didSelectAction(_ sender: UIButton) {
        if autoDismiss {
            hide()
        }else{
            contraintSeeBtn.constant = 0
        }
        actionBlock?(sender)
    }
    
    @IBAction func onHide(_ sender: Any) {
        hide()
    }
    

    func show(autoDismiss: Bool = true) {
        if(autoDismiss){
            contraintHideBtn.constant = 0
        }else{
            contraintHideBtn.constant = 58
        }
        
        self.superview?.bringSubviewToFront(self)
        // make
        let hideClosure = {() in
            self.bottomConstraint?.update(offset: Constants.notifyBarHeight)
            super.updateConstraints()
            self.stopTimer()
        }
        let showClosure = {() in
            self.titleLabel.text = self.notice
            self.actionButton.setTitle(self.actionTitle, for: .normal)
            self.autoDismiss = autoDismiss
            if self.actionTitle.isEmpty {
                self.actionButton.isHidden = true
            } else {
                self.actionButton.isHidden = false
            }
            UIView.animate(withDuration: self.animationDuration, animations: {
                var margin: CGFloat
                if Constants.appDelegate.rootTabbarController.playerManager?.isInFullMode == true {
                    margin = 0.0
                } else {
                    margin = 50.0
                }
                if Constants.isIphoneX {
                    margin += Constants.iPhoneXBottomMargin
                } else {
                    margin += 0
                }
                let offset = -(Constants.notifyBarHeight + margin)
                self.bottomConstraint?.update(offset: offset)
                super.updateConstraints()
            }, completion: { (complete) in
                self.isDisplaying = true
            })
            if autoDismiss {
                self.startTimer()
            }
        }
        if isDisplaying {
            UIView.animate(withDuration: animationDuration, animations: {
                hideClosure()
            }, completion: { (_) in
                showClosure()
            })
        } else {
            showClosure()
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint?.update(offset: Constants.notifyBarHeight)
            super.updateConstraints()
        }) { (_) in
            self.isDisplaying = false
            self.stopTimer()
        }
    }

    func startTimer() {
        stopTimer()
        weak var wself = self
        if #available(iOS 10.0, *) {
            autoHideTimer = Timer.scheduledTimer(withTimeInterval: Constants.kShowNotifyViewInterval,
                                                 repeats: false,
                                                 block: { (_) in
                                                    wself?.hide()
            })
        } else {
            // Fallback on earlier versions
            autoHideTimer = Timer.scheduledTimer(timeInterval: Constants.kShowNotifyViewInterval,
                                                 target: self,
                                                 selector: #selector(hide),
                                                 userInfo: nil,
                                                 repeats: false)
        }
    }

    func stopTimer() {
        autoHideTimer?.invalidate()
        autoHideTimer = nil
    }

    deinit {
        stopTimer()
        DLog("");
    }
}
