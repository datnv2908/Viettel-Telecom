//
//  UploadSuccessViewController.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 11/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class UploadSuccessViewController: BaseViewController {
    
    @IBOutlet weak var upSuccessLabel: UILabel!
    @IBOutlet weak var moveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    public var confirmDialog: ((UIButton) -> Void)?
    public var cancelDialog: ((UIButton) -> Void)?
    init() {
        super.init(nibName: "UploadSuccessViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        moveBtn.setTitle(String.chuyen_den_video_cua_toi, for: .normal)
        cancelBtn.setTitle(String.huy_bo, for: .normal)
        upSuccessLabel.text = String.daang_tai_thanh_cong
        // Do any additional setup after loading the view.
    }

    @IBAction func onGoToMyVideo(_ sender: UIButton) {
        dismiss(animated: true) {
            self.confirmDialog?(sender)
        }
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true) {
            self.cancelDialog?(sender)
        }
    }
}
