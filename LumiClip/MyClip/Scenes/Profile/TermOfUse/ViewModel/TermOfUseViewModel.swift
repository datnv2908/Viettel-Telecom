//
//  TermOfUseViewModel.swift
//  MyClip
//
//  Created by sunado on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class TermOfUseViewModel : NSObject {
    func getContent() -> String? {
        let content = HtmlContentType.termOfUse.content()
        let result = "<html><body style=\"font-size:xx-large;\">\(content)</body></html>"
        return result
    }
    
    func getTitle() -> String {
        return String.dieu_khoan_va_chinh_sach_bao_mat
    }
}
