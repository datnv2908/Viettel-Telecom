//
//  SubTutorialViewController.swift
//  5dmax
//
//  Created by Đào Văn Nghiên on 3/4/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

import UIKit

class SubTutorialViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = text
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
