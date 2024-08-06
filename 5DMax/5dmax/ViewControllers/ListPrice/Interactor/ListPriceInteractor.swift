//
//  ListPriceInteractor.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListPriceInteractor: NSObject {

    var settingService: SettingService? = SettingService()
    var filmService: FilmService? = FilmService()

    func performGetListPrice(completion: @escaping(([PackageModel], Bool, Bool, NSError?) -> Void)) {
        settingService?.listPackage(completion: completion)
    }

    func performRegisterPackage(_ package: PackageModel, complete:((_ json: JSON, _ err: NSError?) -> (Void))?,
                                failse:((_ message: String) -> (Void))?) {

        filmService?.registerService(packageID: package.packageId, contentType:"", contentName: "", completion: { (json: JSON, err: NSError?) in

            if let letErr = err {
                
                if(json["is_confirm_sms"].intValue == 1){
                    if let block = complete {
                        block(json, err)
                    }
                }else{
                    if let block = failse {
                        block(letErr.localizedDescription)
                    }
                }

            } else {

                if let block = complete {
                    block(json, err)
                }
            }
        })
    }

    func performStopPackage(_ package: PackageModel, complete:(() -> (Void))?,
                            failse:((_ message: String) -> (Void))?) {

        filmService?.unRegisterService(package: package, completion: { (err: NSError?) in
            if let letErr = err {
                if let block = failse {
                    block(letErr.localizedDescription)
                }
            } else {
                if let block = complete {
                    block()
                }
            }
        })
    }

    deinit {
        settingService = nil
    }
}
