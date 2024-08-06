//
//  MyCustomPlayerOverlayView.h
//  MobiTV
//
//  Created by GEM on 7/7/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "XibView.h"
#import "UITappableSlider.h"
#import <GRKGradientView/GRKGradientView.h>
#import "MyCustomPlayerConfig.h"

#define sizePreviewImage CGSizeMake(160.0, 90.0)

@interface MyCustomPlayerOverlayView : XibView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak)  IBOutlet GRKGradientView *viewHeader;
@property (nonatomic, weak)  IBOutlet GRKGradientView *viewFooter;
/// play back control
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic, weak)  IBOutlet UIButton *btBack;
@property (nonatomic, weak)  IBOutlet UIButton *btPlay;
@property (nonatomic, weak)  IBOutlet UIButton *btNext;
@property (nonatomic, weak)  IBOutlet UIButton *btLive;

@property (nonatomic, weak)  IBOutlet UILabel *lbElapsedTime;
@property (nonatomic, weak)  IBOutlet UILabel *lbDuration;
@property (nonatomic, weak)  IBOutlet UITappableSlider *seekSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSlider;
/// action buttons
@property (nonatomic, weak)  IBOutlet UIButton *btClose;
@property (nonatomic, weak)  IBOutlet UIButton *btShrink;
@property (nonatomic, weak)  IBOutlet UIButton *btShrinkCountDown;
@property (nonatomic, weak)  IBOutlet UIButton *btSettings;
@property (nonatomic, weak)  IBOutlet UIButton *btExpand;
@property (weak, nonatomic) IBOutlet UIButton *btAddToPlaylist;
@property (weak, nonatomic) IBOutlet UIButton *btShare;

@property (nonatomic, weak) IBOutlet UILabel *lbName;
@property (nonatomic, weak) IBOutlet UIButton *btnLockScreen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLockWidth;
@property (nonatomic, weak) IBOutlet UIButton *btLike;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientFooterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientFooterHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnVolume;
@property (weak, nonatomic) IBOutlet UIView *countdownView;
@property (weak, nonatomic) IBOutlet UIView *countdownContentView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UIView *chromeCastOverlayView;
@property (weak, nonatomic) IBOutlet UIButton *btShrinkChromecast;
@property (weak, nonatomic) IBOutlet UILabel *castDeviceNameLabel;


// For finish video
@property (weak, nonatomic) IBOutlet UIView *viewNextVideo;
@property (weak, nonatomic) IBOutlet UILabel *lbUpNext;
@property (weak, nonatomic) IBOutlet UILabel *lbNextVideoName;
@property (weak, nonatomic) IBOutlet UILabel *lbNextChannelName;
@property (weak, nonatomic) IBOutlet UIButton *btnNextVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelNextVideo;

@property (strong, nonatomic) UIImageView *viewPreview;
@property (strong, nonatomic) UILabel *lbTimePreView;
    
// Count down
@property (weak, nonatomic) IBOutlet UILabel *lbCountDown;

@property MyCustomPlayerConfig *config;
@property BOOL isShowRelateVideo;

-(void) setFullScreen:(BOOL) fullScreen multiPart:(BOOL) multiPart;

@property (nonatomic, copy) void (^ didTapClose)(id sender);
@property (nonatomic, copy) void (^ didTapShrink)(id sender);
@property (nonatomic, copy) void (^ didTapSettings)(id sender);
@property (nonatomic, copy) void (^ didAddToPlaylist)(id sender);
@property (nonatomic, copy) void (^ didShare)(id sender);
@property (nonatomic, copy) void (^ didTapLockScreen)(id sender);
@property (nonatomic, copy) void (^ didTapVolume)(id sender);
@property (nonatomic, copy) void (^ didTapToggleLike)(id sender);
@property (nonatomic, copy) void (^ didTapBack)(id sender);
@property (nonatomic, copy) void (^ didTapPlay)(id sender);
@property (nonatomic, copy) void (^ didTapNext)(id sender);
@property (nonatomic, copy) void (^ didTapToggleFullScreen)(id sender);
@property (nonatomic, copy) void (^ didSelectRelatedItemAt)(NSInteger index);
@property (nonatomic, copy) void (^ didShowRelate)(id sender);
@property (nonatomic, copy) void (^ didTapCancelNextVideo)(id sender);

// Next video at the end of the old video
@property (nonatomic, copy) void (^ didTapNextVideo)(id sender);
- (void)updatePlayerState:(NSString *)state;
- (void)loadConfig:(MyCustomPlayerConfig *)config;
- (void)updatePlaybackControls:(MyCustomPlayerConfig *)config;
- (void)updateCountdownView;
- (void)setFrameRelate;
@end
