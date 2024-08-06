//
//  VideoInfoTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol VideoInfoTableViewCellDelegate: NSObjectProtocol {
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnLike sender: UIButton)
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnDislike sender: UIButton)
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnShare sender: UIButton)
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnDownload sender: UIButton)
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnWatchLater sender: UIButton)
    func videoInfoTableViewCell(_ cell: VideoInfoTableViewCell,
                                didClickOnExpandButton sender: UIButton)
}

class VideoInfoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var numberLikeLabel: UILabel!
    @IBOutlet weak var numberDislikeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
//    @IBOutlet weak var progress: UIActivityIndicatorView!
//    @IBOutlet weak var downloadButton: UIButton!
   @IBOutlet weak var likeBgView: UIView!
   
   @IBOutlet weak var DisLikeBgView: UIView!
   @IBOutlet weak var shareBgView: UIView!
   @IBOutlet weak var addPlaylistBgView: UIView!
   @IBOutlet weak var shareLabel: UILabel!
//    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    
   @IBOutlet weak var inforView: UIView!
    @IBOutlet weak var linerView: UIView!
    weak var delagate: VideoInfoTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shareLabel.text = String.chia_se
//        downloadLabel.text = String.tai_xuong
        addLabel.text = String.them_vao
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
      inforView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      likeBgView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      DisLikeBgView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      shareBgView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      addPlaylistBgView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
        self.linerView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
        if let rowModel = model as? VideoInfoRowModel {
            numberLikeLabel.text = String(rowModel.numberLike)
            numberDislikeLabel.text = String(rowModel.numberDislike)
            if rowModel.isExpand {
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
            likeButton.isSelected = rowModel.likeStatus == .like
            dislikeButton.isSelected = rowModel.likeStatus == .dislike
            
            switch rowModel.downloadStatus {
            case .downloading:
//                downloadButton.isHidden = true
//                downloadButton.setImage(#imageLiteral(resourceName: "iconDownload"), for: UIControlState.normal)
//                downloadButton.isHidden = false
//                downloadButton.setImage(nil, for: .normal)
//                progress.startAnimating()
                break
            case .downloaded:
//                downloadButton.isHidden = false
//                downloadButton.setImage(#imageLiteral(resourceName: "check"), for: .normal)
//                progress.stopAnimating()
                break
            default:
//                downloadButton.isHidden = false
//                downloadButton.setImage(#imageLiteral(resourceName: "iconDownload"), for: .normal)
//                progress.stopAnimating()
                break
            }
        }
    }
    
    @IBAction func onClickExpandButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self, didClickOnExpandButton: sender as! UIButton)
    }
    
    @IBAction func onClickLikeButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self,
                                         didClickOnLike: sender as! UIButton)
    }
    
    @IBAction func onClickDislikeButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self,
                                         didClickOnDislike: sender as! UIButton)
    }
    
    @IBAction func onClickShareButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self,
                                         didClickOnShare: sender as! UIButton)
    }
    
    @IBAction func onClickDownloadButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self,
                                         didClickOnDownload: sender as! UIButton)
    }
    
    @IBAction func onClickWatchLaterButton(_ sender: Any) {
        delagate?.videoInfoTableViewCell(self,
                                         didClickOnWatchLater: sender as! UIButton)
    }
}
