//
//  FWDraggableManager.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FWSwipePlayerBackgroundView.h"
#import "MyCustomPlayer.h"

#import "FWSwipePlayerConfig.h"
@class FWDraggableManager;
@protocol FWDraggableManagerDelegate <NSObject>
@optional
- (void)player:(MyCustomPlayer *)player finishedVerticalSwipe:(BOOL) isSmall;
@end

extern NSString *FWSwipePlayerViewStateChange;
extern NSString *FWShouldExitPlayer;
extern NSString *FWDidExitPlayer;
extern NSString *FWDidExitPlayerBySwipe;
extern NSString *FWPlayerCanRotate;

@class MovieDetailView;

typedef enum _FWSwipeState {
    FWSwipeNone = 0,
    FWSwipeUp = 1,
    FWSwipeDown = 2,
    FWSwipeLeft = 3,
    FWSwipeRight = 4
} FWSwipeState;

@interface FWDraggableManager : NSObject<UIGestureRecognizerDelegate>
@property (nonatomic, assign) FWSwipeState swipeState;
@property (nonatomic, readonly) BOOL isInFullMode; // isInFullMode when showing detail view && not isSmall
@property (nonatomic, weak) id<FWDraggableManagerDelegate> delegate;

- (id)initWithConfiguration:(FWSwipePlayerConfig *) config;

- (void)showAtController:(UIViewController *)controller;
- (void)setBottomMargin:(CGFloat) bottomMargin;
- (void)exit;
- (void)showAtView:(UIView *)view;
- (void)setDetailViewController:(UIViewController *)viewController;
- (void)minimizePlayerView;
- (void)maximizePlayerView;
@end
