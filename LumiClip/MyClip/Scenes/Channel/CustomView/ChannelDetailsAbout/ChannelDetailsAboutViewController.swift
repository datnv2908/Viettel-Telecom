//
//  ChannelAboutViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelDetailsAboutViewController: BaseViewController {
    
    weak var parentVC: ChannelDetailsViewController?
    @IBOutlet weak var motaLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    private var viewModel: ChannelDetailAboutViewModel
   var isChannel : Bool = false
    var channelDetail: ChannelDetailsModel?
    
    init(_ model: ChannelModel) {
        viewModel = ChannelDetailAboutViewModel(model)
        super.init(nibName: "ChannelDetailsAboutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.setViewColor()
        motaLabel.text = String.mo_ta
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupView() {
      self.descriptionLabel.textColor = UIColor.settitleColor()
      self.viewCountLabel.textColor = UIColor.settitleColor()
      self.followCountLabel.textColor = UIColor.settitleColor()
      if self.isChannel {
          descriptionLabel.text = viewModel.about
          viewCountLabel.text = viewModel.viewCount > 1 ? "\(viewModel.viewCount) \(String.luot_xem.lowercased())" : "\(viewModel.viewCount) \(String.video.lowercased())"
          followCountLabel.text = "\(viewModel.followCount) \(String.luot_theo_doi.lowercased())"
      } else {
          descriptionLabel.text = viewModel.about
          viewCountLabel.text = viewModel.videoCount > 1 ? "\(viewModel.videoCount) \(String.videos.lowercased())" : "\(viewModel.videoCount) \(String.video.lowercased())"
          followCountLabel.text = "\(viewModel.followCount) \(String.luot_theo_doi.lowercased())"
      }
    }
    func fillDetail()  {
        if let des = channelDetail?.desc {
            descriptionLabel.text = des
        }
        if let videos = channelDetail?.numVideo, videos > 0 {
            viewCountLabel.text = "\(videos) \(String.video.lowercased())"
        }
        if let views = channelDetail?.numFollow, views > 0 {
            followCountLabel.text = "\(views) \(String.luot_theo_doi.lowercased())"
        }
    }
}
