//
//  DownloadManager.swift
//  
//
//  Created by Admin on 11/25/17.
//

import UIKit
import RealmSwift

enum DownloadStatus: String {
    case new = "new"
    case downloading = "downloading"
    case downloaded = "downloaded"
    case error = "error"
    case cancelled = "cancelled"
}

class DownloadManager: NSObject {
    let realm = try! Realm()
    public static let shared: DownloadManager = {
        let instance = DownloadManager()
        DispatchQueue.once(token: "DownloadManager", block: { 
            instance.addObserver()
        })
        return instance }()

    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(lostConnectInternet),
                                               name: .kLoseInternet,
                                               object: nil)
    }

    @objc func lostConnectInternet() {
        print("lost connect  internet")
        for index in downloadingVideos.indices where downloadingVideos[index].downloadStatus == .downloading {
            downloadingVideos[index].downloadStatus = .error
            SDDownloadManager.shared.cancelDownload(forUniqueKey: downloadingVideos[index].downloadLink)
        }
    }
    
    @objc func reconnectInternet() {
        print("reconnect  internet")
//        for index in downloadingVideos.indices where downloadingVideos[index].downloadStatus == .error {
//            performDownload(downloadingVideos[index])
//        }
    }

    public var downloadingVideos = [DownloadModel]()

    func downloadVideo(link: String, video: DetailModel) {
        var downloadModel: DownloadModel
        if let model = downloadingVideos.filter({$0.id == video.id}).first {
            downloadModel = model
            performDownload(downloadModel)
        } else if getAllDownloadedVideo().map({$0.id}).contains(video.id) {
            return
        } else {
            downloadModel = DownloadModel(from: video)
            downloadModel.downloadLink = link
            downloadingVideos.append(downloadModel)
            performDownload(downloadModel)
        }
    }

    private func performDownload(_ model: DownloadModel) {
        guard let url = URL(string: model.downloadLink) else {
            return
        }
        let request = URLRequest(url: url)
        if let index = self.indexOf(downloadingVideo: model.id) {
            self.downloadingVideos[index].downloadStatus = .downloading
        }
        checkContentLenght(url) { (success) in
            if success {
                _ = SDDownloadManager.shared.dowloadFile(withRequest: request,
                                                         inDirectory: "download",
                                                         withName: model.downloadSaveName,
                                                         onProgress: { (progress: CGFloat) in
                                                            if let index = self.indexOf(downloadingVideo: model.id) {
                                                                self.downloadingVideos[index].downloadPercent = Double(progress)
                                                            }
                                                            print("progress: \(progress)")
                }, onCompletion: { (error, fileUrl) in
                    if error != nil {
                        print(error?.localizedDescription ?? "Download error")
                        if let index = self.indexOf(downloadingVideo: model.id) {
                            // mark this video as error & remove it from SDDownloadManager.downloading queue
                            self.downloadingVideos[index].downloadStatus = .error
                            SDDownloadManager.shared.cancelDownload(forUniqueKey: model.downloadLink)
                        }
                    } else {
                        if let index = self.indexOf(downloadingVideo: model.id) {
                            self.downloadingVideos.remove(at: index)
                        }
                        let downloadObject = DownloadObject()
                        try! self.realm.write({
                            downloadObject.initialize(from: model)
                            downloadObject.downloadPercent = 100.0
                            downloadObject.downloadStatus = DownloadStatus.downloaded.rawValue
                            downloadObject.downloadSaveName = model.downloadSaveName
                            self.realm.add(downloadObject)
                            DispatchQueue.main.async(execute: {
                                NotificationCenter.default.post(name: .kNotificationDownloadCompleted, object: nil)
                            })
                        })
                    }
                })
            } else {
                if let index = self.indexOf(downloadingVideo: model.id) {
                    // mark this video as error & remove it from SDDownloadManager.downloading queue
                    self.downloadingVideos[index].downloadStatus = .error
                    SDDownloadManager.shared.cancelDownload(forUniqueKey: model.downloadLink)
                }
            }
        }

    }

    func indexOf(downloadingVideo id: String) -> Int? {
        return downloadingVideos.map({$0.id}).index(of: id)
    }

    func getAllDownloadedVideo() -> [DownloadModel] {
        var models = [DownloadModel]()
        for item in getVideo(with: .downloaded) {
            models.append(DownloadModel(withLolcal: item))
        }
        return models
    }

    func cancelAllDownloadingItems() {
        for (index, item) in downloadingVideos.enumerated() {
            downloadingVideos.remove(at: index)
            SDDownloadManager.shared.cancelDownload(forUniqueKey: item.downloadLink)
        }
    }

    func cancelDownload(_ model: DownloadModel) {
        for (index, item) in downloadingVideos.enumerated() where item.id == model.id {
            downloadingVideos.remove(at: index)
        }
        SDDownloadManager.shared.cancelDownload(forUniqueKey: model.downloadLink)
    }

    func resumeDownload(_ model: DownloadModel) {
        performDownload(model)
    }

    func getVideo(with status: DownloadStatus) -> [DownloadObject] {
        let predicate = NSPredicate(format: "downloadStatus = %@", status.rawValue)
        let data = realm.objects(DownloadObject.self).filter(predicate).sorted(byKeyPath: "createdAt", ascending: false)
        var result: [DownloadObject] = []
        for item in data {
            result.append(item)
        }
        return result
    }

    func isDownloading(video id: String) -> Bool {
        if indexOf(downloadingVideo: id) != nil {
            return true
        } else {
            return false
        }
    }

    func isDownloaded(video id: String) -> Bool {
        let predicate = NSPredicate(format: "id = %@", id)
        if realm.objects(DownloadObject.self).filter(predicate).first != nil {
            return true
        } else {
            return false
        }
    }

    //MARK:
    fileprivate func isDownloaded(link: String, content: ContentModel) -> Bool {
        let predicate = NSPredicate(format: "id = %@ AND downloadStatus = %@", content.id, DownloadStatus.downloaded.rawValue)
        if realm.objects(DownloadObject.self).filter(predicate).first != nil {
            return true
        }
        return false
    }
    
    func getFreeSize() -> Int64? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                return freeSize.int64Value
            }
        } else {
            print("Error Obtaining System Memory Info:")
        }
        return nil
    }
    
    func getTotalSize() -> Int64?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemSize] as? NSNumber {
                return freeSize.int64Value
            }
        } else {
            print("Error Obtaining System Memory Info:")
        }
        return nil
    }

    func checkContentLenght(_ url: URL, completion: @escaping(Bool) -> Void) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "HEAD"
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) in
            if let err = error {
                Constants.appDelegate.window?.rootViewController?.toast(err.localizedDescription)
                completion(false)
            } else if let response = response, let freeSize = self.getFreeSize() {
                print("contentLength: \(response.expectedContentLength)")
                print("freeSize: \(freeSize)")
                if response.expectedContentLength + 20 > freeSize {
                    completion(false)
                    NotificationCenter.default.post(name: .kOutOfMemory, object: nil)
                } else {
                    completion(true)
                }
            } else {
                completion(true)
            }
        })
    }

    func deleteAllVideo() {
        let listDownloaded = getVideo(with: .downloaded)
        for model in listDownloaded {
            deleteVideo(model.id)
        }
    }
    
    func deleteVideo(_ id: String) {
        let fileManager = FileManager.default
        // delete physical file
        do {
            let filePath = SDFileUtils.downloadedFilePath(with: "\(id).mp4")
            let url = URL(fileURLWithPath: filePath)
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(at: url)
                Constants.appDelegate.window?.rootViewController?.toast(String.da_xoa_video_tai_xuong)
            }
        }  catch  {
            print(error)
        }

        // delete from Realm
        if let object = realm.object(ofType: DownloadObject.self, forPrimaryKey: id) {
            try! realm.write({
                realm.delete(object)
            })
        }
    }
    
    static func haveDownloadedVideos() -> Bool {
        return !DownloadManager.shared.getAllDownloadedVideo().isEmpty
    }
}
