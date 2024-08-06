//
//  HomeCountryContainerViewModel.swift
//  5dmax
//
//  Created by Hoang on 3/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeCountryContainerViewModel: NSObject {

    var title: String?
    private var menuTitle: [String] = [String.noi_bat.uppercased(), String.danh_muc.uppercased()]
    var highlightsFilmVC: MoreContentViewController?
    var listCategoryVC: ListCategoryViewController?
    var filmOfCountryVC: MoreContentViewController?
    var selectedCategory: CategoryModel?
    var selectedIndex: Int = 0

    func getListMenuTitle() -> [String] {

        menuTitle = [String.noi_bat.uppercased(), String.danh_muc.uppercased()]

        if let country = selectedCategory {
            menuTitle.append(country.name.uppercased())
        }

        return menuTitle
    }

    func getIndexOfView(currentVC: UIViewController) -> Int {

        if currentVC == highlightsFilmVC {

            return 0

        } else if currentVC == listCategoryVC {

            return 1

        } else if currentVC == filmOfCountryVC {

            return 2
        }
        return 0
    }

    func getViewAtIndex(index: Int) -> UIViewController? {

        if index == 0 {

            return highlightsFilmVC
        }

        if index == 1 {

            return listCategoryVC
        }

        if index == 2 {

            return filmOfCountryVC
        }

        return nil
    }
}
