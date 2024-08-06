//
//  AZBarButtonItem.swift
//  MyClip
//
//  Created by hnc on 10/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class AZBarButtonItem: UIView {
    open var button: UIButton
    open var icon: UIImageView
    open var titleLabel: UILabel
    open var normalImage: UIImage?
    open var selectedImage: UIImage?
    open var normalColor: UIColor = UIColor.black
    open var selectedColor = UIColor.blue
    open var normalFont = UIFont.systemFont(ofSize: 13)
    open var selectedFont = UIFont.systemFont(ofSize: 13)
    open var isSelected: Bool = false {
        didSet {
            if (isSelected) {
                icon.image = selectedImage
                titleLabel.textColor = selectedColor
                titleLabel.font = selectedFont
            } else {
                icon.image = normalImage
                titleLabel.textColor = normalColor
                titleLabel.font = normalFont
            }
        }
    }
    override init(frame: CGRect) {
        button = UIButton(type: .custom)
        titleLabel = UILabel()
        icon = UIImageView()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let holderView = UIView()
        addSubview(holderView)
        holderView.addSubview(icon)
        addSubview(titleLabel)
        addSubview(button)
        holderView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(titleLabel.snp.top).offset(0)
        }
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        icon.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-4)
        }
    }
}
