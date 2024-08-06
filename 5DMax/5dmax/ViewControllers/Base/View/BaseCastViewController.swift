//
//  BaseViewController.swift
//  GoogleChromcast
//
//  Created by Hoang on 3/29/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleCast

class BaseCastViewController: UIViewController {

    private var castButton: GCKUICastButton!
    var mediaInfo: GCKMediaInformation? {
        didSet {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension BaseCastViewController: GCKSessionManagerListener {

    // MARK: - GCKSessionManagerListener
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
    }

    func sessionManager(_ sessionManager: GCKSessionManager,
                        didFailToResumeSession session: GCKSession, withError error: Error?) {
    }

    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertView(title: title, message: message,
                                delegate: nil, cancelButtonTitle: String.dong_y, otherButtonTitles: "")
        alert.show()
    }
}

extension BaseCastViewController: GCKRequestDelegate {

    func requestDidComplete(_ request: GCKRequest) {
    }

    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
    }
}

extension BaseCastViewController: GCKRemoteMediaClientListener {

    func remoteMediaClient(_ player: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        self.mediaInfo = mediaStatus?.mediaInformation
    }
}
