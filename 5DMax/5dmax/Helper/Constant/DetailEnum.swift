//
//  DetailEnum.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum FilmDetailSectionType {
    case cover
    case title
    case rate
    case price
    case desc
    case extraDesc
    case infor
    case related
    case related_update
    case seasion
    case trailer
    case trailer_Update
    case part
    
    func identifier() -> String {
        switch self {
        case .cover:
            return FilmCoverCollectionViewCell.nibName()
        case .rate:
            return FilmRateCollectionViewCell.nibName()
        case .price:
            return FilmPriceCollectionViewCell.nibName()
        case .desc:
            return FilmDescCollectionViewCell.nibName()
        case .extraDesc:
            return FilmExtraDescCollectionViewCell.nibName()
        case .infor:
            return FilmInfoCollectionViewCell.nibName()
        case .related:
            return MovieItemCollectionViewCell.nibName()
        case .trailer:
            return TrailerCollectionViewCell.nibName()
        case .trailer_Update:
            return TrailerUpdatingCollectionViewCell.nibName()
        case .part:
            return FilmPartNumberCollectionViewCell.nibName()
        case .related_update:
            return RelateUpdateCollectionViewCell.nibName()
        case .title:
            return FilmRateCollectionViewCell.nibName()
        case .seasion :
            return FilmSeasonCollectionViewCell.nibName()
        }
    }

    func headerIdentifier() -> String? {
        switch self {
        case .related:
            return FilmRelatedCollectionReusableView.nibName()
        case .related_update:
            return FilmRelatedCollectionReusableView.nibName()
        case .trailer:
            return FilmRelatedCollectionReusableView.nibName()
        case .trailer_Update:
            return FilmRelatedCollectionReusableView.nibName()
        case .part:
            return FilmRelatedCollectionReusableView.nibName()
        default:
            return nil
        }
    }
    
    static  func insetForSectionConstant( _ type :FilmDetailSectionType ) -> UIEdgeInsets {
        switch type {
        case .extraDesc:
            return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        case .rate:
            return UIEdgeInsets.zero
        case .cover:
            return UIEdgeInsets.zero
        case .title:
            return UIEdgeInsets.zero
        case .related:
            return UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
        default:
            return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
        }
    }
    func insetForSection() -> UIEdgeInsets {
           switch self {
           case .extraDesc:
               return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
           case .rate:
               return UIEdgeInsets.zero
           case .cover:
               return UIEdgeInsets.zero
           case .title:
               return UIEdgeInsets.zero
           case .related:
               return UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
           default:
               return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
           }
       }
     func itemSpacing() -> CGFloat {
        switch self {
        case .extraDesc:
            return 0
        case .part:
            return 0
        case .related:
            return 8
        case .cover:
            return 0
        default:
            if Constants.isIpad {
                return 17
            } else {
                return 8
            }
        }
    }
     static func itemSpacingConstant(_ type :FilmDetailSectionType) -> CGFloat {
        switch type {
        case .extraDesc:
            return 0
        case .part:
            return 0
        case .related:
            return 8
        case .cover:
            return 0
        default:
            if Constants.isIpad {
                return 17
            } else {
                return 8
            }
        }
    }
    func lineSpacing() -> CGFloat {
        if self == .part {
            return 0
        }
        
        if self == .related {
            return 0
        }
        return 22.0
    }

    static func marginConstant(type : FilmDetailSectionType) -> CGFloat {
        if Constants.isIpad {
            return self.insetForSectionConstant(type).left + self.insetForSectionConstant(type).right
        } else {
            return self.insetForSectionConstant(type).left + self.insetForSectionConstant(type).right
        }
    }
    func margin() -> CGFloat {
           if Constants.isIpad {
               return self.insetForSection().left + self.insetForSection().right
           } else {
               return self.insetForSection().left + self.insetForSection().right
           }
       }
    func sizeForItem() -> CGSize {
        let margin = self.margin()
        let numberOfItems = self.numberOfItemsPerRow()
        let itemSpacing = FilmDetailSectionType.self.itemSpacing(.related)
        let itemspace =  (CGFloat(numberOfItems) - 1.0) * itemSpacing()
        let value = Constants.screenWidth - margin - itemspace
        let itemWidth = floor(value / numberOfItems)
        let itemHeight = floor(itemWidth / self.scaleForItem() + self.additionalSpacing())

        switch self {
        case .part:
            return CGSize(width: Constants.screenWidth, height: Constants.isIpad ? 130.0 : 90.0)
        case .cover:
            return CGSize(width: itemWidth, height: itemHeight)
        case .price:
            return CGSize(width: itemWidth, height: 50)
        case .related:
            return CGSize(width: itemWidth, height: itemHeight)
        case .related_update:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16)
        case .trailer:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16 + 44.0)
        case .trailer_Update:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16)
        default:
            return CGSize.zero
        }
    }
    static func  sizeforCell (type : FilmDetailSectionType) -> CGSize
    {
        let margin = self.marginConstant(type: type)
        let numberOfItems = self.numberOfItemsPerRowConstant(type)
        let itemSpacing = self.itemSpacingConstant(type)
        let value = Constants.screenWidth - margin -
        (CGFloat(numberOfItems) - 1.0) * itemSpacing
        let itemWidth = floor( value / numberOfItems)
        let itemHeight = floor(itemWidth / self.scaleForItemConstant(type) + self.additionalSpacingConstant(type))
        
        switch type {
        case .part:
            return CGSize(width: Constants.screenWidth, height: Constants.isIpad ? 130.0 : 90.0)
        case .cover:
            return CGSize(width: itemWidth, height: itemHeight)
        case .price:
            return CGSize(width: itemWidth, height: 50)
        case .related:
            return CGSize(width: itemWidth, height: itemHeight)
        case .related_update:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16)
        case .trailer:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16 + 44.0)
        case .trailer_Update:
            return CGSize(width: Constants.screenWidth, height: Constants.screenWidth*9/16)
        default:
            return CGSize.zero
        }
    }
    static func numberOfItemsPerRow(_ type : FilmDetailSectionType ) -> CGFloat {
        switch type {
        case .related:
            if Constants.isIpad {
                return 5.0
            } else {
                return 3.0
            }
        default:
            return 1.0
        }
    }
    static func numberOfItemsPerRowConstant(_ type : FilmDetailSectionType ) -> CGFloat {
        switch type {
        case .related:
            if Constants.isIpad {
                return 5.0
            } else {
                return 3.0
            }
        default:
            return 1.0
        }
    }
    func numberOfItemsPerRow() -> CGFloat {
           switch self {
           case .related:
               if Constants.isIpad {
                   return 5.0
               } else {
                   return 3.0
               }
           default:
               return 1.0
           }
       }
   static func  scaleForItemConstant(_ type : FilmDetailSectionType) -> CGFloat {
        switch type {
        case .cover:
            return 16.0/9.0
        case .related:
            return 2.0/3.0
        case .trailer:
            return 1.0
        case .part:
            return 2.0
        default:
            return 1.0
        }
    }
    func scaleForItem() -> CGFloat {
          switch self {
          case .cover:
              return 16.0/9.0
          case .related:
              return 2.0/3.0
          case .trailer:
              return 1.0
          case .part:
              return 2.0
          default:
              return 1.0
          }
      }
   static func additionalSpacingConstant(_ type : FilmDetailSectionType) -> CGFloat {
        switch type {
        case .related:
            if Constants.isIpad {
                return 46 // = size for title (35) + 5 (spacing between title and image)
            } else {
                return 40 // = size for title (35) + 5 (spacing between title and image)
            }
        default:
            return 0.0
        }
    }
     func additionalSpacing() -> CGFloat {
         switch self {
         case .related:
             if Constants.isIpad {
                 return 46 // = size for title (35) + 5 (spacing between title and image)
             } else {
                 return 40 // = size for title (35) + 5 (spacing between title and image)
             }
         default:
             return 0.0
         }
     }
    func sizeForHeader() -> CGSize {
        let margin = self.margin()
        let width = Constants.screenWidth - margin
        switch self {
        case .related:
            return CGSize(width: width, height: 80)
        case .related_update:
            return CGSize(width: width, height: 80)
        case .trailer:
            return CGSize(width: width, height: 80)
        case .trailer_Update:
            return CGSize(width: width, height: 80)
        case .part:
            return CGSize(width: width, height: 80)
        default:
            return CGSize.zero
        }
    }
}
