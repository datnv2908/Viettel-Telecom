//
//  VideoService.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoService: APIServiceObject {
    func getMoreContents(_ objectId: String,
                         limit: Int,
                         offset: Int,
                         completion: @escaping (Result<APIResponse<[VideoModel]>>) -> (Void)) {
        let request = APIRequestProvider.shareInstance.getMoreContent(objectId, limit: limit, offset: offset)
        self.serviceAgent.startRequest2(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [VideoModel]()
                if let subJson = json["data"].arrayValue.last {
                    for item in subJson["content"].arrayValue {
                        let dto = VideoDTO(item)
                        let model = VideoModel(dto)
                        models.append(model)
                    }
                }
                completion(Result.success(APIResponse(json, data: models)))
            }
        }
        addToQueue(request)
    }
}
