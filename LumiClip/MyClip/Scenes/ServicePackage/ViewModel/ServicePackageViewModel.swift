//
//  ServicePackageViewModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class PackageViewModel: SimpleTableViewModelProtocol {
    var data: [PBaseRowModel] = [ServicePackageRowModel]()
}
