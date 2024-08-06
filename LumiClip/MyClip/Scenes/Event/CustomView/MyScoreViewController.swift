//
//  MyScoreViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/25/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class MyScoreViewController: BaseViewController {

    @IBOutlet weak var lbTitleScoreL: UILabel!
    @IBOutlet weak var lbScoreCommentL: UILabel!
    @IBOutlet weak var lbScoreWatchVideoL: UILabel!
    @IBOutlet weak var lbScoreUploadVideoL: UILabel!
    @IBOutlet weak var lbScoreShareVideoL: UILabel!
    @IBOutlet weak var lbScoreLikeVideoL: UILabel!
    @IBOutlet weak var lbScoreFollowChannelL: UILabel!
    @IBOutlet weak var lbScoreRegisterL: UILabel!
    @IBOutlet weak var lbScoreUnlikeVideoL: UILabel!
    @IBOutlet weak var lbScoreTotalL: UILabel!
    
    
    @IBOutlet weak var lbTitleScore: UILabel!
    @IBOutlet weak var lbScoreComment: UILabel!
    @IBOutlet weak var lbScoreWatchVideo: UILabel!
    @IBOutlet weak var lbScoreUploadVideo: UILabel!
    @IBOutlet weak var lbScoreShareVideo: UILabel!
    @IBOutlet weak var lbScoreLikeVideo: UILabel!
    @IBOutlet weak var lbScoreFollowChannel: UILabel!
    @IBOutlet weak var lbScoreRegister: UILabel!
    @IBOutlet weak var lbScoreUnlikeVideo: UILabel!
    @IBOutlet weak var lbScoreTotal: UILabel!
    let eventService = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitleScoreL.text = String.tuong_tac_cua_ban;
        lbScoreCommentL.text = String.binh_luan;
        lbScoreWatchVideoL.text = String.xem_video;
        lbScoreUploadVideoL.text = String.daang_tai_video;
        lbScoreShareVideoL.text = String.chia_se_video;
        lbScoreLikeVideoL.text = String.thich_video;
        lbScoreFollowChannelL.text = String.theo_doi_kenh;
        lbScoreRegisterL.text = String.dang_ky_kenh;
        lbScoreUnlikeVideoL.text = String.khong_thich_video;
        lbScoreTotalL.text = String.tong_diem;
        
        lbTitleScore.textAlignment = NSTextAlignment.right;
        lbScoreComment.textAlignment = NSTextAlignment.right;
        lbScoreWatchVideo.textAlignment = NSTextAlignment.right;
        lbScoreUploadVideo.textAlignment = NSTextAlignment.right;
        lbScoreShareVideo.textAlignment = NSTextAlignment.right;
        lbScoreLikeVideo.textAlignment = NSTextAlignment.right;
        lbScoreFollowChannel.textAlignment = NSTextAlignment.right;
        lbScoreRegister.textAlignment = NSTextAlignment.right;
        lbScoreUnlikeVideo.textAlignment = NSTextAlignment.right;
        lbScoreTotal.textAlignment = NSTextAlignment.right;
        // Do any additional setup after loading the view.
        getPointInfor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getPointInfor() {
        showHud()
        eventService.getPoints{ (result) in
            switch result {
            case .success(let response):
                self.lbScoreComment.text = String(response.data.commentPoint)
                self.lbScoreWatchVideo.text = String(response.data.watchPoint)
                self.lbScoreUploadVideo.text = String(response.data.uploadPoint)
                self.lbScoreShareVideo.text = String(response.data.sharePoint)
                self.lbScoreLikeVideo.text = String(response.data.likePoint)
                self.lbScoreFollowChannel.text = String(response.data.followPoint)
                self.lbScoreRegister.text = String(response.data.registerPoint)
                self.lbScoreUnlikeVideo.text = String(response.data.dislikePoint)
                self.lbScoreTotal.text = String(response.data.totalPoint)
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
