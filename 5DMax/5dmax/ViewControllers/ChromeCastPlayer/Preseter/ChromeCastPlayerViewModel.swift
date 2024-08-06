//
//  ChromeCastPlayerViewModel.swift
//  5dmax
//
//  Created by Hoang on 3/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import GoogleCast

class ChromeCastPlayerViewModel: NSObject {

    var playlistModel: PlayListModel?
    var metadata: GCKMediaMetadata?
}

extension ChromeCastPlayerViewModel: ChromeCastPlayerViewModelInput {
    func doUpdateMetadata(_ meta: GCKMediaMetadata?) {
        metadata = meta
    }
}

extension ChromeCastPlayerViewModel: ChromeCastPlayerViewModelOutput {

    func getVolume() -> Float {

        if let status =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus {

            return status.volume
        }

        return 0.0
    }

    func getStreamDurationValue() -> TimeInterval {

        if let status =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus {

            return status.streamPosition
        }

        return TimeInterval(0.0)
    }

    func getMaxDurationValue() -> TimeInterval {

        if let status =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus {

            if status.currentQueueItem?.startTime != nil {

                return TimeInterval(0.0)
            }

            return TimeInterval(0.0)
        }

        return TimeInterval(0.0)
    }

    func getCurrentDurationStr() -> String {

        return "0"
    }

    func getCoverImageURL() -> String {

        if let item = playlistModel {

            return item.detail.coverImage
        }

        return ""
    }

    func getTitle() -> String {

        if let item = playlistModel {

            return item.detail.name
        }

        return ""
    }

    func getSubTitle() -> String {

        if let playlist = playlistModel {
            let result = playlist.parts.filter { (item: PartModel) -> Bool in

                if item.partId == playlist.detail.getCurrentVideoId() {
                    return true
                }

                return false
            }

            if let item = result.first {
                return item.name
            }
        }

        return ""
    }

    func getIsPlaying() -> Bool {
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient,
            let status = remoteMediaClient.mediaStatus {

            if status.playerState == .playing {

                return true
            }

            return false
        }

        return false
    }
}
