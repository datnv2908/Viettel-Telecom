//
//  GameViewController.swift
//  5dmax
//
//  Created by Đào Văn Nghiên on 1/18/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class GameViewController: BaseViewController {

    @IBOutlet weak var webGame: WKWebView!
    var gameUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let encodedStr = self.gameUrl.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url = URL(string: encodedStr!)
        webGame.load(URLRequest(url: url!))
        
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }

    @IBAction func banner_close_action(_ sender: Any) {
        
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        self.dismiss(animated: true) {
            
        }
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.webGame.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width)
    }
}
