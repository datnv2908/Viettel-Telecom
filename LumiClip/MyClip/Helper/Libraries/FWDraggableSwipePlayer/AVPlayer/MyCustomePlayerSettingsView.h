//
//  MyCustomePlayerSettingsView.h
//  MobiTV
//
//  Created by GEM on 5/25/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XibView.h"

@interface MyCustomePlayerSettingsView : XibView

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
    
@property (nonatomic, copy) void (^ didTapQualitySetting) (id sender);
@property (nonatomic, copy) void (^ didTapSpeedSetting) (id sender);
@property (nonatomic, copy) void (^ didTapReport) (id sender);

- (IBAction)onQualitySetting:(id)sender;
- (IBAction)onSpeedSetting:(id)sender;
- (IBAction)onReport:(id)sender;

@end
