//
//  Result.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
enum Result<T> {
    case success(T)
    case failure(Error)
}
