//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

struct VideosWatched {
    static var list = [String]()
}

class VideoDetailViewModel: NSObject, VideoDetailViewModelOutput {
    var isShowSuggestions: Bool = false
    var listSuggestionChannel = [ChannelModel]()
    var title: String? = "VideoDetailViewController"
    var sections = [SectionModel]()
    var playlistSections = [SectionModel]()
    var playerConfig = MyCustomPlayerConfig()
    var listComment = [CommentModel]()
    var isShowCommentView: Bool = false
    var currentComment: String = ""
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var isUpdateComment: Bool = false
    var currentParentComment: String = ""

    var changeItemWithinPlaylist: Bool = false // Nếu chọn 1 item trong ds phát thì sẽ ko xoá playlistModel
                                                // & giữ nguyên trạng thái của expandPlaylistItem
    var kpiToken: KPIToken? {
        didSet {
            if let value = kpiToken {
                kpiModel = KPIModel(with: value.token)
            }
        }
    }
    var kpiModel: KPIModel?
    
    private var _contentModel: ContentModel?
    var contentModel: ContentModel? {
        set {
            _contentModel = newValue
            resetProperties()
        }
        get {
            return _contentModel
        }
    }
    private var _detailModel: VideoDetailModel?
    var detailModel: VideoDetailModel? {
        set {
            _detailModel = newValue
            // cập nhật ds video đã chơi trong TH có video thêm mới, có video bị xoá đi.
            updateListPlayedVideos()
            // nếu chưa có phần tử nào trong ds video đã chơi,
            //it means video details mới vào lần đầu
            //=> insert detail.id into ds video đã chơi,
            //=> insert các phần tử còn lại vào ds video còn lại.

            let isRandom = DataManager.isSufferingPlaylist()
            if isRandom {
                initiateListPlayedVideosifNeeded()
                // cập nhật lại ds video đã chơi & ds video còn lại nếu cần.
                if !willNextVideo.isEmpty {
                    didNextToVideo(willNextVideo)
                }
                if !willBackVideo.isEmpty {
                    didBackToVideo(willBackVideo)
                }
                willNextVideo = ""
                willBackVideo = ""
            } else {
                if isShowingVideoPlaylist() {
                    resetListPlayedVideos()
                }
            }
            
            //======== cập nhật lại ds section
            reloadSections()
            reloadPlayerConfig()
            
            guard let model = newValue else {
                return
            }
            
            if model.playlist.videos.isEmpty {
                playlistModel = nil
                changeItemWithinPlaylist = false
            }
        }
        get {
            return _detailModel
        }
    }

    var isExpandDesc: Bool = false
    var isFollowChannel: Bool = false
    var followCount: Int = 0

    var playlistModel: PlaylistModel?
    var playlistName: String {
        set {
        }
        get {
            if let model = detailModel {
                return model.playlist.name
            }
            return ""
        }
    }
    var playlistOwner: String {
        set {

        }
        get {
            if let model = detailModel {
                return model.playlist.fullUserName
            }
            return ""
        }
    }
    var isExpandPlaylist: Bool = false

    var listPlayedVideos = [String]() // danh sách video đã chơi trong playlist
    var listRemainingVideos = [String]() // danh sách video còn lại trong playlist
    var listVideosWatched = VideosWatched.list
    private var willNextVideo: String = ""
    private var willBackVideo: String = ""

    init(with content: ContentModel?, and playlist: PlaylistModel?) {
        _contentModel = content
        playlistModel = playlist
        playerConfig.title = content?.name ?? ""
        playerConfig.image = content?.coverImage ?? ""
    }

    init(download model: DownloadModel) {
        super.init()
        _contentModel = ContentModel(download: model)
        _detailModel = VideoDetailModel(download: model)
        reloadPlayerConfig()
        playerConfig.title = model.name
        playerConfig.image = model.coverImage
        playerConfig.localFilePath = model.localFilePath()
        reloadSections()
    }

    private func resetProperties() {
        if let model = _contentModel {
            playerConfig = MyCustomPlayerConfig()
            playerConfig.title = model.name
            playerConfig.image = model.coverImage
            isExpandDesc = false
            isFollowChannel = false
            if changeItemWithinPlaylist == true {
                // dont' reset playlist model & expandPlaylist value
            } else {
                isExpandPlaylist = false
                playlistModel = nil
            }
            followCount = 0
            detailModel = nil
            sections = [SectionModel]()
            listComment = [CommentModel]()
        }
    }

    func getVideoId() -> String {
        if let model = contentModel {
            return model.id
        } else {
            return detailModel?.detail.id ?? ""
        }
    }

    func reloadSections() {
        // video detail sections
        sections = [SectionModel]()
        guard let model = detailModel else {
            return
        }
        var sectionInfo = SectionModel(rows: [])
        sectionInfo.rows.append(VideoInfoRowModel(model.detail, isExpand: isExpandDesc))
        sectionInfo.rows.append(ChannelInfoRowModel(title: model.detail.owner.name,
                                                    desc: "\(model.detail.owner.num_follow) \(String.theo_doi.lowercased())",
            image: model.detail.owner.avatarImage,
            identifier: ChannelInfoTableViewCell.nibName(),
            objectID: model.detail.owner.id,
            isFollow: model.detail.owner.isFollow, freeVideo: false))
        if isExpandDesc {
            sectionInfo.rows.append(RowModel(title: "\(String.dang_vao) \(model.detail.publishedTime)",
                                             desc: model.detail.desc,
                                             image: "",
                                             identifier: ChannelDescTableViewCell.nibName()))
        }
        
        let relateHeader = RelateVideoHeaderModel(title: "",
                                                  identifier: RelateVideoHeaderView.nibName(),
                                                  isAutoPlay: DataManager.isAutoPlayNextVideo())
        var relateRows = [VideoRowModel]()
        for item in model.relates.videos {
            relateRows.append(VideoRowModel(video: item, identifier: VideoSmallImageTableViewCell.nibName()))
        }
        var sectionRelate: SectionModel
        if isShowingVideoPlaylist() {
            sectionRelate = SectionModel(rows: relateRows)
        } else {
            sectionRelate = SectionModel(rows: relateRows, header: relateHeader)
        }
        sections.insert(sectionRelate, at: 0)
        sections.insert(sectionInfo, at: 0)
        isFollowChannel = model.detail.owner.isFollow
        followCount = model.detail.owner.num_follow
        var sectionComment = SectionModel(rows: [])
        if Singleton.sharedInstance.isConnectedInternet {
            sectionComment.rows.append(RowModel(title: String( listComment.count),
                                                desc: "",
                                                image: "",
                                                identifier: CommentTableViewCell.nibName()))
        }
      for item in listComment {
         sectionComment.rows.append(CommentInfoRowModel(item))
      }
      sections.append(sectionComment)
     
      

       
        // playlist section
        playlistSections = [SectionModel]()
        let playlistHeader = HeaderModel(title: "",
                                         identifier: VideoDetailPlaylistHeaderView.nibName())
        var videoPlaylistRows = [VideoRowModel]()
        for (index, item) in model.playlist.videos.enumerated() {
            var rowModel = VideoRowModel(video: item,
                                         identifier: VideoPlaylistItemTableViewCell.nibName())
            if index == currentItemIndexInPlaylist(){
                rowModel.isSelected = true
            } else {
                rowModel.isSelected = false
            }
            videoPlaylistRows.append(rowModel)
        }
        playlistSections.append(SectionModel(rows: videoPlaylistRows, header: playlistHeader))
        // update info section base on download status of this video
        checkDownloadStatus()
    }

    // this function is called when app return foreground
    func updateShowTime() {
        guard let model = detailModel else {
            return
        }
        let newShowTime = model.detail.showDate.timeIntervalSinceNow
        if newShowTime > 0 {
            model.detail.showTimes = newShowTime
            playerConfig.showTimes = newShowTime
        }
    }

    private func reloadPlayerConfig() {
        guard let model = detailModel else {
            return
        }
        playerConfig.title = model.detail.name
        playerConfig.image = model.detail.coverImage
        playerConfig.file = model.streams.urlStreaming
        playerConfig.shouldSeekToTime = model.detail.watchTime
        playerConfig.related = model.relates.videos
        playerConfig.nextId = nextVideoId()
        playerConfig.previousId = previousVideoId()
        playerConfig.playlistSections = model.playlist.videos
        playerConfig.previewImage = model.detail.previewImage
        playerConfig.duration = model.detail.duration
        playerConfig.streamStatus = model.streams.errorCode.rawValue
        playerConfig.showTimes = model.detail.showTimes
        playerConfig.isCasting = model.detail.id == GoogleChromcastHelper.shareInstance.currentCastingVideo()
    }

    // return index of the item in playlist
    func isShowingVideoPlaylist() -> Bool {
        guard let model = detailModel else {
            return false
        }
        return !model.playlist.videos.isEmpty
    }

    func currentItemIndexInPlaylist() -> Int? {
        guard let model = detailModel else {
            return nil
        }
        return model.playlist.videos.map({$0.id}).index(of: model.detail.id)
    }

    func currentItemIndexInPlaylistString() -> String? {
        guard let model = detailModel, let index = currentItemIndexInPlaylist() else {
            return nil
        }
        return String.init(format: "%d/%d", index + 1, model.playlist.videos.count)
    }

    func initiateListPlayedVideosifNeeded() {
        guard let model = detailModel else {
            return
        }
        if listPlayedVideos.isEmpty {
            resetListPlayedVideos()
            listPlayedVideos.append(model.detail.id)
            listRemainingVideos.append(contentsOf: model.playlist.videos.filter({$0.id != model.detail.id}).map({$0.id}))
        }
        if listRemainingVideos.isEmpty {
            let playlistIds = model.playlist.videos.map({$0.id})
            let tempArray = playlistIds.filter({ (item) -> Bool in
                return !listPlayedVideos.contains(item)
            })
            listRemainingVideos.append(contentsOf: tempArray)
        }
    }

    func updatePlayerConfigIfNeeded() {
        playerConfig.nextId = nextVideoId()
        playerConfig.previousId = previousVideoId()
        playerConfig.isCasting = GoogleChromcastHelper.shareInstance.currentCastingVideo() == detailModel?.detail.id
    }

    /*
     *  reset ds video đã chơi, ds video còn lại trong playlist.
     *  trong các case:
     *  - user tự chọn item khác trong playlist
     *  - khi next, back, complete mà isRandom = false
     */
    func resetListPlayedVideos() {
        listPlayedVideos.removeAll()
        listRemainingVideos.removeAll()
    }

    func updateListPlayedVideos() {
        guard let model = detailModel else {
            return
        }
        
        let playlist = model.playlist.videos
        if playlist.isEmpty {
            if VideosWatched.list.last == model.detail.id {
                return
            }
            VideosWatched.list.append(model.detail.id)
            listPlayedVideos = VideosWatched.list.map{$0.copy()} as! [String]
            return
        }
        
        let playlistIds = model.playlist.videos.map({$0.id})
        for item in playlistIds { // nếu có 1 video mới được thêm vào ds phát => append to listRemainingVideos
            if !listPlayedVideos.contains(item) && !listRemainingVideos.contains(item) {
                listRemainingVideos.append(item)
            }
        }
        listPlayedVideos = listPlayedVideos.filter({ (item) -> Bool in
            return playlistIds.contains(item)
        })
        listRemainingVideos = listRemainingVideos.filter({ (item) -> Bool in
            return playlistIds.contains(item)
        })
    }

    func willBackToVideo(_ id: String) {
        willBackVideo = id
    }

    private func didBackToVideo(_ id: String) {
        if listPlayedVideos.contains(id) {
            return
        }
        listPlayedVideos.insert(id, at: 0)
        for index in listRemainingVideos.indices where listRemainingVideos[index] == id {
            listRemainingVideos.remove(at: index)
            break
        }

    }

    func willNextToVideo(_ id: String) {
        willNextVideo = id
    }

    private func didNextToVideo(_ id: String) {
        if listPlayedVideos.contains(id) {
            return
        }
        listPlayedVideos.append(id)
        for index in listRemainingVideos.indices where listRemainingVideos[index] == id {
            listRemainingVideos.remove(at: index)
            break
        }
    }

    func previousVideoId() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        let isRandom = DataManager.isSufferingPlaylist()
        let isRepeat = DataManager.isRepeatPlaylist()
        if isShowingVideoPlaylist() {
            if isRandom {
                initiateListPlayedVideosifNeeded()
                if currentId == listPlayedVideos.first { // video đầu tiên trong ds
                    if listRemainingVideos.isEmpty {
                        if isRepeat {
                            return listPlayedVideos.last
                        } else {
                            return nil
                        }
                    } else {
                        return listRemainingVideos.random()
                    }
                } else {
                    return previousVideoInPlayedVideos()
                }
            } else {
                return previousIdInPlaylist()
            }
        } else {
            if model.previousId.isEmpty {
                return previousVideoInVideosWatched()
            }else {
                return model.previousId
            }
        }
    }

    func nextVideoId() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        let isRandom = DataManager.isSufferingPlaylist()
        let isRepeat = DataManager.isRepeatPlaylist()
        if isShowingVideoPlaylist() {
            if isRandom {
                initiateListPlayedVideosifNeeded()
                if currentId == listPlayedVideos.last { // đã chơi đến phần tử cuối cùng trong ds đã chơi.
                    if listRemainingVideos.isEmpty { // đã chơi hết tất cả các phần tử trong playlist
                        if isRepeat { // nếu có lặp lại => quay lại item đầu tiên trong ds đã chơi
                            return listPlayedVideos.first
                        } else {
                            return nil
                        }
                    } else {
                        // lấy phần tử tiếp theo trong ds chưa chơi.
                        return listRemainingVideos.random()
                    }
                } else { // lấy phần tử tiếp theo trong ds đã chơi.
                    return nextVideoInPlayedVideos()
                }
            } else {
                return nextVideoInPlaylist()
            }
        } else {
            return model.nextId
        }
    }

    private func nextVideoInPlayedVideos() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        if let index = listPlayedVideos.index(of: currentId) {
            if index + 1 >= listPlayedVideos.count {
                return nil
            } else {
                return listPlayedVideos[index + 1]
            }
        } else {
            return nil
        }
    }

    private func nextVideoInPlaylist() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        let isRepeat = DataManager.isRepeatPlaylist()
        let playlistIds = model.playlist.videos.map({$0.id})
        if let index = playlistIds.index(of: currentId) {
            if index + 1 >= playlistIds.count {
                if isRepeat {
                    return playlistIds.first
                } else {
                    return nil
                }
            } else {
                return playlistIds[index + 1]
            }
        } else {
            return nil
        }
    }

    private func previousIdInPlaylist() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        let isRepeat = DataManager.isRepeatPlaylist()
        let playlistIds = model.playlist.videos.map({$0.id})
        if let index = playlistIds.index(of: currentId) {
            if index - 1 < 0 {
                if isRepeat {
                    return playlistIds.last
                } else {
                    return nil
                }
            } else {
                return playlistIds[index - 1]
            }
        } else {
            return nil
        }
    }

    private func previousVideoInPlayedVideos() -> String? {
        guard let model = detailModel else {
            return nil
        }
        let currentId = model.detail.id
        if let index = listPlayedVideos.index(of: currentId) {
            if index - 1 < 0 {
                return nil
            } else {
                return listPlayedVideos[index - 1]
            }
        } else {
            return nil
        }
    }
    
    private func previousVideoInVideosWatched() -> String? {
        guard detailModel != nil else {
            return nil
        }
        var listTemp = VideosWatched.list.map{$0.copy()} as! [String]
        if listTemp.count > 0 {
            listTemp.removeLast()
            if listTemp.count > 0 {
                return listTemp.last
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
}

extension VideoDetailViewModel: VideoDetailViewModelInput {
    func doUpdateWithListComment(models: [CommentModel]) {
        listComment = models
        reloadSections()
    }
    
    func doUpdateWithComment(model: CommentModel) {
        self.isShowCommentView = false
        var section = sections.last
        section?.rows.insert(CommentInfoRowModel(model), at: 1)
        sections.removeLast()
        sections.append(section!)
        self.listComment.insert(model, at: 0)
        reloadSections()
    }
    
    func doUpdateWithToggleLikeVideo(isSelectLike: Bool) {
        //row video info at section 0 - row 0
        var rowModel = sections[0].rows[0] as? VideoInfoRowModel
        if isSelectLike {
            if rowModel?.likeStatus != LikeStatus.like {
                var numberLike = Int((rowModel?.numberLike)!)!
                numberLike += 1
                detailModel?.detail.likeCount = String(numberLike)
                rowModel?.numberLike = String(numberLike)
                if rowModel?.likeStatus == LikeStatus.dislike {
                    var numberDislike = Int((rowModel?.numberDislike)!)!
                    numberDislike -= 1
                    rowModel?.numberDislike = String(numberDislike)
                    detailModel?.detail.dislikeCount = String(numberDislike)
                }
                rowModel?.likeStatus = .like
                detailModel?.detail.likeStatus = .like
            } else {
                var numberLike = Int((rowModel?.numberLike)!)!
                numberLike -= 1
                rowModel?.numberLike = String(numberLike)
                rowModel?.likeStatus = .none
                detailModel?.detail.likeCount = String(numberLike)
                detailModel?.detail.likeStatus = .none
            }
        } else {
            if rowModel?.likeStatus != LikeStatus.dislike {
                var numberDislike = Int((rowModel?.numberDislike)!)!
                numberDislike += 1
                rowModel?.numberDislike = String(numberDislike)
                detailModel?.detail.dislikeCount = String(numberDislike)
                if rowModel?.likeStatus == LikeStatus.like {
                    var numberLike = Int((rowModel?.numberLike)!)!
                    numberLike -= 1
                    rowModel?.numberLike = String(numberLike)
                    detailModel?.detail.likeCount = String(numberLike)
                }
                rowModel?.likeStatus = .dislike
                detailModel?.detail.likeStatus = .dislike
            } else {
                var numberDislike = Int((rowModel?.numberDislike)!)!
                numberDislike -= 1
                rowModel?.numberDislike = String(numberDislike)
                rowModel?.likeStatus = .none
                detailModel?.detail.dislikeCount = String(numberDislike)
                detailModel?.detail.likeStatus = .none
            }
        }
        sections[0].rows[0] = rowModel!
    }
    
    func doUpdateWithToggleLikeComment(at indexPath: IndexPath) {
        var commentRowModel = sections[indexPath.section].rows[indexPath.row] as! CommentInfoRowModel
        let comment = listComment[indexPath.row-1]
        if commentRowModel.isLike {
            var numberLike = (Int(commentRowModel.numberLike))!
            numberLike -= 1
            commentRowModel.numberLike = String(numberLike)
            comment.likeCount = numberLike
        } else {
            var numberLike = (Int(commentRowModel.numberLike))!
            numberLike += 1
            commentRowModel.numberLike = String(numberLike)
            comment.likeCount = numberLike
        }
      if commentRowModel.isDisLike {
         commentRowModel.isDisLike = false
         comment.isDisLike = false
         var numberLike = (Int(commentRowModel.numberDisLike))!
         numberLike -= 1
         commentRowModel.numberDisLike = String(numberLike)
         comment.disLikeCount = String(numberLike)
         
      }
        commentRowModel.isLike = !commentRowModel.isLike
        comment.isLike = !comment.isLike
        sections[indexPath.section].rows[indexPath.row] = commentRowModel
        // index of comment shoule be indexpath.row - 1
        // because the first row is comment input field
        listComment[indexPath.row - 1] = comment
    }
   func doUpdateWithToggleDisLikeComment(at indexPath: IndexPath) {
       var commentRowModel = sections[indexPath.section].rows[indexPath.row] as! CommentInfoRowModel
       let comment = listComment[indexPath.row-1]
       if commentRowModel.isDisLike {
           var numberLike = (Int(commentRowModel.numberDisLike))!
           numberLike -= 1
           commentRowModel.numberDisLike = String(numberLike)
           comment.disLikeCount = String(numberLike)
       } else {
           var numberLike = (Int(commentRowModel.numberDisLike))!
           numberLike += 1
           commentRowModel.numberDisLike = String(numberLike)
           comment.disLikeCount = String(numberLike)
       }
      if commentRowModel.isLike {
         commentRowModel.isLike = false
         comment.isLike = false
         var numberLike = (Int(commentRowModel.numberLike))!
         numberLike -= 1
         commentRowModel.numberLike = String(numberLike)
         comment.likeCount = numberLike
      }
       commentRowModel.isDisLike = !commentRowModel.isDisLike
       comment.isDisLike = !comment.isDisLike
       sections[indexPath.section].rows[indexPath.row] = commentRowModel
       // index of comment shoule be indexpath.row - 1
       // because the first row is comment input field
       listComment[indexPath.row - 1] = comment
   }

    func checkDownloadStatus() {
        if getVideoId().isEmpty {
            return
        }
        var status: DownloadStatus
        if DownloadManager.shared.isDownloading(video: getVideoId()) {
            status = .downloading
        } else if DownloadManager.shared.isDownloaded(video: getVideoId()) {
            status = .downloaded
        } else {
            status = .new
        }
        if !sections.isEmpty && !(sections.first?.rows.isEmpty)! {
            var rowModel = sections[0].rows[0] as? VideoInfoRowModel
            rowModel?.downloadStatus = status
            sections[0].rows[0] = rowModel!
        }
    }
}
