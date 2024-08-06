//
//  ChromeCastPlayerViewController.swift
//  5dmax
//
//  Created by Hoang on 3/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Nuke
import UIKit
import GoogleCast

class ChromeCastPlayerViewController: BaseViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCast: GCKUICastButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var volumSlider: UISlider!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnRewin30: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnSession: UIButton!
    @IBOutlet weak var lblCurrenDuration: UILabel!
    @IBOutlet weak var lblMaxduration: UILabel!
    @IBOutlet weak var durationSlider: UISlider!

    var presenter: ChromeCastPlayerViewOutput?
    weak var viewModel: ChromeCastPlayerViewModelOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        doRefreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func btnClosePressed(_ sender: Any) {

        presenter?.doDismiss()
    }

    @IBAction func volumeSliderChangeValue(_ sender: Any) {

        presenter?.doUpdateVolume(volumSlider.value)
    }

    @IBAction func btnRewin30Pressed(_ sender: Any) {

        presenter?.doRewin30()
    }

    @IBAction func btnPlayPausePressed(_ sender: Any) {

        presenter?.doPlayOrPause()
    }

    @IBAction func btnSessionPressed(_ sender: Any) {

    }

    @IBAction func durationSliderChangeValue(_ sender: Any) {

        presenter?.doSeek(durationSlider.value)
    }
}

extension ChromeCastPlayerViewController: ChromeCastPlayerViewInput {

    func doRefreshView() {

        if let item = viewModel {

            lblName.text = item.getTitle()
            lblSub.text = item.getSubTitle()

            volumSlider.setValue(item.getVolume(), animated: false)
            durationSlider.setValue(Float(item.getStreamDurationValue()), animated: false)
            durationSlider.maximumValue = Float(item.getMaxDurationValue())
            
            if let url = URL(string: item.getCoverImageURL()),
                let thumb = imgCover {
                let request = ImageRequest(url: url)
                Nuke.loadImage(with: request, into: thumb)
            }

            if item.getIsPlaying() {

                btnPlay.setImage(#imageLiteral(resourceName: "icPauseCast"), for: UIControl.State.normal)
            } else {
                btnPlay.setImage(#imageLiteral(resourceName: "icPlay"), for: UIControl.State.normal)
            }

        } else {

            btnPlay.setImage(#imageLiteral(resourceName: "icPlay"), for: UIControl.State.normal)
        }
    }

    func doUpdateStreamPosition() {

        if let item = viewModel {

            durationSlider.setValue(Float(item.getStreamDurationValue()), animated: false)
            durationSlider.maximumValue = Float(item.getMaxDurationValue())

        } else {

            durationSlider.setValue(0.0, animated: false)
        }
    }
}
