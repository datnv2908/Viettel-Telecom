//
//  DialogViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DialogPictureViewController: BaseViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var dialogMessage: String
    private var image: String

    
    init(message: String, image: String) {
        dialogMessage = message
        self.image = image
      
        super.init(nibName: "DialogPictureViewController", bundle: Bundle.main)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        descriptionLabel.text = dialogMessage
        if let url = URL(string: image) {
            imageView?.kf.setImage(with: url,
                                    placeholder: nil,
                                    options: nil,
                                    progressBlock: nil,
                                    completionHandler: nil)
        }
    }
    
    
    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    deinit {
        DLog()
    }

}
