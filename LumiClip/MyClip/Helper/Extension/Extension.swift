//
//  Extension.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import Alamofire
import DateToolsSwift

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible,
                       with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

extension NSData: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible,
                       with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self as Data
        return request
    }

}

extension Data {
    func fileSize() -> String {
        let countBytes = ByteCountFormatter()
        countBytes.allowedUnits = [.useMB]
        countBytes.countStyle = .file
        let fileSize = countBytes.string(fromByteCount: Int64(self.count))
        return fileSize
    }
}

extension Date {
    func toString() -> String {
        let day = self.component(.day)
        let month = self.component(.month)
        let year = self.component(.year)
        return String.init(format: "\(String.ngay) %d \(String.thang.lowercased()) %d, %d", day, month, year)
    }
}

extension CountableRange where Bound: Strideable, Bound == Int {
    var random: Int {
        return lowerBound + Int(arc4random_uniform(UInt32(count)))
    }
    func random(_ n: Int) -> [Int] {
        return (0..<n).map { _ in random }
    }
}

extension CountableClosedRange where Bound: Strideable, Bound == Int {
    var random: Int {
        return lowerBound + Int(arc4random_uniform(UInt32(count)))
    }
    func random(_ n: Int) -> [Int] {
        return (0..<n).map { _ in random }
    }
}

extension Array {
    func random() -> Element {
        let itemCount = self.count
        let random = (0...itemCount-1).random
        return self[random]        
    }
}
extension UIBarButtonItem {

   static func menuButton(_ target: Any?, action: Selector, imageName: String?, title : String) -> UIBarButtonItem {
      let button = UIButton(type: .system)
      //          button.setImage(UIImage(named: imageName), for: .normal)
      button.setTitle(title, for: .normal)
      button.addTarget(target, action: action, for: .touchUpInside)
      if let imageName = imageName {
         if let  img  = UIImage(named: imageName){
         button.addRightIcon(image: img)
         }
      }
      let menuBarItem = UIBarButtonItem(customView: button)
      menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
      menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
      menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
      
      return menuBarItem
   }
}
extension UIButton {
   func addRightIcon(image: UIImage) {
       let imageView = UIImageView(image: image)
       imageView.translatesAutoresizingMaskIntoConstraints = false

       addSubview(imageView)

       let length = CGFloat(10)
       titleEdgeInsets.right += length

       NSLayoutConstraint.activate([
           imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
           imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
           imageView.widthAnchor.constraint(equalToConstant: length),
           imageView.heightAnchor.constraint(equalToConstant: length)
       ])
   }
   
}
extension UIButton {
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
}
extension UIImage {
    func resizeImage( targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension UIColor {
    
   static func settitleColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (traitCollection) -> UIColor in
               return traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
            }
        } else {
         return UIColor.white
        }
    }
   @objc  static func setViewColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (traitCollection) -> UIColor in
               return traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.colorFromHexa("1c1c1e")
            }
        } else {
         return UIColor.white
        }
    }
    @objc static func setSeprateViewColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (traitCollection) -> UIColor in
               return traitCollection.userInterfaceStyle == .light ? UIColor.lightGray : UIColor.colorFromHexa("1c1c1e")
            }
        } else {
         return UIColor.lightGray
        }
    }
   static func setDarkModeColor(color1 : UIColor , color2 : UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (traitCollection) -> UIColor in
               return traitCollection.userInterfaceStyle == .light ? color1 : color2
            }
        } else {
         return color1
        }
    }
}
