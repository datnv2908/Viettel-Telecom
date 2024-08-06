//
//  Macro.swift
//  SwiftDemo
//
//  Created by ThuanND 12/23/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

import Foundation
import UIKit

let kConstantPi = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280

func DLog(_ message: Any...,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {

    #if DEBUG
        // debug only code
        print("\(file.lastPathComponent) - \(function)[\(line)]: \(message)")
    #else
        // release only code
    #endif
}
