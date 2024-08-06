//
//  NSErrorExtension.swift
//  MyClip
//
//  Created by Huy Nguyen on 1/5/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

extension NSError {
    public static func errorWith(code errorCode: Int, message errorMessage: String) -> NSError {
        return NSError.init(domain: "viettel.com.MyClip", code: errorCode,
                            userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }

}
