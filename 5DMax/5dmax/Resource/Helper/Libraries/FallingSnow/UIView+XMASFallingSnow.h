@import Foundation;
@import UIKit;
@class XMASFallingSnowView;

@interface UIView (XMASFallingSnow)

@property (nonatomic, strong) XMASFallingSnowView *snowView;

- (void)makeItSnow;

- (void)makeItSnowWithFrame:(CGRect)frame;
- (void)makeItSnowWithFlakesCount:(int) flakesCount animationDurationMin:(float) animationDurationMin animationDurationMax:(float) animationDurationMax;

- (void)stopSnowing;

@end
