//
//  ContractPendingViewController
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ContractPendingViewController: BaseViewController{
    let service = AppService()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reInputBtn: UIButton!
    
    var contractStatus: Int
    var reason: String
    init(_ status: Int, reason: String) {
        contractStatus = status
        self.reason = reason
        super.init(nibName: "ContractPendingViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationItem.title = String.thong_tin_thanh_toan
        navigationItem.title = String.payment_infomation
        
        titleLabel.text = String.payment_watting_approve
        descriptionLabel.text = String.payment_watting_approve_message
        reInputBtn.setTitle(String.nhap_lai_thong_tin, for: .normal)
        
        if(contractStatus == 3){
            titleLabel.text = String.dang_ky_thong_tin_thanh_toan_khong_hop_le
            descriptionLabel.text = "\(String.ly_do): " + String(reason)
        }
       
    }
    

    @IBAction func actionAccept(_ sender: Any) {
        self.service.confirmContract(contractStatus)
        { (result) in
            switch result {
            case .success(_):
                let updateInforVC = UpdateAccountInforViewController(true)
                let navigationController = self.navigationController;
                navigationController?.popToRootViewController(animated: false)
                navigationController?.pushViewController(updateInforVC, animated: true)
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
    
}
