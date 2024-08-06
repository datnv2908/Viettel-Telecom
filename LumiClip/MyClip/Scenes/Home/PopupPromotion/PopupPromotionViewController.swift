//
//  PopupPromotionViewController.swift
//  MyClip
//
//  Created by Manh Hoang on 1/31/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PopupPromotionViewDelegate {
    func registerPromotionAppFinish(message : String)
}

class PopupPromotionViewController: UIViewController {
    var delegate: PopupPromotionViewDelegate!
    
    @IBOutlet weak var overBtn: UIButton!
    @IBOutlet weak var tryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overBtn.setTitle(String.bo_qua, for: .normal)
        tryBtn.setTitle(String.dung_thu_1_thang_mien_phi, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doRegisterPromotion(_ sender: Any) {
        self.showHud();
        let service = UserService()
        service.registerPromotionApp({ (result) in
            switch result {
            case .success(let message):
                self.delegate?.registerPromotionAppFinish(message: message as! String)
            case .failure(let error):
                self.delegate?.registerPromotionAppFinish(message: error.localizedDescription)
            }
            self.hideHude()
            
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
