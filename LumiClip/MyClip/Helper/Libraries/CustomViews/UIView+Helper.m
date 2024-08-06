//
//  UIView+Helper.m
//  MobiTV
//
//  Created by GEM on 6/20/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)startSpinWithDuration:(CGFloat) duration
{
    if ([self.layer animationForKey:@"SpinAnimation"] == nil)
    {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = duration;
        animation.repeatCount = INFINITY;
        animation.removedOnCompletion = false;
        [self.layer addAnimation:animation forKey:@"SpinAnimation"];
    }
}
- (void)stopSpin
{
    [self.layer removeAnimationForKey:@"SpinAnimation"];
}
// helper to get pre transform frame
-(CGRect)originalFrame {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    
    return originalFrame;
}

// helper to get point offset from center
-(CGPoint)centerOffset:(CGPoint)thePoint {
    return CGPointMake(thePoint.x - self.center.x, thePoint.y - self.center.y);
}
// helper to get point back relative to center
-(CGPoint)pointRelativeToCenter:(CGPoint)thePoint {
    return CGPointMake(thePoint.x + self.center.x, thePoint.y + self.center.y);
}
// helper to get point relative to transformed coords
-(CGPoint)newPointInView:(CGPoint)thePoint {
    // get offset from center
    CGPoint offset = [self centerOffset:thePoint];
    // get transformed point
    CGPoint transformedPoint = CGPointApplyAffineTransform(offset, self.transform);
    // make relative to center
    return [self pointRelativeToCenter:transformedPoint];
}

// now get your corners
-(CGPoint)newTopLeft {
    CGRect frame = [self originalFrame];
    return [self newPointInView:frame.origin];
}
-(CGPoint)newTopRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return [self newPointInView:point];
}
-(CGPoint)newBottomLeft {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.y += frame.size.height;
    return [self newPointInView:point];
}
-(CGPoint)newBottomRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return [self newPointInView:point];
}
@end
