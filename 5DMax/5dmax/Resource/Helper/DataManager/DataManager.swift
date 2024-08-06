//
//  DataManager.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/4/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    class func objectForKey(_ key: String) -> Any? {
        let userDefault = UserDefaults.standard
        return userDefault.value(forKey: key)
    }

    class func boolForKey(_ key: String) -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }
    
    class func stringForKey(_ key: String) -> String {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: key) ?? ""
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
    class func saveCurrentTimeLogin(time : Int , key : String){
        print("time save \(time)")
        DataManager.save(object: time, forKey: key)
    }
    class func getCurrentTimeLogin() -> Int {
        return  DataManager.integerForKey(Constants.time_Expire)
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
    
    class func save(stringValue: String, forKey key: String) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(stringValue, forKey: key)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kNotificationLoginSuccess), object: nil)
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
    // MARK: FILM QUALITY
    class func saveSetting(_ model: SettingModel) {

        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kSettingDefault)
    }

    class func getDefaultSetting() -> SettingModel? {

        if let data = DataManager.objectForKey(Constants.kSettingDefault) {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? SettingModel
            return model
        } else {
            return nil
        }
    }

    // MARK: 
    // MARK: FILM QUALITY
    class func saveSettingFilmQuality(_ model: QualityModel) {

        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kFilmQuality)
    }

    class func getSettingFilmQuality() -> QualityModel {

        if let data = DataManager.objectForKey(Constants.kFilmQuality) {
            if let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? QualityModel {

                return model
            }

            return QualityModel.defaultModel()

        } else {
            return QualityModel.defaultModel()
        }
    }

    // MARK: 
    // MARK: DOWNLOAD FILM QUALITY
    class func saveSettingDownloadFilmQuality(_ model: QualityModel) {

        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kDownloadQuality)
    }

    class func getSettingDownloadFilmQuality() -> QualityModel {

        if let data = DataManager.objectForKey(Constants.kDownloadQuality) {
            if let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? QualityModel {

                return model
            }

            return QualityModel.defaultModel()

        } else {
            return QualityModel.defaultModel()
        }
    }

    // MARK: 
    // MARK: IS DOWNLOAD WHEN WIFI
    class func saveSettingDownloadWifi(isActive: Bool) {
        let userDefault = UserDefaults.standard
        userDefault.set(isActive, forKey: Constants.kDownloadWifi)
        userDefault.synchronize()
    }

    class func getSettingDownloadWifi() -> Bool {

        let userDefault = UserDefaults.standard
        if userDefault.object(forKey: Constants.kDownloadWifi) != nil {
            return DataManager.boolForKey(Constants.kDownloadWifi)
        }
        return true
    }

    // MARK: 
    // MARK: LIST PACKAGE
    class func saveListPackage(_ list: [PackageModel]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: list)
        DataManager.save(object: encodedData, forKey: Constants.kListPackage)
    }

    class func getListPackage() -> [PackageModel] {
        if let data = DataManager.objectForKey(Constants.kListPackage) {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? [PackageModel] ?? []
            return model
        } else {
            return []
        }
    }

    // MARK: 
    // MARK: PIN
    class func savePIN(_ model: PinModel) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: model)
        DataManager.save(object: encodedData, forKey: Constants.kPinCode)
    }

    class func deletePIN() {
        DataManager.removeObject(forKey: Constants.kPinCode)
    }

    class func getPinModel() -> PinModel {
        if let data = DataManager.objectForKey(Constants.kPinCode) {
            let model = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? PinModel ?? PinModel()
            return model
        }
        return PinModel()
    }

    // MARK: 
    // MARK: 
    class func isLoggedIn() -> Bool {
        let userModel = getCurrentMemberModel()
        if userModel != nil {
            return true
        } else {
            return false
        }
    }

    class func clearLoginSession() {
        DataManager.removeObject(forKey: Constants.kUserModel)
        DataManager.removeObject(forKey: Constants.kLoginStatus)
        DataManager.save(boolValue: false, forKey: Constants.kLoginFacebook)
        DataManager.save(boolValue: false, forKey: Constants.kDidRegisterDeviceToken)
    }
}
