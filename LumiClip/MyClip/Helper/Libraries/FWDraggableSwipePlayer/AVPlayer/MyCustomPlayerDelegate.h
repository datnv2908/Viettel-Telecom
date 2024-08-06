//
//  MyCustomPlayerDelegate.h
//  MyClip
//
//  Created by hnc on 10/2/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyCustomPlayerDelegate <NSObject>
@optional
/*!
 onPlayAttempt(callback)
 @discussion Useful for QOE tracking - Triggered the instant a user attempts to play a file. This event fires before both the onPlay and onBeforePlay events.
 */
- (void)onPlayAttempt;

/*!
 onBeforePlay(callback)
 @discussion Fired just before the player begins playing. Unlike the onPlay event, the player will not have begun playing or buffering when triggered, which makes this the right moment to insert preroll ads using playAd().
 */
- (void)onBeforePlay;

/*!
 onPlay(callback)
 @discussion Fired when the player enters the 'playing' state.
 */
- (void)onPlay:(NSString *)oldState;

- (void)onBuffering;

- (void)onFinishBuffering;
/*!
 onPause(callback)
 @discussion Fired when the player enters the 'paused' state.
 */
- (void)onPause:(NSString *)oldState;

/*!
 onReady(callback)
 @discussion Fired when the player has initialized in either Flash or HTML5 and is ready for playback.
 */
- (void)onReady:(NSInteger)setupTime;

/*!
 onComplete(callback)
 @discussion Fired when an item completes playback.
 */
- (void)onComplete;

- (void)onCompleCountdown;

- (void)onNext;
    
- (void)onPrevious;

/*!
 onAddToPlaylist(callback)
 @discussion Fired when an item AddToPlaylist.
 */
- (void)onAddToPlaylist;

/*!
 onShare(callback)
 @discussion Fired when an item share video.
 */
- (void)onShare;
    
/*!
 onSeek(callback)
 @discussion Fired after a seek has been requested either by scrubbing the controlbar or through the API.
 @param offset  The user requested position to seek to (in seconds). Note the actual position the player will eventually seek to may differ.
 @param position The position of the player before the player seeks (in seconds).
 */
- (void)onSeek:(double)offset fromPosition:(double)position;

/*!
 onSeeked(callback)
 @discussion Triggered when content playback resumes after seeking. As opposed to onSeek, this API listener will only trigger when playback actually continues.
 */
- (void)onSeeked;

/*!
 onLevels(callback)
 @discussion Fired when the list of available quality levels is updated. Happens e.g. shortly after a playlist item starts playing.
 @param levels The full array of quality levels.
 */
- (void)onLevels:(NSArray *)levels;

/*!
 onLevelsChanged(callback)
 @discussion Fired when the active quality level is changed. Happens in response to e.g. a user clicking the controlbar quality menu or a script calling setCurrentLevel.
 @param currentLevel Index of the new quality level in the getQualityLevels() array.
 */
- (void)onLevelsChanged:(NSInteger)currentLevel;

/*!
 onFullscreen
 @discussion Fired when the player toggles to/from fullscreen. Preceded by a onFullscreenRequested callback.
 @param status Whether or not video is in fullscreen mode.
 */
- (void)onFullscreen:(BOOL)status;

/*!
 onFullscreenRequested
 @discussion Fired when a request to toggle fullscreen is received by the player. Precedes a onFullscreen callback when successful.
 @param status Whether request is to enter/exit fullscreen mode.
 */
- (void)onFullscreenRequested:(BOOL)status;
/*
 *  when a request to turn player into mini player is received
 */

- (void)onMinimizeRequested;

/*
 *  when player is minized completed
 */
- (void)onMinimized;

- (void)onMaximizeRequested;

- (void)onMaximized;

- (void)onCloseRequested;

- (void)onRequestToShowQualitySettings;

- (void)onRequestToShowSpeedSettings;

- (void)onRequestToShowReport;
/*!
 onControls
 @discussion Fired when controls are enabled or disabled by setting.
 @param status New state of the controls. Is true when the controls were just enabled.
 */
- (void)onControls:(BOOL)status;

/*!
 onControlBarVisible
 @discussion Fired when player control bar appears/disappears. Would not be called if controls set to false.
 @discussion Especially useful for synchronizing custom controls visibility with player control bar.
 @param isVisible Current control bar visibility status.
 */
- (void)onControlBarVisible:(BOOL)isVisible;

/* ========================================*/
/** @name Error */

/*!
 onError(callback)
 @discussion Fired when a media error has occurred, causing the player to stop playback and go into 'idle' mode.
 @param error Object containing the reason for the error in property localizedDescription.
 */
- (void)onError:(NSError *)error;

/*!
 onSetupError(callback)
 @discussion Fired when neither the Flash nor HTML5 player could be setup.
 @param error Object containing the error message that describes why the player could not be setup. Error message can be accessed in property localizedDescription.
 */
- (void)onSetupError:(NSError *)error;

- (void)selectRelatedItemAt:(NSInteger)index;
@end
