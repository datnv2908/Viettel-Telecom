//
//  APIRequestProvider.swift
//  5dmax
//
//  Created by Huy Nguyen on 1/4/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import DateTools

let kClientVersionHeaderField = "os_version_code"
let kClientOSHeaderField = "os_type"
let kClientLanguageField = "language"


//let baseURL = "http://192.168.146.252:9130"
//let baseURL = "http://m.5dmax.vn/apiv2.php"
//let baseURL = "http://125.212.229.33:11802"
let baseURL = "http://api-videoplay.bitel.com.pe"
//let baseURL = "http://192.168.146.252:9244"
//let baseURL = "http://207.246.121.81"
let apiVersion = "/v1"

/*
//let baseURL = "http://192.168.146.252:8723"
//let baseURL = "http://m.5dmax.vn/apiv2.php"
let baseURL = "http://5dmax.vn/apiv3.php"
*/

/*
 *  APIRequestProvider takes responsible for build and provide request for service objects
 *  default header for request will be defined here
 */
class APIRequestProvider: NSObject {

    //mark: SINGLETON
    static var shareInstance: APIRequestProvider = {
        let instance = APIRequestProvider()
        return instance
    }()

    //mark: DEFAULT HEADER & REQUEST URL
    private var _headers: HTTPHeaders = [:]
    var headers: HTTPHeaders {
        set {
            _headers = headers
        }

        get {
            var accessToken = ""
            if let user = DataManager.getCurrentMemberModel() {
                accessToken = "Bearer " + user.accessToken
            }

            let headers: HTTPHeaders = [
                "Authorization": accessToken,
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "\(kClientLanguageField)": "\(getShortLanguage())"
            ]

            return headers
        }
    }

    private var _headersLogin: HTTPHeaders = [:]
    var headersLogin: HTTPHeaders {
        set {
            _headersLogin = headersLogin
        }
        get {
            let imei = UIDevice.current.identifierForVendor?.uuidString
            let authorization = "Bearer " + imei!

            let headersLogin: HTTPHeaders = [
                "Authorization": authorization,
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "\(kClientLanguageField)": "\(getShortLanguage())"
            ]

            return headersLogin
        }
    }

    func commonParam() -> [String: String] {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceOS = "ios"
        
        var param = [String: String]()
        param[kClientVersionHeaderField] = version
        param[kClientOSHeaderField] = deviceOS
        param[kClientLanguageField] = getShortLanguage()
        return param
    }

    private var _requestURL: String = baseURL
    var requestURL: String {
        set {
            _requestURL = requestURL
        }
        get {

            var url = _requestURL
            url.append("\(apiVersion)/")
            return url
        }
    }

    var alamoFireManager: SessionManager

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30 // seconds for testing

        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }

    //mark: -- Authorization Requests
    func loginRequest(username: String,
                      password: String,
                      grantType: GrantType,
                      captcha: String,
                      refreshToken: String,
                      socialToken: String,
                      loginType: LoginType) -> DataRequest {

        let urlString = requestURL.appending("auth/authorize")
        var param = commonParam()
        param["grant_type"]         = grantType.stringValue()

        switch grantType {
        case .autoLogin:
            param["data"]           = DataManager.objectForKey(Constants.kMPSDetectLink) as? String
            break

        case .loginSocial:
            param["access_token"]   = socialToken

            break

        case .refreshToken:
            param["username"]       = username.phoneNumber()
            param["password"]       = password
            param["refresh_token"]  = refreshToken
            break

        default:
            param["data"]           = DataManager.objectForKey(Constants.kMPSDetectLink) as? String
            param["username"]       = username.phoneNumber()
            param["password"]       = password
            break

        }

        switch loginType {
        case .facebook:
            param["social_id"]      = loginType.stringValue()
            break

        case .mobile3G:

            break

        default:
            break
        }

        if !captcha.characters.isEmpty {
            switch grantType {
            case .autoLogin:
                break

            default:
                param["captcha"]    = captcha
                break
            }
        }
        param["os_type"]            = "IOS"
        param["os_version_code"]    = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headersLogin)
    }

    func logoutRequest(token: String) -> DataRequest {
        let urlString = requestURL.appending("auth/logout")
        var param = commonParam()
        param["refresh_token"] = token

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func getCaptcha() -> DataRequest {
        let urlString = requestURL.appending("auth/get-captcha")
        let header: HTTPHeaders
        if DataManager.isLoggedIn() {
            header = self.headers
        } else {
            header = self.headersLogin
        }
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: nil,
                                        encoding: URLEncoding.default,
                                        headers: header)
    }

    func getOTPCode(msisdn: String) -> DataRequest {
        let urlString = requestURL.appending("auth/push-otp")
        var param = commonParam()
        param["msisdn"] = msisdn.phoneNumber()

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }
    
    func getLoginSMSOTPCode(msisdn: String) -> DataRequest {
        let urlString = requestURL.appending("default/get-otp")
        var param = commonParam()
        param["msisdn"] = msisdn.phoneNumber()
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func registerSMSOTP(msisdn: String, otpCode: String) -> DataRequest {
        let urlString = requestURL.appending("default/verify-otp")
        var param = commonParam()
        param["msisdn"] = msisdn.phoneNumber()
        param["code"] = otpCode
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }
    
    func registerMember(msisdn: String, password: String, otpCode: String, captcha: String) -> DataRequest {
        let urlString = requestURL.appending("auth/sign-up-by-msisdn")
        var param = commonParam()
        param["msisdn"]     = msisdn.phoneNumber()
        param["password"]   = password
        param["otp"]        = otpCode

        if !captcha.characters.isEmpty {
            param["captch"] = captcha
        }

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }

    func changePassword(password: String, newPassword: String, reNewPassword: String, captcha: String, isFromOTP: Bool = false) -> DataRequest {
        let urlString = requestURL.appending("auth/change-password")
        var param = commonParam()
        if (isFromOTP) {
            param["otp"] = password
        } else {
            param["password"] = password
        }
        
        param["new_password"] = newPassword
        param["repeat_password"] = reNewPassword
        param["captcha"] = captcha

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }
    
    func checkUserNew(phoneNumber: String) -> DataRequest {
        let urlString = requestURL.appending("default/check-new-user")
        var param = commonParam()
        param["phoneNumber"] = phoneNumber
        
        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }

    func mapAccount(msidn: String, otp: String) -> DataRequest {
        let urlString = requestURL.appending("account/map-account")
        var param = commonParam()
        param["msisdn"] = msidn.phoneNumber()
        param["otp"] = otp

        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func getUserProfile() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-user-profile")
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    //mark: -- Get Content
    func getHomeFilm() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("film/get-home-film-v2")
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
     
    func getSeriesFilm() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("film/series-film")
        return alamoFireManager.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: self.headers)
    }
    func getOddFilm() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("film/odd-film")
        return alamoFireManager.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: self.headers)
    }
    func getChargesFilm() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("collection/get-by-position?p=2")
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func getMoreContent(id: String, offset: Int, limit: Int) -> DataRequest {
        let urlString = requestURL.appending("default/get-more-content")
        var param = commonParam()
        param["id"] = id
        param["offset"] = String(offset)
        param["limit"] = String(limit)

        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getCollectionMoreContent(id: String, offset: Int, limit: Int, isSeries: Bool?) -> DataRequest {
        var urlString = requestURL.appending("collection/get-detail")
        if isSeries != nil {
            if isSeries! {
                urlString = requestURL.appending("collection/get-series-detail")
            } else {
                urlString = requestURL.appending("collection/get-odd-film-detail")
            }
        }
        
        var param = commonParam()
        param["id"] = id
        param["offset"] = String(offset)
        param["limit"] = String(limit)
        
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func getDetail(playListID: String, videoID: String?, profileID: String? , noti : Bool ,sendNoti : Bool) -> DataRequest {
        let urlString = requestURL.appending("playlist/get-detail")
        var param = commonParam()
        param["id"] = playListID
        if let string = videoID {
            param["video_id"] = string
        }
        if let string = profileID {
            param["profile_id"] = string
        }
        if noti {
            param["view"] = "1"
        }else{
            param["view"] = "0"
        }
        if sendNoti {
        param["noti"] = "ios"
        }
        
        param["network_device_id"] = ViewRightWeb.getDeviceIdentifier()
        param["device_type"] = "WEB_IPHONE"
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getDetailCollection(playListID: String,offset: Int,limit: Int) -> DataRequest {
        let urlString = requestURL.appending("collection/get-detail")
        var param = commonParam()
        param["id"] = playListID
        param["offset"] = String(offset)
        param["limit"] = String(limit)
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
        
    }
    
    func getPlaylistStream(playListID: String, videoID: String?, profileID: String?) -> DataRequest {
        let urlString = requestURL.appending("playlist/get-playlist-stream")
        var param = commonParam()
        param["playlist_id"] = playListID
        if let string = videoID {
            param["id"] = string
        }
        if let string = profileID {
            param["profile_id"] = string
        }

        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func toggleLikePlaylist(id: String) -> DataRequest {
        let urlString = requestURL.appending("playlist/toggle-like-playlist")
        var param = commonParam()
        param["id"] = id

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }

    func registerService(packageID: String, contentType: String, contentName: String) -> DataRequest {
        let urlString = requestURL.appending("account/register-service")
        var param = commonParam()
        param["package_id"] = packageID
        param["content_type"] = contentType
        param["content_name"] = contentName

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }

    func unRegisterService(package: PackageModel) -> DataRequest {
        let urlString = requestURL.appending("account/unregister-service")
        var param = commonParam()
        param["package_id"] = package.packageId

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }

    func getSetting() -> DataRequest {
        let urlString = requestURL.appending("default/get-setting")
        let param = commonParam()
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: nil)
    }
    
    func mpsDetectLink(_ url: String) -> DataRequest {
        let param = commonParam()
        return alamoFireManager.request(url,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: nil)
    }

    func feedback(id: String, content: String, itemId: String, type: String) -> DataRequest {
        let urlString = requestURL.appending("default/feed-back")
        var param = commonParam()
        param["id"] = id
        param["content"] = content
        param["item_id"] = itemId
        param["type"] = type

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: nil)

    }

    func searchSuggestion(query: String) -> DataRequest {
        let urlString = requestURL.appending("default/search-suggestion")
        var param = commonParam()
        param["query"] = query

        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)

    }

    func search(query: String) -> DataRequest {
        let urlString = requestURL.appending("default/search")
        var param = commonParam()
        param["query"] = query

        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)

    }

    func markWatchTime(id: String, time: Float64, type: ContentType) -> DataRequest {
        let urlString = requestURL.appending("account/watch-time")
        var param = commonParam()
        param["id"] = id
        param["time"] = String(time)
        param["type"] = type.rawValue

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }

    func registerClientId(id: String) -> DataRequest {
        let urlString = requestURL.appending("account/register-client-id")
        var param = commonParam()
        param["client_id"] = id
        param["type"] = "2"

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }

    func getListPackage() -> DataRequest {
        let urlString = requestURL.appending("default/list-package")
        let param = commonParam()
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    func getGamerUrl() -> DataRequest {
        let urlString = requestURL.appending("default/get-game")
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    func getListNotification() -> DataRequest {
        let urlString = requestURL.appending("default/get-list-notify")
        let param = commonParam()
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    func buy(id: String, type: String) -> DataRequest { //type: VOD, PLAYLIST
        let urlString = requestURL.appending("account/buy")
        var param = commonParam()
        param["item_id"] = id
        param["type"] = type

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }
    func getRelateFilm(id:String ) -> DataRequest{
        let url = requestURL.appending("playlist/get-film-detail")
        var param = commonParam()
        param["id"] = id
        return alamoFireManager.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: self.headers)
    }
    func removeFromHistory(_ id: String) -> DataRequest {
        let urlString = requestURL.appending("account/delete-history")
        var param = commonParam()
        param["id"] = id

        return alamoFireManager.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func registerPromotionApp() -> DataRequest {
        let urlString = requestURL.appending("account/register-promotion-app")
        let param = commonParam()
        return alamoFireManager.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func KPITraceRequest(_ model: KPIModel) -> DataRequest {
        var commonparam = commonParam()
        var param = model.toDictionary()
        for key in commonparam.keys {
            param[key] = commonparam[key]
        }
        print(" time waching \(model.watchingDuration)")
        print(" token tracing \(model.token)")
        let urlString = requestURL.appending("video/trace-kpi")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getVideoTrailer(_ ItemId: String) -> DataRequest {
        let urlString = requestURL.appending("playlist/get-link-trailer")
        var param = commonParam()
        param["id"] = ItemId
        param["device_type"] = "WEB_IPHONE"
        return alamoFireManager.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
        
    }
}
