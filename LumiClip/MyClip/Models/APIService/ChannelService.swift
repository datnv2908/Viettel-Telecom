//
//  ChannelService.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class ChannelService: APIServiceObject {
    func getDetailChannel(id: String,
                          _ completion: @escaping (Result<APIResponse<ChannelModel>>) -> ()) {
        let request = APIRequestProvider.shareInstance.getDetailChannel(id: id)
        serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let model = ChannelModel(ChannelDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            } else {
                completion(Result.failure(error!))
            }
        }
    }
}
