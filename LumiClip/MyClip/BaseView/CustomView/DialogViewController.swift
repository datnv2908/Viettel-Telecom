//
//  DialogViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DialogViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var dialogTitle: String
    private var dialogMessage: String
    private var confirmButtonTitle: String?
    private var cancelButtonTitle: String?
    private var isHtmlMessage: Bool = false
    
    public var confirmDialog: ((UIButton) -> Void)?
    public var cancelDialog: ((UIButton) -> Void)?
    
    init(title: String,
         message: String,
         confirmTitle: String? = String.okString,
         cancelTitle: String? = String.cancel) {
        dialogTitle = title
        dialogMessage = message
        confirmButtonTitle = confirmTitle?.uppercased()
        cancelButtonTitle = cancelTitle?.uppercased()
        isHtmlMessage = false
        super.init(nibName: "DialogViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    init(title: String,
         message: String,
         confirmTitle: String? = String.okString,
         cancelTitle: String? = String.cancel,
         isHtmlMessage: Bool) {
        dialogTitle = title
        dialogMessage = message
        confirmButtonTitle = confirmTitle?.uppercased()
        cancelButtonTitle = cancelTitle?.uppercased()
        self.isHtmlMessage = isHtmlMessage
        super.init(nibName: "DialogViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = dialogTitle
        if(isHtmlMessage){
            descriptionLabel.attributedText = NSAttributedString(html: dialogMessage)
        }else{
            descriptionLabel.text = dialogMessage
        }
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }
    
    
    @IBAction func onConfirmButton(_ sender: UIButton) {
        dismiss(animated: true) { 
            self.confirmDialog?(sender)
        }
    }
    
    @IBAction func onCancelButton(_ sender: UIButton) {
        dismiss(animated: true) { 
            self.cancelDialog?(sender)
        }
    }
    
    deinit {
        DLog()
    }

}
