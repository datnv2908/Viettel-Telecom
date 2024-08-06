//
//  UITappableSlider.h
//  MobiTV
//
//  Created by GEM on 7/15/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define thumbImageSize 15.0f

@interface UITappableSlider : UISlider

@property (nonatomic, copy) void(^ didTapOnSlider)(UISlider * sender);

@property(strong,nonatomic) UIProgressView *bufferProgress;

- (void)setBufferValue:(CGFloat)value animated:(bool)animated;

- (void)addThumbImage;
- (void)removeThumbImge;

@end
