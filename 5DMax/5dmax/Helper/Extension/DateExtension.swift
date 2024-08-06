//
//  DateExtension.swift
//  5dmax
//
//  Created by admin on 9/6/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let now = Date()
        let calendar = NSCalendar.current
        let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        let components = calendar.dateComponents(components1, from: date, to: now)
        
        if components.year ?? 0 > 0 {
            formatter.allowedUnits = .year
        } else if components.month ?? 0 > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth ?? 0 > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day ?? 0 > 0 {
            formatter.allowedUnits = .day
        } else if components.hour ?? 0 > 0 {
            formatter.allowedUnits = [.hour]
        } else if components.minute ?? 0 > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = NSLocalizedString("%@ trước", comment: "")
        
        guard let timeString = formatter.string(for: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
}
