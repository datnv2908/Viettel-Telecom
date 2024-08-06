//
//  MenuContainerViewController.swift
//  5dmax
//
//  Created by Macintosh on 10/12/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class MenuContainerViewController: UIViewController {


    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    let mainMenu = MenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHello.text = String.xin_chao
        btnLogin.setTitle(String.dang_nhap.uppercased(), for: .normal)
        let nav = BaseNavigationViewController(rootViewController: mainMenu)
        bottomView.addSubview(nav.view)
        self.addChild(nav)
        
        nav.view.snp.remakeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        doReloadView()
    }

    @IBAction func btnLoginPressed(_ sender: Any) {
        self.doLogin()
    }
    
    func doReloadView() {
        btnLogin.isHidden = DataManager.isLoggedIn()
        lblHello.isHidden = !DataManager.isLoggedIn()
        lblPhoneNumber.isHidden = !DataManager.isLoggedIn()
        lblPhoneNumber.text = DataManager.getCurrentMemberModel()?.fullname
    }
    
    func doLogin() {
        LoginViewController.performLogin(fromViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
