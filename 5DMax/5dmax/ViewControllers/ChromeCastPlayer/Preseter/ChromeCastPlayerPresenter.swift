//
//  ChromeCastPlayerPresenter.swift
//  5dmax
//
//  Created by Hoang on 3/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import GoogleCast

class ChromeCastPlayerPresenter: NSObject {

    weak var view: ChromeCastPlayerViewInput?
    var viewModel: ChromeCastPlayerViewModel?
    var interactor: ChromeCastPlayerInteractorInput?
    var wireFrame: ChromeCastPlayerWireFrameInput?
    var remoteMediaClient: GCKRemoteMediaClient?
}

extension ChromeCastPlayerPresenter: ChromeCastPlayerViewOutput {

    func doUpdateVolume(_ value: Float) {

        if GCKCastContext.sharedInstance().castState == .connected {

            let volumeController: GCKUIDeviceVolumeController = GCKUIDeviceVolumeController()
            volumeController.setVolume(value)
        }
    }

    func doPlayOrPause() {

        if let session = GCKCastContext.sharedInstance().sessionManager.currentCastSession {

            if let remote = session.remoteMediaClient, let status = remote.mediaStatus {

                remoteMediaClient = remote
                remote.add(self)

                if status.playerState == .playing {

                    remote.pause()
                } else {
                    remote.play()
                }
            }
        }

        view?.doRefreshView()
    }

    func doSeek(_ value: Float) {

        if let remoteMediaClient =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            remoteMediaClient.seek(toTimeInterval: TimeInterval(value))
        }
    }

    func doDismiss() {

        wireFrame?.doDismiss()
    }

    func doShowPlaylist() {

    }

    func doRewin30() {

    }
}

extension ChromeCastPlayerPresenter: ChromeCastPlayerInteractorOutput {

    func doLoadMedia(_ mediaInfor: GCKMediaInformation, appending: Bool) {

        if let remoteMediaClient =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = mediaInfor
            builder.autoplay = true
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build()
            if ((remoteMediaClient.mediaStatus) != nil) && appending {
                let request = remoteMediaClient.queueInsert(item, beforeItemWithID: kGCKMediaQueueInvalidItemID)
                request.delegate = self
            } else {
                let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
                let request = remoteMediaClient.queueLoad([item], start: 0, playPosition: 0,
                                                          repeatMode: repeatMode, customData: nil)
                request.delegate = self
            }

            remoteMediaClient.loadMedia(mediaInfor, autoplay: true)
        }
    }
}

extension ChromeCastPlayerPresenter: ChromeCastPlayerWireFrameOutput {

}

extension ChromeCastPlayerPresenter: GCKRequestDelegate {

    func requestDidComplete(_ request: GCKRequest) {
        DLog("request \(Int(request.requestID)) completed")
    }

    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        DLog("request \(Int(request.requestID)) failed with error \(error)")
    }
}

// MARK: 
// MARK: CHROME CAST LISTENER
extension ChromeCastPlayerPresenter: GCKSessionManagerListener {

    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {

        DLog("didStart")
        viewModel?.metadata = session.mediaMetadata
        view?.doRefreshView()
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {

        DLog("didResumeSession")
        viewModel?.metadata = session.mediaMetadata
        view?.doRefreshView()
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {

        DLog("didEnd")
        viewModel?.metadata = session.mediaMetadata
        view?.doRefreshView()
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {

        DLog("didFailToStartSessionWithError")
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didFailToResumeSession session: GCKSession,
                        withError error: Error?) {

        DLog("didFailToResumeSession")
    }
}

extension ChromeCastPlayerPresenter: GCKRemoteMediaClientListener {

    /**
     * Called when a new media session has started on the receiver.
     *
     * @param client The client.
     * @param sessionID The ID of the new session.
     */
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didStartMediaSessionWithID sessionID: Int) {

    }

    /**
     * Called when updated media status has been received from the receiver.
     *
     * @param client The client.
     * @param mediaStatus The updated media status. The status can also be accessed as a property of
     * the player.
     */
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {

        view?.doRefreshView()
    }

    /**
     * Called when updated media metadata has been received from the receiver.
     *
     * @param client The client.
     * @param mediaMetadata The updated media metadata. The metadata can also be accessed through the
     * GCKRemoteMediaClient::mediaStatus property.
     */
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaMetadata: GCKMediaMetadata?) {

        viewModel?.metadata = mediaMetadata
        view?.doRefreshView()
    }

    /**
     * Called when the media playback queue has been updated on the receiver.
     *
     * @param client The client.
     */
    func remoteMediaClientDidUpdateQueue(_ client: GCKRemoteMediaClient) {

    }

    /**
     * Called when the media preload status has been updated on the receiver.
     *
     * @param client The client.
     */
    func remoteMediaClientDidUpdatePreloadStatus(_ client: GCKRemoteMediaClient) {

    }
}
