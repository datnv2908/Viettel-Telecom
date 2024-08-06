//
//  AlertPopupViewController.swift
//  5dmax
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class AlertPopupViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    public var cancelDialog: ((UIButton) -> Void)?
    public var okButtonTitle: String?
    public var messageConfirm: String?
    public var titleString: String?
    
    init(titleStr: String, message: String,
         cancelTitle: String? = String.okString) {
        titleString = titleStr
        messageConfirm = message
        okButtonTitle = cancelTitle?.uppercased()
        super.init(nibName: "AlertPopupViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        titleLabel?.text = titleString
        desLabel?.text = messageConfirm
        okButton.setTitle(okButtonTitle, for: .normal)
    }
    
    func setupView() {
        contentView.layer.cornerRadius = 2
        contentView.layer.masksToBounds = true
    }
    
    @IBAction func onokButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.cancelDialog?(sender as! UIButton)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        DLog()
    }
}
