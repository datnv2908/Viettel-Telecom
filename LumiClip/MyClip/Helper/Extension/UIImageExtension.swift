//
//  UIImageExtension.swift
//  MyClip
//
//  Created by Huy Nguyen on 5/11/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2.0))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-(Double.pi/2.0)))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        switch imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        let cgImage: CGImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
    
    @objc public func splitImage(sizeItem:CGSize, emptySpaceItem:Int = 1) -> [UIImage] {
        let sizeImageParent:CGSize = self.size
        
        var imagesColumn = [UIImage]()
        let tmpImgRef = self.cgImage
        let numberItemsInColumn:Int = Int(sizeImageParent.height/sizeItem.height)
        
        for i in 0..<numberItemsInColumn { // split rows in image
            let itemRef = tmpImgRef?.cropping(to: CGRect(x: 0,
                                                         y: i*(Int(sizeItem.height) + emptySpaceItem) + emptySpaceItem,
                                                         width: Int(sizeImageParent.width),
                                                         height: Int(sizeItem.height)))
            var item: UIImage? = nil
            if let aRef = itemRef {
                item = UIImage(cgImage: aRef)
            }
            imagesColumn.append(item!)
        }
        var images = [UIImage]()
        for i in 0..<imagesColumn.count {
            let itemColumn = imagesColumn[i]
            let tmpImgRefColumn = itemColumn.cgImage
            let numberItemsInRow:Int = Int(itemColumn.size.width/sizeItem.width)
            for i in 0..<numberItemsInRow { // split images in image row
                let itemRef = tmpImgRefColumn?.cropping(to: CGRect(x: i*(Int(sizeItem.width) + emptySpaceItem) + emptySpaceItem,
                                                                   y: 0 + emptySpaceItem,
                                                                   width: Int(sizeItem.width),
                                                                   height: Int(sizeImageParent.height)))
                var item: UIImage? = nil
                if let aRef = itemRef {
                    item = UIImage(cgImage: aRef)
                }
                images.append(item!)
            }
        }
        return images
    }
}
