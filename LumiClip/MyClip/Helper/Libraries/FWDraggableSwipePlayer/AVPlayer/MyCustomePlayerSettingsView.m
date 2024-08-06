//
//  MyCustomePlayerSettingsView.m
//  MobiTV
//
//  Created by GEM on 5/25/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "MeuClip-Swift.h"
#import "MyCustomePlayerSettingsView.h"

@implementation MyCustomePlayerSettingsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
    
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.qualityLabel.text = NSLocalizedString(@"chat_luong", @"");
    self.speedLabel.text = NSLocalizedString(@"toc_do", @"");
    self.reportLabel.text = NSLocalizedString(@"bao_cao", @"");
}

- (IBAction)onQualitySetting:(id)sender {
    if (self.didTapQualitySetting) {
        self.didTapQualitySetting(sender);
    }
}

- (IBAction)onSpeedSetting:(id)sender {
    if (self.didTapSpeedSetting) {
        self.didTapSpeedSetting(sender);
    }
}

- (IBAction)onReport:(id)sender {
    if (self.didTapReport) {
        self.didTapReport(sender);
    }
}
@end
