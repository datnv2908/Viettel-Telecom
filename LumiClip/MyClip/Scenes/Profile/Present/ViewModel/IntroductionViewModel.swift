//
//  IntroductionViewModel.swift
//  MyClip
//
//  Created by sunado on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class IntroductionViewModel : NSObject {
    func getContent() -> String? {
        let content = HtmlContentType.aboutUs.content()
        let result = "<html><body style=\"font-size:xx-large;\">\(content)</body></html>"
        return result
    }
    
    func getTitle() -> String {
        return String.introduce
    }
}
