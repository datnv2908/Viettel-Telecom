//
//  IntroductionViewController.swift
//  MyClip
//
//  Created by sunado on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PresentViewController: BaseViewController {
    @IBOutlet weak var webView: UIWebView!
    
    let viewModel = IntroductionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupView() {
        //web view setup
         webView.backgroundColor = UIColor.setViewColor()
        self.view.backgroundColor = UIColor.setViewColor()
        webView.scalesPageToFit = true
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        if let html = viewModel.getContent() {
//         webView.loadHTMLString(String(format: "<html><body bgcolor=\"\( DataManager.getStatusbarVaule() ? "#ffffff" : "#1c1c1e")\" text=\"#\(DataManager.getStatusbarVaule()  ? "000000" : "ffffff" ) size=\"5\">%@</body></html>",html), baseURL: nil)
         webView.loadHTMLString(String(format: "<html><body bgcolor=\"\( DataManager.getStatusbarVaule() ?   "#ffffff" : "#1c1c1e")\" text=\"#\(DataManager.getStatusbarVaule()  ?   "000000":"ffffff")\" size=\"5\">%@</body></html>",html), baseURL: nil)
        }
        //navigation setup
        navigationItem.title = viewModel.getTitle()
    }
    
}
