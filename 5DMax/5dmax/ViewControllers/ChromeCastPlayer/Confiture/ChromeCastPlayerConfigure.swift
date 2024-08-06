//
//  ChromeCastPlayerConfigure.swift
//  5dmax
//
//  Created by Hoang on 3/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import GoogleCast

class ChromeCastPlayerConfigure: NSObject {

    class func viewControllerWithPlaylist(_ playlistModel: PlayListModel) -> ChromeCastPlayerViewController {

        let vc = ChromeCastPlayerViewController.initWithNib()
        let presenter = ChromeCastPlayerPresenter()
        let interactor = ChromeCastPlayerInteractor()
        let wireFrame = ChromeCastPlayerWireFrame()
        let viewModel = ChromeCastPlayerViewModel()

        vc.presenter = presenter
        vc.viewModel = viewModel

        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        presenter.viewModel = viewModel
        presenter.view = vc

        interactor.presenter = presenter
        wireFrame.presenter = presenter
        wireFrame.viewController = vc

        viewModel.playlistModel = playlistModel
        interactor.loadPlaylistToPlay(playlistModel)
        return vc
    }
}

// MARK: 
// MARK: VIEW
protocol ChromeCastPlayerViewInput: class {

    func doRefreshView()
    func doUpdateStreamPosition()
}

protocol ChromeCastPlayerViewOutput: class {

    func doUpdateVolume(_ value: Float)
    func doPlayOrPause()
    func doSeek(_ value: Float)
    func doDismiss()
    func doShowPlaylist()
    func doRewin30()
}

// MARK: 
// MARK: INTERACTOR
protocol ChromeCastPlayerInteractorInput: class {

    func loadPlaylistToPlay(_ playlistModel: PlayListModel)
}

protocol ChromeCastPlayerInteractorOutput: class {

    func doLoadMedia(_ mediaInfor: GCKMediaInformation, appending: Bool)
}

// MARK: 
// MARK: WIRE FRAME
protocol ChromeCastPlayerWireFrameInput: class {

    func doDismiss()
}

protocol ChromeCastPlayerWireFrameOutput: class {

}

// MARK: 
// MARK: VIEW MODEL
protocol ChromeCastPlayerViewModelInput: class {

    func doUpdateMetadata(_ metadata: GCKMediaMetadata?)
}

protocol ChromeCastPlayerViewModelOutput: class {

    func getVolume() -> Float
    func getStreamDurationValue() -> TimeInterval
    func getMaxDurationValue() -> TimeInterval
    func getCurrentDurationStr() -> String
    func getCoverImageURL() -> String
    func getTitle() -> String
    func getSubTitle() -> String
    func getIsPlaying() -> Bool
}
