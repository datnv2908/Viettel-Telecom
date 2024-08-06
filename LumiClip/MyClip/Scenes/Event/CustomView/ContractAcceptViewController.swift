//
//  ContractPendingViewController
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ContractAcceptViewController: BaseViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationItem.title = String.thong_tin_thanh_toan
        navigationItem.title = String.payment_infomation
       
        titleLabel.text = String.tai_khoan_da_duoc_duyet
        desLabel.text = String.ban_co_the_dang_tai_video
    }
    
    
}
