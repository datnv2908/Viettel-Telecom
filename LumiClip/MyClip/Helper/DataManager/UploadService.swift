//
//  UploadService.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadService: NSObject {
    static let sharedInstance: UploadService = {
        let instance = UploadService()
        DispatchQueue.once(token: "UploadService", block: { 
            instance.addObserver()
        })
        return instance
    }()
    
    var serviceAgent = APIServiceAgent()
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
    }
    var listVideoUpload = [UploadModel]()
    @objc func reconnectInternet() {
        print("reconnect  internet")
        for index in listVideoUpload.indices where listVideoUpload[index].status == .error {
            self.uploadVideo(listVideoUpload[index])
        }
    }

    private func index(of model: UploadModel) -> Int? {
        return listVideoUpload.index(of: model)
    }

    // can be used in case of retry.
    func uploadVideo(_ model: UploadModel) {
        model.status = .uploading
        // check if this video is in list uploading video or not
        if !listVideoUpload.contains(model) {
            listVideoUpload.append(model)
        }
        let sessionId = UUID().uuidString
        APIRequestProvider.shareInstance.uploadVideo(model.videoUrl,
                                                     status: model.videoMode,
                                                     title: model.title,
                                                     desc: model.desc,
                                                     sessionId: sessionId,
                                                     image: model.thumbImage, channelId: model.channelID,categoryID: model.categoryID) { (result) in
            switch result {
            case .success(let response):
                if let request = response as? UploadRequest {
                    request.uploadProgress(closure: { (progress) in
                        if let itemIndex = self.index(of: model) {
                            self.listVideoUpload[itemIndex].percent = Float(progress.fractionCompleted)
                        }
                    })
                    request.responseJSON(completionHandler: { (response) in
                        if let _ = response.error {
                            if let itemIndex = self.index(of: model) {
                                self.listVideoUpload[itemIndex].status = .error
                            }
                        } else {
                            let json = JSON(response.result.value as Any)
                            let responseCode = json["responseCode"].intValue
                            if responseCode == APIErrorCode.success.rawValue {
                                if let itemIndex = self.index(of: model) {
                                    self.listVideoUpload.remove(at: itemIndex)
                                }
                                NotificationCenter.default.post(name: .uploadSuccess, object: nil)
                            } else {
                                if let itemIndex = self.index(of: model) {
                                    self.listVideoUpload[itemIndex].status = .error
                                }
                            }
                        }
                    })
                    if let itemIndex = self.index(of: model) {
                        self.listVideoUpload[itemIndex].uploadRequest = request
                    }
                }
            case .failure:
                if let itemIndex = self.index(of: model) {
                    self.listVideoUpload[itemIndex].status = .error
                }
            }
        }
        
        let request = APIRequestProvider.shareInstance.kpiUploadStart(sessionId)
        self.serviceAgent.startRequest(request) { (json, error) in }
        var requests = [DataRequest]()
        requests.append(request)
    }

    func retry(at index: Int) {
        self.uploadVideo(listVideoUpload[index])        
    }

    func stop(at index: Int) {
        listVideoUpload[index].stop()
    }

    func removeItem(_ model: UploadModel) {
        if let index = index(of: model) {
            stop(at: index)
            listVideoUpload.remove(at: index)
        }
    }

    func cancelAllUploadingItems() {
        for item in listVideoUpload {
            item.stop()
        }
        listVideoUpload.removeAll()
    }
}
