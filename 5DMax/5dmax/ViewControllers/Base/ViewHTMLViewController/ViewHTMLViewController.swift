//
//  ViewHTMLViewController.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ViewHTMLViewController: UIViewController {

    private var htmlContent: HtmlContentModel?
    @IBOutlet weak var webView: WKWebView!
    var isBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        if let htmt = htmlContent {
            webView.loadHTMLString(htmt.content, baseURL: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigation()
        if let htmt = htmlContent {
            webView.loadHTMLString(htmt.content, baseURL: nil)
        }
    }
    
    func setupNavigation() {
        if isBack {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                                btnAction: #selector(menuButtonAction(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.backBarItem(target: self, btnAction: #selector(backButtonAction(_:)))
        }
    }
    
    @objc func menuButtonAction(_ sender: UIButton) {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func initWithHTML(html: HtmlContentModel?, title: String) -> ViewHTMLViewController {
        let viewController = ViewHTMLViewController.init(nibName: "ViewHTMLViewController", bundle: nil)
        viewController.htmlContent = html
        viewController.navigationItem.title = title
        return viewController
    }
}
