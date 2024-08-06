//
//  AdaptiveService.swift
//  MyClip
//
//  Created by hnc on 10/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

@objcMembers
class QualityModel: NSObject {
    var name: String
    var isAuto: Bool = false
    var url: String
    var isSelected: Bool
    
    override init() {
        name = String.auto
        isAuto = true
        url = ""
        isSelected = true
    }
    
    init(_ name: String, _ url: String, isAuto: Bool, isSelected: Bool) {
        self.name = name
        self.url = url
        self.isAuto = isAuto
        self.isSelected = isSelected
    }
    
    class func defaultModel() -> QualityModel {
        let model = QualityModel()
        model.name = String.auto
        model.isAuto = true
        model.isSelected = true
        return model
    }
}

@objcMembers
class AdaptiveService: NSObject {
    public func extractQualities(from urlString: String, completion: @escaping ([QualityModel], NSError?) -> Void) {
        if let url = URL(string: urlString) {
            let request = NSMutableURLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) in
                if let err = error {
                    completion([], err as NSError)
                } else {
                    if let data = data, let content = String(data: data, encoding: .utf8) {
                        var components = urlString.components(separatedBy: "/")
                        components.removeLast()
                        let baseURL = components.joined(separator: "/")
                        let lines = content.components(separatedBy: CharacterSet.newlines)
                        var qualities = [QualityModel]()
                        let defaultQuality = QualityModel.defaultModel()
                        defaultQuality.url = urlString
                        qualities.append(defaultQuality)
                        for (index, line) in lines.enumerated() {
                            let lineObj = line as NSString
                            if lineObj.range(of: "#EXT-X-STREAM-INF").location != NSNotFound {
                                //Find Resolution
                                let name = line.getResolutionName()
                                
                                //Find url
                                var urlString = ""
                                if index + 1 < lines.count - 1 {
                                    urlString = lines[index + 1]
                                }
                                qualities.append(QualityModel.init(name, baseURL + "/" + urlString, isAuto: false, isSelected: false))
                            }
                        }
                        completion(qualities, nil)
                    } else {
                        completion([], nil)
                    }
                }
            })
        } else {
            completion([], NSError.errorWith(code: 100, message: "Unable to extract M3U8"))
        }
    }
}
