//
//  FilmInfoCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol FilmInfoCollectionViewCellDelegate: NSObjectProtocol {
    func cellDisSelectAddToWatchLater()
}

class FilmInfoCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    weak var delegate: FilmInfoCollectionViewCellDelegate?
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        
        textButton.setTitle(String.xem_sau, for: .normal)
        downloadLabel.text = String.tai_ve
        
        let rowModel = model as! FilmDetailViewModel.FilmInfoRowModel
        
       
        if rowModel.actor.isEmpty == false {
            actorLabel.attributedText = self.transferToAttributedString(string: rowModel.actor, header: String.dien_vien + ": ")
        } else {
            actorLabel.text = nil
        }
        
        categoryLabel.attributedText = self.transferToAttributedString(string: rowModel.category, header: String.the_loai + ": ")
        if rowModel.category == String.the_loai +  ": " {
            categoryLabel.attributedText = nil
        } else {
            categoryLabel.attributedText = self.transferToAttributedString(string: rowModel.category, header: String.the_loai + ": ")
        }
        
        if rowModel.nation.isEmpty == false {
            countryLabel.attributedText = self.transferToAttributedString(string: rowModel.nation, header: String.quoc_gia + ": ")
        } else {
            actorLabel.text = String.country + ": "
        }
        // Todo: Add Author
        if rowModel.directors.isEmpty == false {
            directorsLabel.attributedText = self.transferToAttributedString(string: rowModel.directors, header: String.directors + ": ")
        } else {
            directorsLabel.text = nil
        }
        
        if rowModel.isFavourite == true {
            plusButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            plusButton.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        }
        contentView.autoresizingMask = .flexibleWidth
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
    }
    
    func transferToAttributedString(string: String, header: String) -> NSAttributedString {
        let headerLength = (header as NSString).length
        let stringLength = (string as NSString).length
        let grayColor = [NSAttributedString.Key.foregroundColor: AppColor.warmGrey()]
        let whiteColor = [NSAttributedString.Key.foregroundColor: AppColor.warmGrey()]

        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttributes(grayColor, range: NSRange(location: 0, length: headerLength))
        attrString.addAttributes(whiteColor, range: NSRange(location: headerLength,
                                                            length: stringLength - headerLength))

        return attrString
    }
    
    @IBAction func addtoWatchLater(_ sender: Any) {
        delegate?.cellDisSelectAddToWatchLater()
    }
    
    @IBAction func addtoDownload(_ sender: Any) {
        DLog("Tải về")
    }
}
