//
//  CancelPopupViewController.swift
//  5dmax
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class CancelPopupViewController: UIViewController {

    @IBOutlet weak var cancelPopupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    public var cancelDialog: ((UIButton) -> Void)?
    private var diaglogTitle: String
    
    init(title: String) {
        diaglogTitle = title
        super.init(nibName: "CancelPopupViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        titleLabel.text = String.dang_ky_goi_cuoc
        cancelBtn.setTitle(String.bo_qua, for: .normal)
        cancelPopupView.layer.cornerRadius = 2
        cancelPopupView.layer.masksToBounds = true
    }
    
    @IBAction func onCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.cancelDialog?(sender)
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
