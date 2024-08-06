//
//  TermPopupViewController.swift
//  5dmax
//
//  Created by nghiendv ♥️ on 12/10/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class TermPopupViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    private var htmlContent: HtmlContentModel?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let htmt = htmlContent {
            webView.loadHTMLString(htmt.content, baseURL: nil)
        }

    }
    
    @IBAction func btnDismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let setting = DataManager.getDefaultSetting()
        htmlContent = setting?.getHTMLWithType(contenType: .termCondition)
        
        if let htmt = htmlContent {
            webView.loadHTMLString(htmt.content, baseURL: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
