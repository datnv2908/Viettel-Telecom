//
//  XibView.m
//  MobiTV
//
//  Created by Huy on 5/2/16.
//  Copyright © 2016 HuyNS. All rights reserved.
//

#import "XibView.h"
#import "PureLayout.h"

@implementation XibView

-(id) init
{
    self = [super init];
    [self setup];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];    
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self awakeFromNib];
}

@end
