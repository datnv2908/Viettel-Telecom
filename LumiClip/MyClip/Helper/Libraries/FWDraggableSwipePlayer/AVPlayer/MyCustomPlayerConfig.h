//
//  MyCustomPlayerConfig.h
//  MyClip
//
//  Created by hnc on 10/2/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCustomPlayerConfig : NSObject
/*!
 Video URL to play using MyCustom Player.
 */
@property (nonatomic, retain) NSString *file;

/*
 Local file path of the downloaded video
 */
@property (nonatomic, retain) NSString *localFilePath;

@property (nonatomic, retain, readonly)  NSURL * _Nullable fileUrl;
/*!
 An array of MyCustomSource objects representing multiple quality levels of a video.
 @see MyCustomSource
 */
@property (nonatomic, retain) NSArray *sources;

/*!
 An array of MyCustomPlaylistItem objects containing information about different video items to be reproduced in a sequence.
 @see MyCustomPlaylistItem
 */
@property (nonatomic, retain) NSArray *related;


/*!
 An array of MyCustomPlaylistItem objects containing information about different video items to be reproduced in a sequence.
 @see MyCustomPlaylistItem
 */
@property (nonatomic, retain) NSArray *playlist;

/*!
 An array of MyCustomPlaylistItem contains my playlists.
 @see MyCustomPlaylistItem
 */
@property (nonatomic, retain) NSArray *playlistSections;

/*!
 Title of the video
 @discussion Shown in the play button container in the center of the screen, before the video starts to play.
 */
@property (nonatomic, retain) NSString *title;

/*!
 The URL of the thumbnail image.
 */
@property (nonatomic, retain) NSString *image;

/*!
 The URL of the preview image.
 */
@property (nonatomic, retain) NSString *previewImage;

/*!
 The duration video.
 */
@property (nonatomic, retain) NSString *duration;

/*!
 A dictionary containing asset initialization options.
 */
@property (nonatomic) NSDictionary * _Nullable assetOptions;

/*!
 A boolean value that determines whether player controls are shown.
 */
@property (nonatomic) BOOL controls;

/*!
 A boolean value that determines whether video should repeat after it's done playing.
 */
@property (nonatomic) BOOL repeat;

/*!
 A boolean value that determines whether video should start automatically after loading.
 */
@property (nonatomic, readonly) BOOL autostart;
@property (nonatomic, readonly) BOOL shouldShowCountdown;
@property (nonatomic, assign) BOOL isCasting;
/*!
A boolean value that determines whether video should start next view after completed.
*/
@property (nonatomic) BOOL autoPlayNext;

@property (nonatomic) double shouldSeekToTime;

@property (nonatomic) double playbackRate;
    
@property (nonatomic, strong) NSString * _Nullable nextId;
@property (nonatomic, strong) NSString * _Nullable previousId;

@property (nonatomic) NSInteger streamStatus;
@property (nonatomic) double showTimes;
@end
