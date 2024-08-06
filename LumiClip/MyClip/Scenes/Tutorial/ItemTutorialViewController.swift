//
//  ItemTutorialViewController.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 10/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
class ItemTutorialViewController: BaseViewController {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var image: UIImage?
    var titleStr: String?
    
    init(_ image: UIImage?, title: String?) {
        if let image = image {
            self.image = image
        }
        
        if let string = title {
            self.titleStr = string
        }
        
        super.init(nibName: "ItemTutorialViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImageView.image = image
        labelText.text = titleStr
        // Do any additional setup after loading the view.
    }
    
}
