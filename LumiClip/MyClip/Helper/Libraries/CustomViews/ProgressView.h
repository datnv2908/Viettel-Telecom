//
//  ProgressView.h
//  MyClip
//
//  Created by hnc on 10/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ProgressView : UIView {
    UIImageView *ringImageView;
}
IBInspectable
@property (nonatomic, strong) UIImage *ringImage;
@property (nonatomic, readonly) BOOL isAnimating;
- (void)startAnimating;
- (void)stopAnimating;
@end
