//
//  ProgressView.m
//  MyClip
//
//  Created by hnc on 10/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import "ProgressView.h"
#import "UIView+Helper.m"

@implementation ProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    ringImageView = [[UIImageView alloc] init];
    ringImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (_ringImage) {
        ringImageView.image = _ringImage;
    } else {
        ringImageView.image = [UIImage imageNamed:@"icon_loading"];
    }
    [self addSubview:ringImageView];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    ringImageView.frame = self.bounds;
}

- (void)startAnimating {
    _isAnimating = true;
    [self setHidden:false];
    [ringImageView startSpinWithDuration:2.0];
}

- (void)stopAnimating {
    _isAnimating = false;
    [self setHidden:true];
    [ringImageView stopSpin];
}

@end
