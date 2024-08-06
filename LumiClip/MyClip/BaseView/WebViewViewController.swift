//
//  WebViewViewController.swift
//  MyClip
//
//  Created by hnc on 10/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class WebViewViewController: BaseViewController {

    var url: String
    init(_ url: String) {
        self.url = url
        super.init(nibName: "WebViewViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let url = URL(string: url) {
            webView.loadRequest(URLRequest(url: url))
        }
        webView.scalesPageToFit = true
        navigationItem.title = "UClip"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"), style: .plain, target: self, action: #selector(onBack))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onBack() {
        dismiss(animated: true, completion: nil)
    }
}
