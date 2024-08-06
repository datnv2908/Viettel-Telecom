//
//  FilmTitleCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit


class FilmDescCollectionViewCell: BaseCollectionViewCell {
    
    var pbaseModel: PBaseRowModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        pbaseModel = model 
        guard let rowModel = pbaseModel as? FilmDetailViewModel.FilmTitleRowModel else {
            descLabel?.text = ""
            return
        }
        
        descLabel?.text = rowModel.desc
    }
    
    func bindingWithModel(_ model: PBaseRowModel, _ isExpand: Bool) {
        pbaseModel = model
        guard let rowModel = pbaseModel as? FilmDetailViewModel.FilmTitleRowModel else {
            descLabel?.text = ""
            return
        }
        
        var charactorCuttingCount: Int = 0
        if UIScreen.main.nativeBounds.width <= 640 {
             charactorCuttingCount = isIphoneApp() ? 120 : 350
        } else {
             charactorCuttingCount = isIphoneApp() ? 140 : 350
        }
        
        if !isExpand, rowModel.desc.count > charactorCuttingCount {
            let descAtt: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: AppFont.museoSanFont(style: .regular, size: 13.0)]
            let moreAtt: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: AppFont.museoSanFont(style: .bold, size: 13.0)]
            let subStr = rowModel.desc.substring(to: .init(encodedOffset: charactorCuttingCount))
            let more = NSMutableAttributedString(string: "..." + String.xem_them, attributes: moreAtt)
            let desc = NSMutableAttributedString(string: subStr, attributes: descAtt)
            desc.append(more)
            descLabel?.attributedText = desc
        } else {
            descLabel?.text = rowModel.desc
        }
    }
}

