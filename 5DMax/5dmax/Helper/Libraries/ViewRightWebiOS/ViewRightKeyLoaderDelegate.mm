//
//  ViewRightKeyLoaderDelegate.mm
//
//  Created by Matt Messerman on 10/21/11.
//  Copyright 2015 Verimatrix. All rights reserved.
//

#import "ViewRightKeyLoaderDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <ViewRightWebiOS/ViewRightWebiOS.h>
#import "AppConstants.h"

@implementation ViewRightKeyLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    BOOL fpsOffline = [[NSUserDefaults standardUserDefaults] boolForKey:FPS_OFFLINE];
    ViewRightWebiOS::VRWebiOSError_t err = ViewRightWebiOS::Instance()->FPSKeyResourceLoader(loadingRequest,fpsOffline);
    return ViewRightWebiOS::Success == err;
}

@end
