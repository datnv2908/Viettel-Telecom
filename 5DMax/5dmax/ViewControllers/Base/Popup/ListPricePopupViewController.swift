//
//  ListPricePopupViewController.swift
//  5dmax
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class ListPricePopupViewController: BaseViewController {

    @IBOutlet weak var listpriceView: UIView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var confirmDialog: ((UIButton) -> Void)?
    public var cancelDialog: ((UIButton) -> Void)?
    
    public var confirmButtonTitle: String?
    public var cancelButtonTitle: String?
    public var messageConfirm: String?
    public var alertTitle: String?
    
    init(title: String,
         message: String,
         confirmTitle: String? = String.okString,
         cancelTitle: String? = String.cancel) {
        alertTitle = title
        messageConfirm = message
        confirmButtonTitle = confirmTitle?.uppercased()
        cancelButtonTitle = cancelTitle?.uppercased()
        super.init(nibName: "ListPricePopupViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        titleLabel?.text = alertTitle
        desLabel?.text = messageConfirm
        registerButton.setTitle(confirmButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }
    
    func setupView() {
        listpriceView.layer.cornerRadius = 2
        listpriceView.layer.masksToBounds = true
    }
    
    @IBAction func onRegisterButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.confirmDialog?(sender as! UIButton)
        }
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
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
