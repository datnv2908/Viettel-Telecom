//
//  ImageCapcharView.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ImageCapcharView: UIImageView {

    private var capcharService: CaptcharService = CaptcharService()

    func getCapchar(sucess:(() -> (Void))?, failse:((_ err: String?) -> (Void))?) {
        capcharService.getCaptcha { (image, _) in
            self.image = image
            if let block = sucess {
                block()
            }
        }
    }

}
