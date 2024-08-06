//
//  ChromeCastPlayerInteractor.swift
//  5dmax
//
//  Created by Hoang on 3/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import GoogleCast

class ChromeCastPlayerInteractor: NSObject {

    weak var presenter: ChromeCastPlayerInteractorOutput?
}

extension ChromeCastPlayerInteractor: ChromeCastPlayerInteractorInput {

    func loadPlaylistToPlay(_ playlistModel: PlayListModel) {

        let mediaInfor = generatorMediaInfor(playlistModel)
        presenter?.doLoadMedia(mediaInfor, appending: false)
    }
}

extension ChromeCastPlayerInteractor {

    func generatorMediaInfor(_ playlistModel: PlayListModel) -> GCKMediaInformation {
        let metadata = GCKMediaMetadata(metadataType: .movie)
        metadata.setString(playlistModel.detail.name, forKey: kGCKMetadataKeyTitle)

        let imageURL = URL(string: playlistModel.detail.avatarImage)
        let kThumbnailWidth: NSInteger = NSInteger(UIScreen.main.bounds.size.width)
        let kThumbnailHeight: NSInteger = NSInteger(UIScreen.main.bounds.size.height)

        metadata.addImage(GCKImage(url: imageURL!, width: kThumbnailWidth, height: kThumbnailHeight))

        let kMediaKeyPosterURL = "posterUrl"
        let posterImage = playlistModel.detail.coverImage
        let posterURL = URL(string: posterImage)
        metadata.setString(posterImage, forKey: kMediaKeyPosterURL)
        metadata.addImage(GCKImage(url: posterURL!, width: kThumbnailWidth, height: kThumbnailHeight))

        let description = playlistModel.detail.desc
        let kMediaKeyDescription = "description"
        metadata.setString(description, forKey: kMediaKeyDescription)

        let result = playlistModel.parts.filter { (item: PartModel) -> Bool in

            if item.partId == playlistModel.detail.getCurrentVideoId() {
                return true
            }

            return false
        }

        if let item = result.first {
            let studio = item.name
            metadata.setString(studio, forKey: kGCKMetadataKeyStudio)
        }

        let mediaTracks: [GCKMediaTrack]? = [GCKMediaTrack]()
        let urlStr = playlistModel.stream.urlStreaming
        let mimeType = "videos/mp4"
        let trackStyle: GCKMediaTextTrackStyle = GCKMediaTextTrackStyle.createDefault()

        let mediaInfor = GCKMediaInformation(contentID: urlStr,
                                             streamType: .buffered,
                                             contentType: mimeType,
                                             metadata: metadata,
                                             streamDuration: TimeInterval(0),
                                             mediaTracks: mediaTracks,
                                             textTrackStyle: trackStyle,
                                             customData: nil)

        return mediaInfor
    }
}
