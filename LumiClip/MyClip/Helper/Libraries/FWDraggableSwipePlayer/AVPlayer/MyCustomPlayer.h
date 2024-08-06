//
//  MyCustomPlayer.h
//  TestAVPlayer
//
//  Created by GEM on 5/4/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MyCustomPlayerOverlayView.h"
#import "MyCustomePlayerSettingsView.h"
#import "MyCustomPlayerDelegate.h"
#import "MyCustomPlayerConfig.h"
#import "MyCustomPlayerState.h"
#import "ProgressView.h"

#define kSpaceForSeek 8.0

@import SDWebImage;

@class MyCustomPlayer;

@interface MyCustomPlayer : UIView <UIGestureRecognizerDelegate, CAAnimationDelegate>{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    
    id timeObserver;
    BOOL isSeeking;
    BOOL seekToZeroBeforePlay;

    /// view over lay
//    UIActivityIndicatorView *loadingIndicator;
    ProgressView *loadingIndicator;
}

@property (nonatomic, weak) id<MyCustomPlayerDelegate> delegate;
@property (nonatomic, retain) NSString *playerState;

/*!
 MyCustomPlayerConfig object that was used to setup the player.
 */
@property (nonatomic, retain, readonly) MyCustomPlayerConfig *config;
/*!
 Enable the built-in controls by setting them true, disable the controls by setting them false.
 */

@property (nonatomic, assign) BOOL controls;
@property (nonatomic, assign) BOOL shouldShowControls;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, strong) MyCustomPlayerOverlayView *viewPlayBackControls;
- (instancetype)initWithConfig:(MyCustomPlayerConfig *)config delegate:(id<MyCustomPlayerDelegate>)delegate;

/*!
 Starts to play video from current position.
 */
- (void)play;

/*!
 Pauses video.
 */
- (void)pause;

- (void)togglePlayPause;

/*!
 Stops the player (returning it to the idle state) and unloads the currently playing media file.
 */
- (void)stop;

- (void)restart;
/*!
 @param position Time in the video to seek to
 @see duration
 */
- (void)seek:(NSInteger)position;

/*!
 Duration of the current video. Becomes available shortly after the video starts to play as a part of metadata.
 */
@property (nonatomic, readonly) double duration;

/*!
 Position of the current video in second.
 */
@property (nonatomic, readonly) double position;

/*!
 The rate at which media is being reproduced.
 @discussion Setting this property to 1.0 will play the media at its natural rate. Ability to set a different value is limited to the rates supported by the media item; if an unsupported rate is requested, playbackRate will not change. Rates between 0.0 and 1.0 will slow forward, rates greater than 1.0 will fast forward, rates between 0.0 and -1.0 will slow reverse, and rates lower than -1.0 will fast reverse. This property will have no effect when ads are being played, or when casting. Cannot be set to 0; to pause playback, please call the pause method.
 */
@property (nonatomic) CGFloat playbackRate;

/* ========================================*/
/** @name Managing Full Screen / Picture in Picture */

/*!
 A Boolean value that determines whether the video is in full screen.
 */
@property (nonatomic, assign) BOOL isInFullscreen;

@property (nonatomic, readonly) BOOL isReadyToPlay;

@property (nonatomic, readonly) double currentTime;

@property (nonatomic, readonly) double watchedTime;
/*!
 Loads a new file into the player.
 @param fileUrl Video URL to play using Player.
 */
- (void)load:(NSURL *)fileUrl;

- (void)loadQuality:(id)quality;
/*!
 Loads a new MyCustomPlayerConfig object into the player.
 @param config COnfiguration object.
 */
- (void)loadConfig:(MyCustomPlayerConfig *)config;
- (void)updatePlaybackControls:(MyCustomPlayerConfig *)config;
- (void)hiddenControlsAndSettings:(BOOL) hideSettings;
/**
 *  Draggable Manager methods and properties
 */

- (void)updateFramePlayer:(CGRect)frame;

@property (nonatomic, copy) void (^ didTapOnCloseButton) (id sender);
@property (nonatomic, copy) void (^ didTapOnShrinkButton) (id sender);
@property (nonatomic, copy) void (^ didTapOnToggleFullScreen) (id sender);
@property (nonatomic, copy) void (^ didTapOnOverLayView) (id sender);
@property (nonatomic, copy) void (^ didTapLockScreen) (id sender);

-(AVPlayer*) getPlayer;
-(AVPlayerItem*) getCurPlayerItem;
@end

