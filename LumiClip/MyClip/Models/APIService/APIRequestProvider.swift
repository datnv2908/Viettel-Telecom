//
//  APIRequestProvider.swift
//  MyClip
//
//  Created by Huy Nguyen on 1/4/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import DateToolsSwift
import SwiftyJSON

let kClientVersionHeaderField = "os_version_code"
let kClientOSHeaderField = "os_type"
let kDeviceId = "device_id"
   
/*Beta*/
//let baseURL = "http://171.255.197.123/api_v2.php/"

/*Local in Vas*/
//let baseURL = "http://192.168.146.252:8586/"

/*Live*/
//let baseURL = "http://beta.myclip.viettel.vn/api.php/"
//let baseURL = "http://myclip.vn/api_v2.php/"
//let baseURL = "http://api.myclip.la/"
let baseURL = "http://api.clip.lumitel.bi/"
//let baseURL = "http://125.212.229.33:11810/"
// 252 MeuClip
//let baseURL = "http://192.168.146.252:9249/"
//let baseURL = "http://api.myclip.la/"
let apiVersion = "v2"

/*
 *  APIRequestProvider takes responsible for build and provide request for service objects
 *  default header for request will be defined here
 */
class `APIRequestProvider`: NSObject {
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
            var authorization: String = ""
            if DataManager.isLoggedIn() {
                if let token = DataManager.getCurrentMemberModel()?.accessToken {
                    authorization = "Bearer " + token
                }
            }
            var headers: HTTPHeaders = [
                "Accept": "application/json, text/html",
                "Content-Type": "application/x-www-form-urlencoded",
                "User-Agent": ""
            ]
            if !authorization.isEmpty {
                headers["Authorization"] = authorization
            }
            var currentLanguage = "pt"
            currentLanguage = getShortLanguage()            
            headers["language"] = currentLanguage == "pt" ? "mz" : currentLanguage
            return headers
        }
    }

    func commonParam() -> [String: String] {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceOS = "ios"
        var param = [String: String]()
    
        param[kClientVersionHeaderField] = version
        param[kClientOSHeaderField] = deviceOS
        param[kDeviceId] = (UIDevice.current.identifierForVendor?.uuidString)!
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
        configuration.timeoutIntervalForRequest = 3600
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }

    //mark: -- Authorization Requests
    
    func authorize(type: LoginType,
                   username: String?,
                   password: String?,
                   captcha: String?,
                   accessToken: String?) -> DataRequest {
        var header = self.headers
        let imei = UIDevice.current.identifierForVendor?.uuidString
        header["Authorization"] = "Bearer " + imei!
        let urlString = requestURL.appending("auth/authorize")
        var param = commonParam()
        param["grant_type"] = type.grantType()
        if let value = username {
            param["username"] = value
        }
        if let value = password {
            param["password"] = value
        }
        if let value = captcha {
            param["captcha"] = value
        }
        if let value = accessToken {
            param["access_token"] = value
        }
        param["social_id"] = type.socialId()
        if let model = DataManager.getCurrentMemberModel() {
            if type == .refreshToken {
                param["refresh_token"] = model.refreshToken
            }
        }
        let request = Alamofire.request(urlString,
                                               method: .post,
                                               parameters: param,
                                               encoding: URLEncoding.default,
                                               headers: header)
        return request
    }

    func registerDeviceTokenRequest(token: String) -> DataRequest {
        let urlString = requestURL.appending("account/register-client-id")
        var param = commonParam()
        param["client_id"] = token
        param["type"] = "2"
        let request = Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
        return request
    }

    func getCaptcha() -> DataRequest {
        var header = self.headers
        if let model = DataManager.getCurrentMemberModel() {
            header["Authorization"] = "Bearer " + model.accessToken
        } else {
            let imei = UIDevice.current.identifierForVendor?.uuidString
            header["Authorization"] = "Bearer " + imei!
        }
        let urlString = requestURL.appending("auth/get-captcha")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: nil,
                                        encoding: URLEncoding.default,
                                        headers: header)
    }

    func logoutRequest(token: String) -> DataRequest {
        let urlString = requestURL.appending("auth/logout")
        var param = commonParam()
        param["refresh_token"] = token

        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }

    func mapAccount(msidn: String, otp: String) -> DataRequest {
        let urlString = requestURL.appending("account/map-account")
        var param = commonParam()
        param["msisdn"] = msidn.phoneNumber()
        param["otp"] = otp

        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getOTP(msidn: String) -> DataRequest {
        let urlString = requestURL.appending("auth/push-otp")
        var param = commonParam()
        param["msisdn"] = msidn.phoneNumber()
        
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.httpBody,
                                        headers: self.headers)
    }
    
    func getUserProfile() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-user-profile")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }

    func updateChannelImage(_ image: UIImage, isUpdateAvatar: Bool, completion: @escaping (Result<Any>) -> Void) {
        let urlString = requestURL.appending("channel/update")
        var param = commonParam()
        if let model = DataManager.getCurrentMemberModel() {
            param["name"] = model.fullName
            param["description"] = model.desc
        }
        let dataImage = image.jpegData(compressionQuality: 0.5)
//        print(dataImage?.fileSize())
        Alamofire.upload(multipartFormData: { (formData) in
            if isUpdateAvatar {
                formData.append(dataImage!,
                                withName: "file_avatar",
                                fileName: "avatar.png",
                                mimeType: "image/png")
            } else {
                formData.append(dataImage!,
                                withName: "file_banner",
                                fileName: "cover.png",
                                mimeType: "image/png")
            }
            for (key, value) in param {
                formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                                withName: key)
            }
        }, to: urlString,
           method: .post,
           headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let error = response.error {
                        completion(Result.failure(error))
                    } else {
                        let json = JSON(response.result.value as Any)
                        let message         = json["message"].stringValue
                        let responseCode    = json["responseCode"].intValue
                        print(json)
                        if responseCode == APIErrorCode.success.rawValue {
                            let model = DataManager.getCurrentMemberModel()
                            model?.avatarImage = json["data"]["channel"]["avatarImage"].stringValue
                            model?.coverImage = json["data"]["channel"]["coverImage"].stringValue
                            model?.fullName = json["data"]["channel"]["name"].stringValue
                            model?.desc = json["data"]["channel"]["description"].stringValue
                            DataManager.saveMemberModel(model!)
                            completion(Result.success(true))
                        } else {
                            let error = NSError.errorWith(code: responseCode, message: message)
                            completion(Result.failure(error))
                        }
                    }
                }
                break
            case .failure(let encodingError):
                completion(Result.failure(encodingError))
                break
            }
        }
    }
    
    func uploadVideo(_ videoUrl: URL,
                     status: Int,
                     title: String,
                     desc: String,
                     sessionId: String,
                     image: UIImage,channelId : String,categoryID : String , completion: @escaping (Result<Any>) -> Void) {
        let urlString = requestURL.appending("account/upload-file")
        var param = commonParam()
        param["mode"] = String(status)
        param["title"] = title
        param["description"] = desc
        param["session_id"] = sessionId
        param["channel_id"] = channelId
        param["category_id"] = categoryID
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        
        alamoFireManager.upload(multipartFormData: { (formData) in
            do {
                DLog("")
                let videoData = try Data(contentsOf: videoUrl)
                DLog("file size: \(videoData.fileSize())")
                formData.append(videoData,
                                withName: "file",
                                fileName: "video.mp4",
                                mimeType: "video/mp4")
            } catch {
                print(error.localizedDescription)
            }
            if let data = imageData {
                formData.append(data,
                                withName: "thumbnail",
                                fileName: "file.png",
                                mimeType: "image/png")
            }
            for (key, value) in param {
                formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                                withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: urlString, method: .post, headers: self.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                completion(Result.success(upload))
            case .failure(let encodingError):
                completion(Result.failure(encodingError))
            }
        }
    }
    
    func settingsNotificationRequest() -> DataRequest {
        let urlString = requestURL.appending("account/toggle-notification")
        let param = commonParam()
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
   func sentThemeForApp(isLight : Bool) -> DataRequest {
       let urlString = requestURL.appending("auth/theme-msisdn")
        var param = commonParam()
       if isLight {
         param["theme"] = "1"
       }else{
         param["theme"] = "0"
       }
      
       return Alamofire.request(urlString,
                                       method: .post,
                                       parameters: param,
                                       encoding: URLEncoding.queryString,
                                       headers: self.headers)
   }
    func getNotifications() -> DataRequest {
        let urlString = requestURL.appending("account/get-notification")
        let param = commonParam()
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func markNotification(_ id: String) -> DataRequest {
        let urlString = requestURL.appending("account/mark-notification")
        var param = commonParam()
        param["id"] = id
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func kpiUploadStart(_ sessionId: String) -> DataRequest {
        let urlString = requestURL.appending("account/kpi-upload-start")
        var param = commonParam()
        param["session_id"] = sessionId
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    //MARK: -- Video requests
    func getHomeContent() -> DataRequest {
        var param = commonParam()
        let urlString = requestURL.appending("default/get-home-v2")
        print("home video", Alamofire.request(urlString,
                                             method: .get,
                                             parameters: param,
                                             encoding: URLEncoding.queryString,
                                             headers: self.headers))
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    func getMoreContent(_ objectId: String, pager: Pager) -> DataRequest {
        var param = commonParam()
        param["id"] = objectId
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/get-more-content")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func register(msisdn: String,
                  fullname: String ,
                  otp: String) -> DataRequest {
        var param = commonParam()
        param["msisdn"] = msisdn
        param["fullname"] = fullname
        param["otp"] = otp
        let urlString = requestURL.appending("auth/sign-up-by-msisdn")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
   func alowCommentForVideo(idVideo : String , enableComment : Bool) -> DataRequest {
       var param = commonParam()
      if enableComment {
         param["status"] = "1"
      }else{
         param["status"] = "0"
      }
       param["id"] = idVideo
       let urlString = requestURL.appending("default/trigger-comment")
       return Alamofire.request(urlString,
                                       method: .post,
                                       parameters: param,
                                       encoding: URLEncoding.default,
                                       headers: self.headers)
   }
    func changePassword(oldPassword: String,
                        newPassword: String,
                        repeatPassword: String,
                        captcha: String) -> DataRequest {
        var param = commonParam()
        param["password"] = oldPassword
        param["new_password"] = newPassword
        param["repeat_password"] = repeatPassword
        param["captcha"] = captcha
        let urlString = requestURL.appending("auth/change-password")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func getVideoDetail(id: String,
                        playlistId: String?,
                        acceptLostData:Bool) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        if let value = playlistId {
            param["playlist_id"] = value
            param["playlist_type"] = "USER"
        }
        param["accept_loss_data"] = acceptLostData ? "1" : "0"
        let urlString = requestURL.appending("video/get-detail")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func toggleLikeVideo(id: String, status: LikeStatus) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["status"] = "\(status.rawValue)"
        let urlString = requestURL.appending("video/toggle-like-video")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }

    func deleteComment(id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("default/delete-comment")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func deleteVideo(id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("default/delete-video")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func updateComment(id: String, comment: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["comment"] = comment
        let urlString = requestURL.appending("default/update-comment")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getListComment(type: ContentType, contentId: String, pager: Pager) -> DataRequest {
        var param = commonParam()
        param["type"] = type.rawValue
        param["content_id"] = contentId
        param["limit"] = String(pager.limit)
        param["offset"] = String(pager.offset)
        let urlString = requestURL.appending("default/get-list-comment")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
   func postComment(type: String,
                     contentId: String,
                    parent_id: String,
                     comment: String) -> DataRequest {
        var param = commonParam()
        param["type"] = type
      param["parent_id"] = parent_id
        param["content_id"] = contentId
        param["comment"] = comment
        let urlString = requestURL.appending("default/post-comment")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
   
   func manageComment(
                     contentId: String,
      comment: String , parent_id : String?) -> DataRequest {
        var param = commonParam()
        param["content_id"] = contentId
        param["comment"] = comment
        param["parent_id"] = parent_id
        let urlString = requestURL.appending("default/post-comment")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func toggleLikeComment(type: String,
                            contentId: String,
                            commentId: String) -> DataRequest {
      var param = commonParam()
      param["like"] = "1"
      param["comment_id"] = commentId
      param["content_id"] = contentId
      let urlString = requestURL.appending("default/like-dislike-comment")
      return Alamofire.request(urlString,
                               method: .post,
                               parameters: param,
                               encoding: URLEncoding.default,
                               headers: self.headers)
    }
   
   func toggleLikeDisLikeComment(like: Bool,
                                commentId: String,
                                 contentId: String) -> DataRequest {
      var param = commonParam()
      if like {
         param["like"] = "1"
      }else{
         param["like"] = "2"
      }
      param["comment_id"] = commentId
      param["content_id"] = contentId
      let urlString = requestURL.appending("default/like-dislike-comment")
      return Alamofire.request(urlString,
                               method: .post,
                               parameters: param,
                               encoding: URLEncoding.default,
                               headers: self.headers)
   }
   
    func getFavouriteContent() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-favourite-content")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getHistoryContent() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-history-content")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func searchSuggetion(query: String) -> DataRequest {
        var param = commonParam()
        param["query"] = query
        let pager = Pager(offset: Constants.kFirstOffset, limit: Constants.kDefaultLimit)
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/search-suggestion"/*"default/search-suggestion-v2"*/)
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
   func getDetailChannelAndUserEdit(id: String,type :  typeEditChannel) -> DataRequest {
       var param = commonParam()
       param["id"] = id
       param["type"] = type.rawValue
       let urlString = requestURL.appending("channel/get-detail-edit")
       return Alamofire.request(urlString,
                                method: .get,
                                parameters: param,
                                encoding: URLEncoding.queryString,
                                headers: self.headers)
   }
    func search(query: String) -> DataRequest {
        var param = commonParam()
        param["query"] = query
        let pager = Pager(offset: Constants.kFirstOffset, limit: Constants.kDefaultLimit)
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/search"/*"default/search"*/)
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getSearchMore(query: String, pager: Pager) -> DataRequest {
        var param = commonParam()
        param["query"] = query
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/search-suggestion-v2")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func getSearchSuggetionMore(query: String, pager: Pager) -> DataRequest {
        var param = commonParam()
        param["query"] = query
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/search-suggestion-v2")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func watchTime(id: String, time: Double, type: ContentType) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["time"] = "\(time)"
        param["type"] = type.rawValue
        let urlString = requestURL.appending("account/watch-time")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func getPackagesRequest() -> DataRequest {
        let urlString = requestURL.appending("default/list-package")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: nil,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func registerPackage(_ packageId: String, contentId: String) -> DataRequest {
        var param = [String: String]()
        param["package_id"] = packageId
        param["content_id"] = contentId
        let urlString = requestURL.appending("account/register-service")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func unregisterPackage(_ packageId: String) -> DataRequest {
        var param = [String: String]()
        param["package_id"] = packageId
        let urlString = requestURL.appending("account/unregister-service")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func buyRetail(item id: String, type: ContentType) -> DataRequest {
        var param = [String: String]()
        param["item_id"] = id
        param["type"] = type.rawValue
        let urlString = requestURL.appending("account/buy")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func getDetailPackage(id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("account/detail-package")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getHome() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("default/get-home")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getRelation(id: String, playlistId: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["playlist_id"] = playlistId
        let urlString = requestURL.appending("video/get-relation")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getFollowChannel(limit: Int, offset: Int, includeHot: Int) -> DataRequest {
        var param = commonParam()
        param["limit"] = "\(limit)"
        param["offset"] = "\(offset)"
        param["include_hot"] = String(includeHot)
        let urlString = requestURL.appending("account/get-follow-channel")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getHotChannel() -> DataRequest {
        var param = commonParam()
        param["id"] = "list_channel_follow_with_hot"
        let urlString = requestURL.appending("default/get-more-content")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func getHotCategory() -> DataRequest {
        var param = commonParam()
        param["id"] = "category_parent"
        param["limit"] = "\(30)"
        param["offset"] = "\(0)"
        let urlString = requestURL.appending("default/get-more-content")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func getFollowVideo(limit: Int, offset: Int) -> DataRequest {
        var param = commonParam()
        param["limit"] = "\(limit)"
        param["offset"] = "\(offset)"
        let urlString = requestURL.appending("video/get-follow-video")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func deleteHistoryView(ids: String) -> DataRequest {
        var param = commonParam()
        param["ids"] = ids
        let urlString = requestURL.appending("account/delete-history-view")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func toggleWatchLater(id: String, status: Int) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["status"] = "\(status)"
        let urlString = requestURL.appending("video/toggle-watch-later")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func toggleAddVideo(playlistId: String, videoId: String, status: Int) -> DataRequest {
        var param = commonParam()
        param["id"] = playlistId
        param["video_id"] = videoId
        param["status"] = "\(status)"
        let urlString = requestURL.appending("playlist/toggle-add-video")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func createPlaylist(name: String, description: String) -> DataRequest {
        var param = commonParam()
        param["name"] = name
        param["description"] = description
        let urlString = requestURL.appending("playlist/create")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func updatePlaylist(id: String,
                        name: String,
                        description: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["name"] = name
        param["description"] = description
        let urlString = requestURL.appending("playlist/update")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func deletePlaylist(id: String) -> DataRequest {
        var param = commonParam()
        let urlString = requestURL.appending("playlist/delete")
        param["id"] = id
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func getAllPlaylist() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-my-playlists")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getPublicPlaylist(categoryId: String, pager: Pager) -> DataRequest {
        var param = commonParam()
        param["id"] = categoryId
        param["limit"] = "\(pager.limit)"
        param["offset"] = "\(pager.offset)"
        let urlString = requestURL.appending("default/get-more-content")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func updateChannel(name: String,
                       description: String) -> DataRequest {
        var param = commonParam()
        param["name"] = name
        param["description"] = description
        let urlString = requestURL.appending("channel/update")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    func getChannelInfor(_ id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("channel/get-info-channel")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func getDetailChannel(id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("channel/get-detail")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getRelatedOfChannel(id: String) -> DataRequest {
        var param = commonParam()
        param["user_id"] = id
        let urlString = requestURL.appending("channel/get-channel-related")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func addRelatedOfChannel(id: String) -> DataRequest {
        var param = commonParam()
        param["channel_related_id"] = id
        let urlString = requestURL.appending("channel/add-channel-related")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func removeRelatedOfChannel(id: String) -> DataRequest {
        var param = commonParam()
        param["channel_related_id"] = id
        let urlString = requestURL.appending("channel/remove-channel-related")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getHotChannelByAcc(id: String) -> DataRequest {
        var param = commonParam()
        param["user_id"] = id
        let urlString = requestURL.appending("channel/get-channel-by-category")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func searchChannelRelatedSuggestion(query: String) -> DataRequest {
        var param = commonParam()
        param["query"] = query
        let urlString = requestURL.appending("default/search-channel-related-suggestion")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func followChannel(id: String,
                       status: Int,
                       notificationType: Int) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        param["status"] = String(status)
        param["notification_type"] = String(notificationType)
        let urlString = requestURL.appending("account/follow-channel")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    
    func getSuggestionsChannel() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("channel/get-channel-recommend")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.queryString,
                                 headers: self.headers)
    }
    
    func markNotification(id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("account/mark-notification")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getKeywordSearch() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("default/get-keywords")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func getAccountSettings() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("default/get-setting")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func sendFeedBack(error id: String, content: String, objectId: String, type: ContentType) -> DataRequest {
        var param = [String: String]()
        param["id"] = id
        param["content"] = content
        param["item_id"] = objectId
        param["type"] = type.rawValue
        let urlString = requestURL.appending("default/feed-back")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func getFollowContent() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/get-follow-content")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.queryString,
                                        headers: self.headers)
    }
    
    func followMultiChannel(ids: String, status: Int, notificationType: Int) -> DataRequest {
        var param = commonParam()
        param["ids"] = ids
        param["status"] = String(status)
        let urlString = requestURL.appending("account/follow-multi-channel")
        return Alamofire.request(urlString,
                                        method: .post,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func KpiInitRequest(video id: String, url: String) -> DataRequest {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceOS = "ios"
        var param = [String: String]()
        param["os_version"] = version
        param["os_type"] = deviceOS
        param["video_id"] = id
        param["play_url"] = url
        let urlString = requestURL.appending("kpi/init")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }
    
    func KPITraceRequest(_ model: KPIModel) -> DataRequest {
        let param = model.toDictionary()
        let urlString = requestURL.appending("kpi/trace")
        return Alamofire.request(urlString,
                                        method: .get,
                                        parameters: param,
                                        encoding: URLEncoding.default,
                                        headers: self.headers)
    }

    func getDownloadLink(_ id: String) -> DataRequest {
        var param = commonParam()
        param["id"] = id
        let urlString = requestURL.appending("video/download")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func registerPromotionApp() -> DataRequest {
        let param = commonParam()
        let urlString = requestURL.appending("account/register-promotion-app")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    // Event
    func getConfigs() -> DataRequest {
        let urlString = requestURL.appending("event/load-config")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    func getPoints() -> DataRequest {
        let urlString = requestURL.appending("event/get-points")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getMonthAward(monthReport: String, page: Int) -> DataRequest {
        var param = commonParam()
        param["month_report"] = monthReport
        param["page"] = "\(page)"
        let urlString = requestURL.appending("event/get-report-by-month")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getWeekAward(fromDate: String, toDate: String, page: Int) -> DataRequest {
        var param = commonParam()
        param["from_date"] = fromDate
        param["to_date"] =  toDate
        param["page"] = "\(page)"
        let urlString = requestURL.appending("event/get-report-by-range")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getMonthEarning(limit: Int) -> DataRequest {
        var param = commonParam()
        param["limit"] = "\(limit)"
        let urlString = requestURL.appending("account/report-user-upload")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getMonthEarningMore(limit: Int, offset: Int) -> DataRequest {
        var param = commonParam()
        param["limit"] = "\(limit)"
        param["offset"] = "\(offset)"
        let urlString = requestURL.appending("account/report-user-upload-history")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getAccountInfoUpload() -> DataRequest {
        let urlString = requestURL.appending("contract/load-infomation")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getContractCondition() -> DataRequest {
        let urlString = requestURL.appending("contract/condition")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func getAccountOTP(msisdn: String) -> DataRequest {
        var param = commonParam()
        param["msisdn"] = msisdn
        let urlString = requestURL.appending("contract/get-otp")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func updateAccountInformationUpload(rqAccountName: String, rqAccountEmail:String, rqAccountIDNo:String,
                                        rqAccountIDAddress:String, rqAccountIDDate:String, rqIDFront: UIImage, rqIDBack: UIImage,rqPhoneNumber:String, rqOtp:String, completion: @escaping (Result<Any>) -> Void) {
        let urlString = requestURL.appending("contract/personal-infomation")
        var param = commonParam()
        
        param["name"] = rqAccountName
        param["email"] = rqAccountEmail
        param["id_card_number"] = rqAccountIDNo
        param["id_card_created_by"] = rqAccountIDAddress
        param["id_card_created_at"] = rqAccountIDDate
        param["msisdn"] = rqPhoneNumber
        param["otp"] = rqOtp
        param["infoType"] = "ACCOUNT_INFOMATION"
        
        let imgIDFrontSide = rqIDFront.jpegData(compressionQuality: 0.5)
        let imgIDBackSide = rqIDBack.jpegData(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imgIDFrontSide!,
                            withName: "id_card_image_frontside",
                            fileName: "id_card_image_frontside.png",
                            mimeType: "image/png")
            formData.append(imgIDBackSide!,
                            withName: "id_card_image_backside",
                            fileName: "id_card_image_backside.png",
                            mimeType: "image/png")
            for (key, value) in param {
                formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                                withName: key)
            }
        }, to: urlString,
           method: .post,
           headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let error = response.error {
                        completion(Result.failure(error))
                    } else {
                        let json = JSON(response.result.value as Any)
                        let message         = json["message"].stringValue
                        let responseCode    = json["responseCode"].intValue
                        print(json)
                        if responseCode == APIErrorCode.success.rawValue {
                            completion(Result.success(true))
                        } else {
                            let error = NSError.errorWith(code: responseCode, message: message)
                            completion(Result.failure(error))
                        }
                    }
                }
                break
            case .failure(let encodingError):
                completion(Result.failure(encodingError))
                break
            }
        }
    }
    
    func updateBankPaymentInfor(accountNumber: String, bankName: String, bankDepartment: String, address: String, taxCode: String) -> DataRequest {
        var param = [String: String]()
    
        param["payment_type"] = "BANK_ACCOUNT"
        param["tax_code"] = taxCode
        param["account_number"] = accountNumber
        param["bank_name"] = bankName
        param["bank_department"] = bankDepartment
        param["address"] = address
        
        let urlString = requestURL.appending("contract/account")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func updateVTPPaymentInfor(phoneNumber: String, address: String, taxCode: String) -> DataRequest {
        var param = [String: String]()
        
        param["payment_type"] = "CASH"
        param["tax_code"] = taxCode
        param["payment_mobile_number"] = phoneNumber
        param["address"] = address
        
        let urlString = requestURL.appending("contract/account")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func confirmContract(_ status: Int) -> DataRequest {
        var param = [String: String]()
        if(status == 0){
            param["action-contract"] = "submit-contract"
        }else if(status == 1){
            param["action-contract"] = "modify-contract"
        }else if(status == 3){
            param["action-contract"] = "change-failure-contract"
        }
        let urlString = requestURL.appending("contract/contract")
        return Alamofire.request(urlString,
                                 method: .post,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
    func ReportBySessionRequest(_ totalError: Int,_ totalSucess: Int,_ avgTime: Double) -> DataRequest {
        var param = commonParam()
        param["total_error"] = "\(totalError)"
        param["total_success"] =  "\(totalSucess)"
        param["response_time_avg"] = "\(avgTime)"
        param["client_id"] = (UIDevice.current.identifierForVendor?.uuidString)!
        let urlString = requestURL.appending("kpi/report-by-session")
        return Alamofire.request(urlString,
                                 method: .get,
                                 parameters: param,
                                 encoding: URLEncoding.default,
                                 headers: self.headers)
    }
    
   func getListComment(status : String) -> DataRequest{
      var param = commonParam()
      param["status"] = status
      
      let urlString = requestURL.appending("default/get-list-video-comment")
      return Alamofire.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
   }
   func getListCommentWithID(status : String,idVideo : String,idComment : String) -> DataRequest{
      var param = commonParam()
      param["status"] = status
      param["videoId"] = idVideo
      param["commentId"] = idComment
      let urlString = requestURL.appending("default/get-list-video-comment")
      return Alamofire.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
   }
   func sendApproveComment(isApprove : Bool , id: String) -> DataRequest{
      var param = commonParam()
      if isApprove  {
         param["status"] = "\(1)"
      }  else  {
         param["status"] = "\(2)"
      }
      param["id"] = id
      let urlString = requestURL.appending("default/approved-comment")
      return Alamofire.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
   }
   func sendLikeAndDislike( isLike : Bool, idComment : String , idVideo : String) -> DataRequest {
      var param = commonParam()
      param["like"] = "\(isLike ? 1 : 2)"
      param["comment_id"] = idComment
      param["content_id"] = idVideo
      let urlString = requestURL.appending("default/like-dislike-comment")
      return Alamofire.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
   }
   func getMuttilChannel(id: String, active: getAllChannels) -> DataRequest {
       var param = commonParam()
       param["id"] = id
       param["active"] = active.rawValue
       let urlString = requestURL.appending("channel/get-user-detail")
       return Alamofire.request(urlString,
                                method: .get,
                                parameters: param,
                                encoding: URLEncoding.queryString,
                                headers: self.headers)
   }
    func sendVideoFeedBack(videoId: String, feedbackContent:String,feedbackFile: UIImage?, completion: @escaping (Result<Any>) -> Void) {
        let urlString = requestURL.appending("video/feedback-upload-video")
        var param = commonParam()
        
        param["id"] = videoId
        param["feedback_content"] = feedbackContent
        
        Alamofire.upload(multipartFormData: { (formData) in
            if(feedbackFile != nil){
                let imgFeedbackFile = feedbackFile!.jpegData(compressionQuality: 0.5)
                formData.append(imgFeedbackFile!,
                                withName: "feedback_file",
                                fileName: "feedback_file.png",
                                mimeType: "image/png")
            }
            for (key, value) in param {
                formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                                withName: key)
            }
        }, to: urlString,
           method: .post,
           headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let error = response.error {
                        completion(Result.failure(error))
                    } else {
                        let json = JSON(response.result.value as Any)
                        let message         = json["message"].stringValue
                        let responseCode    = json["responseCode"].intValue
                        print(json)
                        if responseCode == APIErrorCode.success.rawValue {
                            completion(Result.success(true))
                        } else {
                            let error = NSError.errorWith(code: responseCode, message: message)
                            completion(Result.failure(error))
                        }
                    }
                }
                break
            case .failure(let encodingError):
                completion(Result.failure(encodingError))
                break
            }
        }
    }
   func updateProfile(name: String , desc : String, _ avatarImage: UIImage? ,coverImage : UIImage? ,id : String, completion: @escaping (Result<Any>) -> Void) {
       let urlString = requestURL.appending("channel/user-update")
       var param = commonParam()
       param["id"] = id
       param["name"] = name
       param["description"] = desc
       let avarImg = avatarImage?.jpegData(compressionQuality: 0.5)
       let  coverImg = coverImage?.jpegData(compressionQuality: 0.5)
       
       //        print(dataImage?.fileSize())
       Alamofire.upload(multipartFormData: { (formData) in
           if let avatarImg = avarImg {
               formData.append(avatarImg ,
                               withName: "file_avatar",
                               fileName: "avatar.png",
                               mimeType: "image/png")
           }
           if let coverImage = coverImg{
               formData.append(coverImg!,
                               withName: "file_banner",
                               fileName: "cover.png",
                               mimeType: "image/png")
           }
           for (key, value) in param {
               formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                               withName: key)
           }
       }, to: urlString,
          method: .post,
          headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
           switch result {
           case .success(let upload, _, _):
               upload.responseJSON { response in
                   if let error = response.error {
                       completion(Result.failure(error))
                   } else {
                       let json = JSON(response.result.value as Any)
                       let message         = json["message"].stringValue
                       let responseCode    = json["responseCode"].intValue
                       print(json)
                       if responseCode == APIErrorCode.success.rawValue {
                           let model = DataManager.getCurrentMemberModel()
                           model?.avatarImage = json["data"]["user"]["avatarImage"].stringValue
                           model?.coverImage = json["data"]["user"]["coverImage"].stringValue
                           model?.fullName = json["data"]["user"]["name"].stringValue
                           model?.desc = json["data"]["user"]["description"].stringValue
                           model?.status = json["data"]["user"]["status"].intValue
                           
//                           DataManager.saveMemberModel(model!)
                           completion(Result.success(true))
                       } else {
                           let error = NSError.errorWith(code: responseCode, message: message)
                           completion(Result.failure(error))
                       }
                   }
               }
               break
           case .failure(let encodingError):
               completion(Result.failure(encodingError))
               break
           }
       }
   }

   func CreateChannel(_ avatarImage: UIImage?,_ coverImage: UIImage?,nameChannel : String,descChannel: String, completion: @escaping (Result<Any>) -> Void) {
           let urlString = requestURL.appending("channel/insert")
           var param = commonParam()
               param["name"] = nameChannel
               param["description"] = descChannel
       let avatarImg = avatarImage?.jpegData(compressionQuality: 0.5)
       let coverImg = coverImage?.jpegData(compressionQuality: 0.5)
       //        print(dataImage?.fileSize())
       Alamofire.upload(multipartFormData: { (formData) in
           if let avatar  = avatarImg , let cover = coverImg {
               formData.append(avatarImg!,
                               withName: "file_avatar",
                               fileName: "avatar.png",
                               mimeType: "image/png")
               formData.append(coverImg!,
                               withName: "file_banner",
                               fileName: "cover.png",
                               mimeType: "image/png")
           }
           for (key, value) in param {
               formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                               withName: key)
           }
           
       }, to: urlString,
              method: .post,
              headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
               switch result {
               case .success(let upload, _, _):
                   upload.responseJSON { response in
                       if let error = response.error {
                           completion(Result.failure(error))
                       } else {
                           let json = JSON(response.result.value as Any)
                           let message         = json["message"].stringValue
                           let responseCode    = json["responseCode"].intValue
                           print(json)
                           if responseCode == APIErrorCode.success.rawValue {
//                                let model = DataManager.getCurrentMemberModel()
//                                model?.avatarImage = json["data"]["channel"]["avatarImage"].stringValue
//                                model?.coverImage = json["data"]["channel"]["coverImage"].stringValue
//                                model?.fullName = json["data"]["channel"]["name"].stringValue
//                                model?.descriptionChannel = json["data"]["channel"]["description"].stringValue
//                                DataManager.saveMemberModel(model!)
                               completion(Result.success(true))
                           } else {
                               let error = NSError.errorWith(code: responseCode, message: message)
                               completion(Result.failure(error))
                           }
                       }
                   }
                   break
               case .failure(let encodingError):
                   completion(Result.failure(encodingError))
                   break
               }
           }
       }
   func updateChannel(nameChannel: String , descChannel : String, _ avatarImage: UIImage? ,coverImage : UIImage? ,id : String, completion: @escaping (Result<Any>) -> Void) {
       let urlString = requestURL.appending("channel/update")
       var param = commonParam()
       param["id"] = id
       param["name"] = nameChannel
       param["description"] = descChannel
       let avarImg = avatarImage?.jpegData(compressionQuality: 0.5)
       let  coverImg = coverImage?.jpegData(compressionQuality: 0.5)
       
       //        print(dataImage?.fileSize())
       Alamofire.upload(multipartFormData: { (formData) in
           if let avatarImg = avarImg {
               formData.append(avatarImg ,
                               withName: "file_avatar",
                               fileName: "avatar.png",
                               mimeType: "image/png")
           }
           if let coverImage = coverImg{
               formData.append(coverImg!,
                               withName: "file_banner",
                               fileName: "cover.png",
                               mimeType: "image/png")
           }
           for (key, value) in param {
               formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!,
                               withName: key)
           }
       }, to: urlString,
          method: .post,
          headers: headers) { (_ result: SessionManager.MultipartFormDataEncodingResult) in
           switch result {
           case .success(let upload, _, _):
               upload.responseJSON { response in
                   if let error = response.error {
                       completion(Result.failure(error))
                   } else {
                       let json = JSON(response.result.value as Any)
                       let message         = json["message"].stringValue
                       let responseCode    = json["responseCode"].intValue
                       print(json)
                       if responseCode == APIErrorCode.success.rawValue {
//                            let model = DataManager.getCurrentMemberModel()
//                            model?.avatarImage = json["data"]["channel"]["avatarImage"].stringValue
//                            model?.coverImage = json["data"]["channel"]["coverImage"].stringValue
//                            model?.fullName = json["data"]["channel"]["name"].stringValue
//                            model?.descriptionChannel = json["data"]["channel"]["description"].stringValue
//                            DataManager.saveMemberModel(model!)
                           completion(Result.success(true))
                       } else {
                           let error = NSError.errorWith(code: responseCode, message: message)
                           completion(Result.failure(error))
                       }
                   }
               }
               break
           case .failure(let encodingError):
               completion(Result.failure(encodingError))
               break
           }
       }
   }
}
