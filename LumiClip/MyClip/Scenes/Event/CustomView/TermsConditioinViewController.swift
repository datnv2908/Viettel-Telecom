//
//  TermsConditioinViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class TermsConditioinViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var wvContent: UIWebView!
    var termContent: String
    init(_ content: String) {
        termContent = content
        super.init(nibName: "TermsConditioinViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showHud()
        wvContent.loadHTMLString(termContent, baseURL: nil)
        wvContent.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
