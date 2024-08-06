//
//  DataManager.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/4/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

@objcMembers
class DataManager: NSObject {

    class func objectForKey(_ key: String) -> Any? {
        let userDefault = UserDefaults.standard
        return userDefault.value(forKey: key)
    }

    class func boolForKey(_ key: String) -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }

    class func integerForKey(_ key: String) -> Int {
        let userDefault = UserDefaults.standard
        return userDefault.integer(forKey: key)
    }

    class func removeObject(forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }

    class func save(object: Any, forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(object, forKey: key)
        userDefault.synchronize()
    }

    class func save(boolValue: Bool, forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(boolValue, forKey: key)
        userDefault.synchronize()
    }

    class func save(integerValue: Int, forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(integerValue, forKey: key)
        userDefault.synchronize()
    }

    class func save(floatValue: Float, forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(floatValue, forKey: key)
        userDefault.synchronize()
    }

    class func floatForKey(_ key: String) -> Float {
        let userDefault = UserDefaults.standard
        return userDefault.float(forKey: key)
    }

    // MARK: 
    // MARK: User Profile
    class func saveMemberModel(_ model: MemberModel) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kUserModel)
        DataManager.save(object: Constants.loggedIn, forKey: Constants.kLoginStatus)
    }

    class func getCurrentMemberModel() -> MemberModel? {
        if let data = DataManager.objectForKey(Constants.kUserModel) {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? MemberModel
            return model
        } else {
            return nil
        }
    }

    // MARK:
    // MARK: account settings
    class func saveAccountSettingsModel(_ model: AccountSettingsModel) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kSettingDefault)
    }
    
    class func getCurrentAccountSettingsModel() -> AccountSettingsModel? {
        if let data = DataManager.objectForKey(Constants.kSettingDefault) {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? AccountSettingsModel
            return model
        }
        
        return nil
    }
   
//   class  func setThemeForUser(darkMode : Bool){
//      if let model = DataManager.getCurrentMemberModel() {
//         DataManager.saveValueDarkMode(value: darkMode)
//         if  darkMode {
//            model.themeUser  =  1
//         }else{
//            model.themeUser  =  0
//         }
//         DataManager.saveMemberModel(model)
//      }else{
//         DataManager.saveValueDarkMode(value: darkMode)
//      }
//   }
   
   class func saveStatusBarStyle (styleBarStatus : Int)
   {
      if #available(iOS 13.0, *) {
         if styleBarStatus == UIStatusBarStyle.darkContent.rawValue {
            DataManager.saveValueDarkMode(value: true)
         }else{
            DataManager.saveValueDarkMode(value: false)
         }
      } else {
         DataManager.saveValueDarkMode(value: false)
      }
   }
//   class func getStatusBarStyle () -> Int{
//      return DataManager.integerForKey(Constants.statusBarStyle)
//   }
   class func saveValueDarkMode (value : Bool) {
      DataManager.save(boolValue: value, forKey: Constants.statusBarStyle)
   }
   class func getStatusbarVaule() -> Bool {
      return DataManager.boolForKey(Constants.statusBarStyle)
   }
    // MARK: 
    class func isLoggedIn() -> Bool {
        let userModel = getCurrentMemberModel()
        if userModel != nil {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Search
    class func setHiddenKeywordSearch() {
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: Constants.kShowKeywordSearch)
        userDefault.synchronize()
    }
    
    class func checkShowKeywordSearch() -> Bool {
        
        let userDefault = UserDefaults.standard
        if (userDefault.object(forKey: Constants.kShowKeywordSearch) != nil) {
            return false
        }
        return true
    }
    
    class func setHiddenTutorial() {
        
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: Constants.kShowTutorial)
        userDefault.synchronize()
    }
    
    class func checkShowTutorial() -> Bool {
        
        let userDefault = UserDefaults.standard
        if (userDefault.object(forKey: Constants.kShowTutorial) != nil) {
            return false
        }
        return true
    }

    class func clearLoginSession() {
        // clear all loggin user info
        Singleton.sharedInstance.isAcceptLossData = false
        DataManager.removeObject(forKey: Constants.kUserModel)
        DataManager.removeObject(forKey: Constants.kLoginStatus)
        DataManager.save(boolValue: false, forKey: Constants.kLoginFacebook)
        // signout social SDK
        GIDSignIn.sharedInstance().signOut()
        // clear uploading items
        UploadService.sharedInstance.cancelAllUploadingItems()
        // clear all downloading items
        DownloadManager.shared.cancelAllDownloadingItems()
    }
    
    class func isAutoPlayNextVideo() -> Bool {
        return !UserDefaults.standard.bool(forKey: Constants.kShouldNotAutoPlay)
    }
    
    class func toggleAutoPlayNextVideo() -> Bool {
        var status = UserDefaults.standard.bool(forKey: Constants.kShouldNotAutoPlay)
        status = !status
        DataManager.save(boolValue: status, forKey: Constants.kShouldNotAutoPlay)
        return status
    }

    class func isSufferingPlaylist() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.kSufferVideoInPlaylist)
    }

    class func isRepeatPlaylist() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.kRepeatVideoInPlaylist)
    }

    class func toggleSufferingPlaylist(_ preferedValue: Bool? = nil) -> Bool {
        if let value = preferedValue {
            DataManager.save(boolValue: value, forKey: Constants.kSufferVideoInPlaylist)
            return value
        } else {
            var status = UserDefaults.standard.bool(forKey: Constants.kSufferVideoInPlaylist)
            status = !status
            DataManager.save(boolValue: status, forKey: Constants.kSufferVideoInPlaylist)
            return status
        }
    }

    class func toggleRepeatPlaylist(_ preferedValue: Bool? = nil) -> Bool {
        if let value = preferedValue {
            DataManager.save(boolValue: value, forKey: Constants.kRepeatVideoInPlaylist)
            return value
        } else {
            var status = UserDefaults.standard.bool(forKey: Constants.kRepeatVideoInPlaylist)
            status = !status
            DataManager.save(boolValue: status, forKey: Constants.kRepeatVideoInPlaylist)
            return status
        }
    }
}
