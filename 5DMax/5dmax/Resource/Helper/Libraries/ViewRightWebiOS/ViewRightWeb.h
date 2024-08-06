//
//  ViewRightWeb.h
//  5dmax
//
//  Created by Huy Nguyen on 7/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewRightKeyLoaderDelegate.h"

@protocol ViewRightWebDelegate <NSObject>

- (void)showFingerPrinting:(NSString *_Nullable) global withData:(NSString *_Nullable) data withDataSize:(int) dataSize;

@end

@interface ViewRightWeb : NSObject

@property (nonatomic, weak, nullable) id<ViewRightWebDelegate> delegate;

+ (BOOL)isDevicePrivisoned;
+ (BOOL)provisionDevice;
+ (void)forceProvisionDevice; // force provision device
+ (nonnull NSString *)getDeviceIdentifier;
- (nullable NSURL *)translateMovieUrl:(NSString *_Nonnull)movieUrl;

@end
