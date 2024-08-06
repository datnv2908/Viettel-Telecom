//
//  IntExtension.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

let hourToSeconds = 3600.0
let hourToMinutes = 60.0

extension Int {
    func durationString() -> String {
        let timeValue = Double(self)
        var hours = 0
        var minutes = 0
        var seconds = 0
        hours = Int(timeValue / hourToSeconds)
        minutes = Int((timeValue - Double(Double(hours) * hourToSeconds)) / hourToMinutes)
        seconds = Int(timeValue - Double(Double(hours) * hourToSeconds) - Double(Double(minutes) * hourToMinutes))

        if hours == 0 {
            return String.init(format: "%02d:%02d", minutes, seconds)
        } else {
            return String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
