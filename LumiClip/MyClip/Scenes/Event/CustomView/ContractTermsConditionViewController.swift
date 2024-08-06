//
//  ContractTermsConditionViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ContractTermsConditionViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var wvContent: UIWebView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
   var fromNoti : Bool = false
    let service = AppService()
    
    var isGotoUpdatePayment: Bool
    init(_ isGotoUpdatePayment: Bool) {
        self.isGotoUpdatePayment = isGotoUpdatePayment
        super.init(nibName: "ContractTermsConditionViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = String.xac_nhan_thong_tin_ca_nhan
        okBtn.setTitle(String.toi_da_doc_va_dong_y, for: .normal)
        cancelBtn.setTitle(String.tu_choi, for: .normal)
        
        showHud()
        wvContent.delegate = self
        
        service.getContractCondition()
            { (result) in
                switch result {
                case .success(let response):
//                    self.wvContent.loadHTMLString(, baseURL: nil)
                  self.wvContent.loadHTMLString(String(format: "<html><body bgcolor=\"\( DataManager.getStatusbarVaule() ? "#ffffff" : "#1c1c1e")\" text=\"#\(DataManager.getStatusbarVaule()  ?    "000000" : "ffffff" )\" size=\"5\">%@</body></html>",response.data.condition), baseURL: nil)
                    break
                    
                case .failure(_):
                    break
                }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == UIWebView.NavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //Check here if still webview is loding the content
        if (webView.isLoading){
            return;
        }
        self.hideHude()
    }

    @IBAction func actionAccept(_ sender: Any) {
        let updateInforVC = UpdateAccountInforViewController(isGotoUpdatePayment)
        updateInforVC.fromNoti = fromNoti
       updateInforVC.backTofirst = {
          self.navigationController?.popViewController(animated: true)
       }
        self.navigationController?.pushViewController(updateInforVC, animated: true)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        wvContent.stopLoading()
        wvContent.delegate = nil
    }

}
