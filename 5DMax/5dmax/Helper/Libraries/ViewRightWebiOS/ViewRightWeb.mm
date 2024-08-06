//
//  ViewRightWeb.m
//  5dmax
//
//  Created by Huy Nguyen on 7/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import "AppConstants.h"
#import "ViewRightWeb.h"
#import "VCASUtilities.h"
#import "ViewRightKeyLoaderDelegate.h"

@interface ViewRightWeb() <VRSecurityCallback>

@end

@implementation ViewRightWeb


+ (BOOL)isDevicePrivisoned {
    ViewRightWebiOS::VRWebiOSError_t err = ViewRightWebiOS::Success;
    err = ViewRightWebiOS::Instance()->IsDeviceProvisioned();
    if (err == ViewRightWebiOS::Success) {
        return true;
    } else {
        return false;
    }
}

+ (BOOL)provisionDevice {
    [VCASUtilities initialize];
    ViewRightWebiOS::VRWebiOSError_t ret = ViewRightWebiOS::Instance()->SetVdisPrefix("DRM_VTP_I_");
    if (ret == ViewRightWebiOS::Success) {
        NSLog(@"Set vdis prefix successful");
    }
    else {
        NSLog(@"Set vdis prefix error %d", ret);
    }
    ret = [VCASUtilities provisionDevice];
    if (ret == ViewRightWebiOS::Success) {
        NSLog(@"Provision successful");
        return YES;
    } else {
        NSLog(@"Provision error %d", ret);
        return NO;
    }
}

+ (void)forceProvisionDevice {
    [VCASUtilities forceProvisionDevice];
}

+ (nonnull NSString *)getDeviceIdentifier {
    return [VCASUtilities getDeviceIdentifier];
}

- (nullable NSURL *)translateMovieUrl:(NSString *_Nonnull)movieUrl {
    ViewRightWebiOS::Instance()->Close();
    if (ViewRightWebiOS::Instance()->Initialize()) {
        char * tempString;
        bool ret;
        const char *chrMovie = [movieUrl cStringUsingEncoding:NSASCIIStringEncoding];
        ViewRightWebiOS::Instance()->SetSecurityCallbackDelegate(self);
        ret = ViewRightWebiOS::Instance()->Open(chrMovie,&tempString);
        if (ret == false)
        {
            NSLog(@"problem starting server");
            return nil;
        }
        NSString * translatedString = [[NSString alloc] initWithCString:tempString encoding:NSUTF8StringEncoding];
        free( tempString );
        NSURL * movieURL = [NSURL URLWithString:translatedString];
        return movieURL;
    } else {
        // do nothing
        return nil;
    }
}

- (void) securityCallback {
    NSLog(@"error: Security error encountered - stopping playback");
    ViewRightWebiOS::Instance()->Close();
}

- (void) ConfigureOutputControlSettings:(struct OutputControls) settings
{
    NSLog(@"ConfigureOutputControlSettings: BestEffort_Enabled:%s", settings.BestEffort_Enabled ? "YES" : "NO");
    NSLog(@"ConfigureOutputControlSettings: ccACP_Level:%d", settings.ccACP_Level);
    NSLog(@"ConfigureOutputControlSettings: DwightCavendish_Enabled:%s", settings.DwightCavendish_Enabled ? "YES" : "NO");
    NSLog(@"ConfigureOutputControlSettings: HDCP_Enabled:%s", settings.HDCP_Enabled ? "YES" : "NO");
    std::string ccCGMS_A_Level = "";
    switch(settings.ccCGMS_A_Level)
    {
        case 0:
            ccCGMS_A_Level = "FREELY";
            break;
        case 1:
            ccCGMS_A_Level = "NO MORE";
            break;
        case 2:
            ccCGMS_A_Level = "ONCE";
            break;
        default:
            ccCGMS_A_Level = "NEVER";
    }
    NSLog(@"ConfigureOutputControlSettings: ccCGMS_A_Level:%s", ccCGMS_A_Level.data());
    NSLog(@"ConfigureOutputControlSettings: CIT_Analog_Enabled:%s", settings.CIT_Analog_Enabled ? "YES" : "NO");
    NSLog(@"ConfigureOutputControlSettings: CIT_Digital_Enabled:%s", settings.CIT_Digital_Enabled ? "YES" : "NO");
    NSLog(@"ConfigureOutputControlSettings: DOT_Enabled:%s", settings.DOT_Enabled ? "YES" : "NO");
    NSLog(@"ConfigureOutputControlSettings: Anti_Mirroring_Enabled:%s", settings.Anti_Mirroring_Enabled ? "YES" : "NO");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFingerPrinting" object:nil userInfo:nil];
}

- (void) OperatorData:(struct OperatorDataStruct) data
{
    NSLog(@"OperatorData: %s", data.bGlobal ? "Global" : "Asset-Specific");
    NSString *bGlobal = [NSString stringWithFormat:@"%s", data.bGlobal ? "Global" : "Asset-Specific"];
    NSLog(@"OperatorData: %d bytes", data.dataSize);
    NSString *bDataSize = [NSString stringWithFormat:@"%d", data.dataSize];
    NSLog(@"OperatorData: %s", data.data);
    NSString *bData = [NSString stringWithFormat:@"%s", data.data];
    if ([_delegate respondsToSelector:@selector(showFingerPrinting:withData:withDataSize:)]) {
        [_delegate showFingerPrinting:bGlobal withData:bData withDataSize:[bDataSize intValue]];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFingerPrinting" object:@{@"bGlobal": bGlobal, @"bDataSize": bDataSize, @"bData": bData}];
}

- (void)dealloc {
    ViewRightWebiOS::Instance()->SetSecurityCallbackDelegate(nil);
    ViewRightWebiOS::Instance()->ResetStream(0);
    ViewRightWebiOS::Instance()->Close();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
