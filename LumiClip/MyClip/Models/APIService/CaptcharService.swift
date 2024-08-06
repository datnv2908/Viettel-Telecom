//
//  CaptcharService.swift
//  MyClip
//
//  Created by Hoang on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class CaptcharService: APIServiceObject {

    func getCaptcha(completion: @escaping (UIImage?, NSError?) -> Void) {
        let request = APIRequestProvider.shareInstance.getCaptcha()
        request.validate().responseData { (_ dataResponse: DataResponse<Data>) in
            DispatchQueue.global().async {
                print(request.debugDescription)
                print(dataResponse.data ?? "nodata")
                
                if let data = dataResponse.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                } else {
                    completion(nil, nil)
                    let json = JSON(dataResponse.data as Any)
                    print(json)
                }
            }
        }
        addToQueue(request)
    }
}
