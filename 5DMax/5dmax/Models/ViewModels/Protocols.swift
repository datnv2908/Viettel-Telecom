//
//  Protocols.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import AVKit

protocol PBaseSectionModel {
    var title: String {set get}
    associatedtype Cell
    var rows: [Cell] {set get}
}

protocol PBaseRowModel {
    var title: String {set get}
    var desc: String {set get}
    var imageUrl: String {set get}
    var identifier: String {set get}
    var descFilm  : String {set get}
}
