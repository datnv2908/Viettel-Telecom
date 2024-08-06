//
//  HomeEnum.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum BlockType: String, Codable {
    case banner = "BANNER"
    case watching = "WATCHING"
    case myList = "MYLIST"
    case film = "FILM"
    case trailer = "TRAILER"
    case trailer_update = "TRAILER_UPDATE"
    case related_update = "RELATED_UPDATE"
    case comingsoon = "COMING_SOON"
    case series = "film_series"
    func blockId() -> String {
        switch self {
        case .banner:
            return "banner_FILM"
        case .watching:
            return "film_history"
        case .comingsoon:
            return "film_comingsoon"
        case .series :
            return "film_series"
        default:
            return ""
        }
    }

    func sectionIdentifier() -> String {
        switch self {
        case .banner:
            return SliderTableViewCell.nibName()
        case .comingsoon:
            return CollectionTableViewCell.nibName()
        case .trailer:
            return TrailerCollectionViewCell.nibName()
        case .trailer_update:
            return TrailerUpdatingCollectionViewCell.nibName()
        case .related_update:
            return RelateUpdateCollectionViewCell.nibName()
        case .series :
            return SeriesTableViewCell.nibName()
        default:
            return CollectionTableViewCell.nibName()
        }
    }

    func rowIdentifier() -> String {
        switch self {
        case .banner:
            return SliderItemCollectionViewCell.nibName()
        case .watching:
            return WatchingItemCollectionViewCell.nibName()
        case .comingsoon:
            return FilmUpcomingCollectionViewCell.nibName()
        case .trailer:
            return TrailerCollectionViewCell.nibName()
        case .trailer_update:
            return TrailerUpdatingCollectionViewCell.nibName()
        case .related_update:
            return RelateUpdateCollectionViewCell.nibName()
        default:
            return MovieItemCollectionViewCell.nibName()
        }
    }
    
    func insetForSection() -> UIEdgeInsets {
        switch self {
        case .banner:
            return UIEdgeInsets.zero
        case .comingsoon:
            return UIEdgeInsets.zero
        case .watching:
            return UIEdgeInsets.zero
        default:
            var leftMargin: CGFloat
            var rightMargin: CGFloat
            if Constants.isIpad {
                leftMargin = 11
                rightMargin = 11
            } else {
                leftMargin = 11
                rightMargin = 11
            }
            return UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: rightMargin)
        }
    }

    func itemMargin() -> UIEdgeInsets {
        switch self {
        case .banner:
            return UIEdgeInsets.zero
        case .comingsoon:
            return UIEdgeInsets.zero
        case .watching:
            return UIEdgeInsets.zero
        default:
            var leftMargin: CGFloat
            var rightMargin: CGFloat
            if Constants.isIpad {
                leftMargin = 11
                rightMargin = 63
            } else {
                leftMargin = 11
                rightMargin = 11
            }
            return UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: rightMargin)
        }
    }

    func itemSpacing() -> CGFloat {
        switch self {
        case .banner:
            return 0
        case .comingsoon:
            return 0
        default:
            if Constants.isIpad {
                return 12
            } else {
                return 8
            }
        }
    }
    
    func sizeForSection() -> CGSize {
        switch self {
        case .series:
            let margin = self.itemMargin().left + self.itemMargin().right
            let width = Constants.screenWidth - margin
//            let height = self.sizeForItem().height
            return CGSize(width: width, height: UITableView.automaticDimension)
        default:
            let margin = self.itemMargin().left + self.itemMargin().right
            let width = Constants.screenWidth - margin
            let height = self.sizeForItem().height
            return CGSize(width: width, height: height)
        }
        
    }

    func sizeForItem() -> CGSize {
        let margin = self.itemMargin().left + self.itemMargin().right
        let numberOfItems = self.numberOfItemsPerRow()
        let itemSpacing = self.itemSpacing()
        let itemWidth = floor((Constants.screenWidth - margin -
            (CGFloat(numberOfItems) - 1.0) * itemSpacing) / numberOfItems)
        let itemHeight = floor(itemWidth / self.scaleForItem() + self.additionalSpacing())
        
        switch self {
            case .watching:
                let newItemWidth = floor(2.0*itemWidth + itemSpacing)
                let newItemHeight = floor(newItemWidth / self.scaleForItem() + self.additionalSpacing())
                return CGSize(width: newItemWidth, height: newItemHeight)
            case .banner:
                return CGSize(width: itemWidth, height: itemHeight + 30.0)
            case .comingsoon:
                return CGSize(width: itemWidth, height: itemHeight + 50.0)
            default:
                return CGSize(width: itemWidth, height: itemHeight)
        }
    }

    func numberOfItemsPerRow() -> CGFloat {
        switch self {
        case .banner:
            return 1.0
        case .comingsoon:
            return 1.0
        default:
            if Constants.isIpad {
                return 4.0
            } else {
                return 3.0
            }
        }
    }

    func scaleForItem() -> CGFloat {
        switch self {
        case .banner:
            return 16.0/9.0
        case .watching:
            return 16.0/9.0
        case .comingsoon:
            return 16.0/9.0
        default:
            return 2.0/2.86
//        default:
//            return 2.0/3.0
        }
    }

    func additionalSpacing() -> CGFloat {
        switch self {
        case .banner:
            return 3 // size for black line
        case .comingsoon:
            return 0
        case .watching: // size for title view
            if Constants.isIpad {
                return 60
            } else {
                return 50
            }
        default:
            if Constants.isIpad {
                return 46 // = size for title (35) + 5 (spacing between title and image)
            } else {
                return 40 // = size for title (35) + 5 (spacing between title and image)
            }
        }
    }
}
