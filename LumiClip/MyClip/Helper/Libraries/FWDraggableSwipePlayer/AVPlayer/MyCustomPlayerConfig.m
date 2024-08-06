//
//  MyCustomPlayerConfig.m
//  MyClip
//
//  Created by hnc on 10/2/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import "MyCustomPlayerConfig.h"

@implementation MyCustomPlayerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controls = YES;
        _repeat = NO;
        _shouldSeekToTime = 0;
        _autoPlayNext = YES;
        _playbackRate = 1.0;
        _streamStatus = 403;
        _isCasting = NO;
    }
    return self;
}

- (BOOL)autostart {
    if (_streamStatus == 200 && _showTimes <= 0 && _isCasting == false) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)shouldShowCountdown {
    if (_streamStatus == 200 && _showTimes > 0) {
        return true;
    } else {
        return false;
    }
}

- (NSURL *)fileUrl {
    if (_localFilePath.length == 0 && _file.length == 0) {
        return  nil;
    } else if (_localFilePath && _localFilePath.length > 0) {
        return [NSURL fileURLWithPath:_localFilePath];
    } else if (_file && _file.length > 0) {
        return  [NSURL URLWithString:_file];
    } else {
        return nil;
    }
}
@end
