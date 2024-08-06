//
//  UITappableSlider.m
//  MobiTV
//
//  Created by GEM on 7/15/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "UITappableSlider.h"

@implementation UITappableSlider

- (id)init
{
    self = [super init];
    [self setupGesture];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (void)setup {
    [self setupGesture];
    
    self.bufferProgress = [[UIProgressView alloc] initWithFrame:self.bounds];
    self.minimumTrackTintColor = self.tintColor;
    self.maximumTrackTintColor = [UIColor clearColor];
    self.value = 0.0;
    self.bufferProgress.backgroundColor = [UIColor clearColor];
    self.bufferProgress.userInteractionEnabled = NO;
    self.bufferProgress.progress = 0.0;
    self.bufferProgress.progressTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0];
    self.bufferProgress.trackTintColor = [[UIColor darkGrayColor] colorWithAlphaComponent:2];
    [self addSubview:self.bufferProgress];
    [self addThumbImage];
    self.bufferProgress.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.bufferProgress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.bufferProgress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.75];  // edit the constant value based on the thumb image
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.bufferProgress attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    [self addConstraints:@[left,right,centerY]];
    [self sendSubviewToBack:self.bufferProgress];
}

- (void)setupGesture {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self addGestureRecognizer:gr];
//    [self setThumbImage:[UIImage imageNamed:@"slider_image"] forState:UIControlStateNormal];
}

- (void)setBufferValue:(CGFloat)value animated:(bool)animated {
    [_bufferProgress setProgress:value animated:animated];
}

- (void)addThumbImage {
    UIImage *image = [self blueCircle];
    [self setThumbImage:image forState:UIControlStateNormal];
}

- (void)removeThumbImge {
    UIImage *image = [self clearCircle];
    [self setThumbImage:image forState:UIControlStateNormal];
}

- (UIImage *)blueCircle {
    static UIImage *blueCircle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(thumbImageSize, thumbImageSize), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, thumbImageSize, thumbImageSize);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor);
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        blueCircle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return blueCircle;
}

- (UIImage *)clearCircle {
    static UIImage *clearCircle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(0.01f, 0.01f), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, 0.01f, 0.01f);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        clearCircle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return clearCircle;
}

- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    
    if (self.didTapOnSlider) {
        self.didTapOnSlider (s);
    }
}
@end
