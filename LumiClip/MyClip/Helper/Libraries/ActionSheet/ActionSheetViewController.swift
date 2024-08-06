//
//  ActionSheetViewController.swift
//  imuzik
//
//  Created by Os on 6/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ActionSheetViewController: ActionController
<ActionSheetCollectionViewCell, ActionData, UICollectionReusableView, ActionData, UICollectionReusableView, Void> {
    
    public override init(nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        settings.behavior.hideOnScrollDown = true
        settings.behavior.scrollEnabled = true
        settings.animation.scale = nil
        settings.animation.present.duration = 0.5
        settings.animation.dismiss.duration = 0.5
        settings.animation.dismiss.offset = 30
        settings.animation.dismiss.options = .curveLinear
        settings.statusBar.showStatusBar = true
        settings.cancelView.showCancel = true
        settings.cancelView.title = String.huy_bo
        settings.cancelView.hideCollectionViewBehindCancelView = true
        settings.cancelView.height = 54
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        cellSpec =
            .nibFile(nibName: ActionSheetCollectionViewCell.nibName(),
                     bundle: Bundle(for: ActionSheetCollectionViewCell.self),
                     height: { _  in 54 })
        onConfigureCellForAction = { cell, action, indexPath in
            cell.titleLabel.text = action.data?.title
            cell.iconImageView.image = action.data?.image
            if action.style == .cancel {
                cell.seperatorView.isHidden = true
            } else {
                cell.seperatorView.isHidden = false
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func performCustomDismissingAnimation(_ presentedView: UIView, presentingView: UIView) {
        super.performCustomDismissingAnimation(presentedView, presentingView: presentingView)
        cancelView?.frame.origin.y = view.bounds.size.height + 10
    }
    
    open override func onWillPresentView() {
        cancelView?.frame.origin.y = view.bounds.size.height
//        print("onWillPresentView: \(collectionView.frame)")
//        print("onWillPresentView: insets \(collectionView.contentInset)")
    }
    
    override func onDidPresentView() {
//        print("onDidPresentView: \(collectionView.frame)")
//        print("onDidPresentView: insets \(collectionView.contentInset)")
    }
}
