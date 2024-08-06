//
//  MoreContentEnum.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum MoreContentType: String {
    case film = "FILM"

    func rowIdentifier() -> String {
        switch self {
        case .film:
            return MovieItemCollectionViewCell.nibName()
        }
    }

    func insetForSection() -> UIEdgeInsets {
        switch self {
        case .film:
            return UIEdgeInsets(top: 22, left: 11, bottom: 22, right: 11)
        }
    }

    func itemSpacing() -> CGFloat {
        switch self {
        case .film:
            if Constants.isIpad {
                return 13
            } else {
                return 7
            }
        }
    }

    func lineSpacing() -> CGFloat {
        return 22
    }

    func sizeForItem() -> CGSize {
        let margin = self.insetForSection().left + self.insetForSection().right
        let numberOfItems = self.numberOfItemsPerRow()
        let itemSpacing = self.itemSpacing()
        let itemWidth = floor((Constants.screenWidth - margin -
            (CGFloat(numberOfItems) - 1.0) * itemSpacing) / numberOfItems)
        let itemHeight = floor(itemWidth / self.scaleForItem() + self.additionalSpacing())
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func numberOfItemsPerRow() -> CGFloat {
        switch self {
        case .film:
            if Constants.isIpad {
                return 5.0
            } else {
                return 3.0
            }
        }
    }

    func scaleForItem() -> CGFloat {
        switch self {
        case .film:
            return 2.0/3.0
        }
    }

    func additionalSpacing() -> CGFloat {
        switch self {
        case .film:
            if Constants.isIpad {
                return 46 // = size for title (35) + 5 (spacing between title and image)
            } else {
                return 40 // = size for title (35) + 5 (spacing between title and image)
            }
        }
    }
}
