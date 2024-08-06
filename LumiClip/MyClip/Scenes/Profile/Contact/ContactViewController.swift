//
//  ContactViewController.swift
//  MyClip
//
//  Created by sunado on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {
    @IBOutlet weak var webView: UIWebView!
    
    let viewModel = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        //web view setup
        webView.scalesPageToFit = true
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        if let html = viewModel.getContent() {
            webView.loadHTMLString(html, baseURL: nil)
        }
        //navigation setup
        navigationItem.title = viewModel.getTitle()
    }
}
