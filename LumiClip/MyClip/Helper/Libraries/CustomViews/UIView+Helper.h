//
//  UIView+Helper.h
//  MobiTV
//
//  Created by GEM on 6/20/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)

- (void)startSpinWithDuration:(CGFloat) duration;
- (void)stopSpin;
-(CGRect)originalFrame ;
@end
