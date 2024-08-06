//
//  ChannelInfoTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol ChannelInfoTableViewCellDelegate: NSObjectProtocol {
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell,
                                  didClickOnFollow sender: UIButton)
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell,
                                  didClickOnCloseSuggestion sender: UIButton)
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell,
                                  didClickOnFollowSuggestionChannel channelModel: ChannelModel)
    func channelInfoTableViewCell(_ cell: ChannelInfoTableViewCell,
                                  didClickGoSuggestionChannelDetail channelModel: ChannelModel)
}

class ChannelInfoTableViewCell: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SuggestionChannelTableViewCellDelegate {

    weak var delegate: ChannelInfoTableViewCellDelegate?
    
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet weak var viewSuggestions: UIView!
    @IBOutlet weak var suggestionsHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionsChannel: UICollectionView!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var maybeLoveLabel: UILabel!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var nameChannelView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var headerLine: UIView!
    
    var listSuggestionChannel = [ChannelModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewSuggestions.backgroundColor = UIColor.setViewColor()
        suggestionsChannel.backgroundColor = UIColor.setViewColor()
        followLabel?.text = String.theo_doi_btn
        maybeLoveLabel?.text = String.co_the_ban_thich
        unFollowButton.setTitle(String.unFollow, for: .normal)
        unFollowButton.backgroundColor = UIColor.setViewColor()
        unFollowButton.setTitleColor(UIColor.settitleColor(), for: .normal)

        imgShare.image = imgShare.image?.withRenderingMode(.alwaysTemplate)
        imgShare.tintColor = AppColor.mainColor()
        
        nameChannelView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
        headerLine.backgroundColor = UIColor.setViewColor()
      viewFollow.backgroundColor = UIColor.setViewColor()
        btnFollow.backgroundColor = UIColor.clear
        followLabel.textColor = UIColor.settitleColor()
        
        lineView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
        viewFollow.layer.cornerRadius = 3
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        if let url = URL(string: model.image) {
            thumbImageView?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        if let rowModel = model as? ChannelInfoRowModel {
            if(rowModel.isFollow){
                unFollowButton.isHidden = false
                viewFollow.isHidden = true
            }else{
                unFollowButton.isHidden = true
                viewFollow.isHidden = false
            }
        }
        
        suggestionsHeightContraint.constant = 228
        viewSuggestions.isHidden = false
    }
    
    func bindingWithModel(_ isFollow: Bool, followCount: Int, isShowSuggestions: Bool, suggestionsList: [ChannelModel]) {
        suggestionsChannel.register(UINib(nibName: "SuggestionChannelTableViewCell", bundle: nil),
                             forCellWithReuseIdentifier: SuggestionChannelTableViewCell.nibName())
        suggestionsChannel.showsHorizontalScrollIndicator = false
        
        if(isFollow){
            unFollowButton.isHidden = false
            viewFollow.isHidden = true
        }else{
            unFollowButton.isHidden = true
            viewFollow.isHidden = false
        }
        
        descLabel?.text = "\(followCount) \(String.theo_doi.lowercased())"
        
        if(isShowSuggestions){
            suggestionsHeightContraint.constant = 228
            viewSuggestions.isHidden = false
            self.listSuggestionChannel = suggestionsList
            suggestionsChannel.reloadData()
        }else{
            suggestionsHeightContraint.constant = 0
            viewSuggestions.isHidden = true
        }
    }
    
    @IBAction func onClickFollowButton(_ sender: Any) {
        delegate?.channelInfoTableViewCell(self,
                                           didClickOnFollow: sender as! UIButton)
    }
    
    @IBAction func actionCloseSuggestion(_ sender: Any) {
        delegate?.channelInfoTableViewCell(self, didClickOnCloseSuggestion: sender as! UIButton)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSuggestionChannel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = listSuggestionChannel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionChannelTableViewCell.nibName(), for: indexPath) as! SuggestionChannelTableViewCell
        cell.delegate = self
        cell.bindingWithModel(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 158, height: 228)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = listSuggestionChannel[indexPath.row]
        delegate?.channelInfoTableViewCell(self, didClickGoSuggestionChannelDetail: item)
    }
    
    func suggestionTableViewCell(_ cell: SuggestionChannelTableViewCell, didTapOnFollow sender: UIButton) {
        let indexPath = suggestionsChannel.indexPath(for: cell)
        let item = listSuggestionChannel[(indexPath?.row)!]
        delegate?.channelInfoTableViewCell(self,
                                           didClickOnFollowSuggestionChannel: item )
    }

}

