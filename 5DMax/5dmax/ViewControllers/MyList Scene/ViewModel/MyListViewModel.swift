//
//  MyListViewModel.swift
//  5dmax
//
//  Created by Gem on 4/11/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyListViewModel: NSObject {
    weak var view: MyListViewController!

    var title: String {
        return String.danh_sach_cua_toi
    }

    var listMenuTitle: [String] {
        return [MyList.later.description(), MyList.history.description()]
    }

    func currentIndex(ofVC: UIViewController) -> Int {
        if ofVC == self.view.mylistVC {
            return MyList.later.rawValue
        }

        return MyList.history.rawValue
    }

    func viewAtIndex(_ index: Int) -> UIViewController? {
        if index == 0 {
            return self.view.mylistVC
        } else if index == 1 {
            return self.view.watchingVC
        }

        return nil
    }
}
