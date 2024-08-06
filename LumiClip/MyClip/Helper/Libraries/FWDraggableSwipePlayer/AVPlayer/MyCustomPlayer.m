//
//  MyCustomPlayer.m
//  TestAVPlayer
//
//  Created by GEM on 5/4/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "MyCustomPlayer.h"
#import <PureLayout/PureLayout.h>
#import "MeuClip-Swift.h"
#import "LeftView.h"
#import "RightView.h"

#define kAnimationDuration  0.3
#define kDurationToHideContol 5
#define kTimeChangedPreview 5
#define kDurationDelayNextVideo 10.0f
#define kNumberImagesInPage 25

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
 *  m3u8 file attributes
 */
NSString *kBandwidthAttribute        = @"BANDWIDTH";
NSString *kAverageBandwidthAttribute = @"AVERAGE-BANDWIDTH";
NSString *kCodecAttribute            = @"CODECS";
NSString *kResolutionAttribute       = @"RESOLUTION";
NSString *kUrlAttribute              = @"URL";

//static const float DefaultPlayableBufferLength = 2.0f;
//static const float DefaultVolumeFadeDuration = 1.0f;
static const float TimeObserverInterval = 0.01f;
/**
 *  define observer contexts
 */
static void *VideoPlayer_IsFullScreenContext                 = &VideoPlayer_IsFullScreenContext;
static void *VideoPlayer_PlayerStateContext                  = &VideoPlayer_PlayerStateContext;
static void *VideoPlayer_PlayerCurrentItemContext            = &VideoPlayer_PlayerCurrentItemContext;
static void *VideoPlayer_PlayerItemStatusContext             = &VideoPlayer_PlayerItemStatusContext;
static void *VideoPlayer_PlayerRateChangedContext            = &VideoPlayer_PlayerRateChangedContext;
static void *VideoPlayer_PlayerItemPlaybackLikelyToKeepUp    = &VideoPlayer_PlayerItemPlaybackLikelyToKeepUp;
static void *PlayerViewControllerLoadedTimeRangesObservationContext = &PlayerViewControllerLoadedTimeRangesObservationContext;

@interface ViewPlayer : UIView
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end
@interface ViewPlayer()

@end
@implementation ViewPlayer

@dynamic layer;

- (instancetype)init {
    self = [super init];
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@end


@interface MyCustomPlayer() {
    BOOL isAnimationing;
    /**
     *  used this property to seek to correct time after change the source type of streaming video
     */
    CMTime shouldSeekToTime;

    UIGestureRecognizer *tap;
    LeftView *leftView;
    RightView *rightView;
    UITapGestureRecognizer *doubleTapRecognizer;
    NSTimer *_countdownTimer;
    
    CAShapeLayer *circle;
    
    BOOL isStopLoadNext;
    
    // for preview
    NSMutableArray *imagesPreview;
    NSString *urlPreview;
    NSInteger numberPagesPreview;
    
    ViewPlayer *viewPlayer;
    NSLayoutConstraint *bottomViewPlayer;
}

@property (nonatomic, strong) MyCustomePlayerSettingsView *viewSettings;
@end
@implementation MyCustomPlayer
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 375, 210)];
    [self setupAVPlayer];
    return self;
}

- (instancetype)initWithConfig:(MyCustomPlayerConfig *)config delegate:(id<MyCustomPlayerDelegate>)delegate {
    self = [super initWithFrame:CGRectMake(0, 0, 375, 210)];
    _delegate = delegate;
    [self setupAVPlayer];
    [self loadConfig:config];
    return self;
}

#pragma mark Observer functions
- (void)setupAVPlayer {
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOverlayTapped:)];
    [tap setDelegate:self];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
    
    viewPlayer = [[ViewPlayer alloc] init];
    
    doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (handleDoubleTapOnView:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: doubleTapRecognizer];
    [self addGestureRecognizer:doubleTapRecognizer];
    //height view header = 40
    leftView = [[LeftView alloc] init];
    leftView.frame = CGRectMake(0, 0, self.frame.size.width*2/5, self.frame.size.height);
    leftView.backgroundColor = [UIColor clearColor];
    leftView.userInteractionEnabled = NO;
    
    rightView = [[RightView alloc] init];
    rightView.backgroundColor = [UIColor clearColor];
    rightView.frame = CGRectMake(self.frame.size.width - self.frame.size.width*2/5, 0, self.frame.size.width*2/5, self.frame.size.height);
    rightView.userInteractionEnabled = NO;
    
    [self initPlayBackControlsView];
//    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingIndicator = [[ProgressView alloc] init];
    [loadingIndicator autoSetDimension:ALDimensionWidth toSize:30];
    [loadingIndicator autoSetDimension:ALDimensionHeight toSize:30];
    [self addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    [loadingIndicator autoCenterInSuperview];
    [self initSettingViews];
    _player = [[AVPlayer alloc] init];
    [self attachPlayer];
    [self addPlayerObservers];
    [self addTimeObserver];
    
    /**
     *  add seek observer
     */
    __weak typeof(self) wself = self;
    [_viewPlayBackControls.seekSlider addTarget:self action:@selector(sliderBeganTracking:) forControlEvents:UIControlEventTouchDown];
    [_viewPlayBackControls.seekSlider addTarget:self action:@selector(sliderEndedTracking:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_viewPlayBackControls.seekSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_viewPlayBackControls.seekSlider setDidTapOnSlider:^(UISlider *sender) {
        /**
         *  perform three action:
         - sliderBeganTracking
         - sliderEndedTracking
         */
        [wself sliderBeganTracking:sender];
        [wself sliderEndedTracking:sender];
    }];
    /**
     *  handle tap to show/ hide playback controls
     */
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
    shouldSeekToTime = kCMTimeInvalid;
    _playbackRate = 1.0;
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(isInFullscreen)) options:NSKeyValueObservingOptionNew context:VideoPlayer_IsFullScreenContext];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(playerState)) options:NSKeyValueObservingOptionNew context:VideoPlayer_PlayerStateContext];
    
    [self createAnimationPlayButton];
    
    _viewPlayBackControls.viewNextVideo.hidden = true;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //height header view = 40
    leftView.frame = CGRectMake(0, 0, self.frame.size.width*2/5, self.frame.size.height);
    rightView.frame = CGRectMake(self.frame.size.width - self.frame.size.width*2/5, 0, self.frame.size.width*2/5, self.frame.size.height);
    [self setUserInteractionEnabled:YES];
}

- (void)handleDoubleTapOnView:(id)sender {
    CGPoint touchPoint = [sender locationInView: self];
    [self hiddenControlsAndSettings:YES];
    
    if (touchPoint.x > self.frame.size.width/2) {
        if (self.playerState == PLAYER_STATE_FINISHED) {
            return;
        }
        CGFloat timeToBack = CMTimeGetSeconds([_player.currentItem currentTime]) + 10.0;
        [_player seekToTime:CMTimeMake(timeToBack, 1)];
        rightView.controlView.alpha = 1;
        [self performSelector:@selector(hiddenRightView) withObject:nil afterDelay:1];
    } else {
        [self showControlWhenVideoIsViewed];
        CGFloat timeToBack = CMTimeGetSeconds([_player.currentItem currentTime]) - 10.0;
        [_player seekToTime:CMTimeMake(timeToBack, 1)];
        leftView.controlView.alpha = 1;
        [self performSelector:@selector(hiddenLeftView) withObject:nil afterDelay:1];
    }
}

- (void)hiddenLeftView {
    [UIView animateWithDuration:1.0 animations:^{
        leftView.controlView.alpha = 0;
    }];
}

- (void)hiddenRightView {
    [UIView animateWithDuration:1.0 animations:^{
        rightView.controlView.alpha = 0;
    }];
}

- (void)setControls:(BOOL)controls {
    _controls = controls;
    _viewPlayBackControls.userInteractionEnabled = _controls;
}

- (void)setShouldShowControls:(BOOL)shouldShowControls {
    _shouldShowControls = shouldShowControls;
}

- (void)loadConfig:(MyCustomPlayerConfig *)config {
    _config = config;
    shouldSeekToTime = CMTimeMakeWithSeconds(config.shouldSeekToTime, NSEC_PER_SEC);
    [_viewPlayBackControls loadConfig:config];

    if (config.showTimes > 0 && config.streamStatus == 200) {
        [self startCountdownTimer];
    }

    if (_config.autostart) {
        [_player pause];
        if (_config.fileUrl) {
            [self load:_config.fileUrl];
        }
    } else {
        self.playerState = PLAYER_STATE_INVALID;
    }
    // for first time, only auto quality is available
    NSArray *qualities = [NSArray arrayWithObjects:[QualityModel defaultModel], nil] ;
    _levels = qualities;
    if (_delegate && [_delegate respondsToSelector:@selector(onLevels:)]) {
        [_delegate onLevels:qualities];
    }
    // and then extract qualities from url
    if ([config.file.lastPathComponent isEqualToString:@"m3u8"]) {
        AdaptiveService *service = [[AdaptiveService alloc] init];
        [service extractQualitiesFrom:config.file completion:^(NSArray<QualityModel *> * _Nonnull models, NSError * _Nullable error) {
            if (error == nil) {
                _levels = models;
                if (_delegate && [_delegate respondsToSelector:@selector(onLevels:)]) {
                    [_delegate onLevels:models];
                }
            }
        }];
    }
}

- (void)updatePlaybackControls:(MyCustomPlayerConfig *)config {
    _config = config;
    [_viewPlayBackControls loadConfig:_config];
}

- (void)startCountdownTimer {
    [_countdownTimer invalidate];
    __weak id wself = self;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
            [wself performCountDown];
        }];
    } else {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performCountDown) userInfo:nil repeats:true];
    }
}

- (void)stopCountdownTimer {
    [_countdownTimer invalidate];
    _countdownTimer = nil;
}

- (void)performCountDown {
    if (_config.showTimes < 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(onCompleCountdown)]) {
            [_delegate onCompleCountdown];
        }
        [self stopCountdownTimer];
        [_viewPlayBackControls updateCountdownView];
    } else {
        _config.showTimes -= 1;
        [_viewPlayBackControls updateCountdownView];
    }
}

- (void)attachPlayer {
    if (_player) {
        [self insertSubview:viewPlayer atIndex:0];
        [self addAutoLayoutWithPlayerView:viewPlayer parentView:self];
        AVPlayerLayer *playerLayer = (AVPlayerLayer*)[viewPlayer layer];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        playerLayer.needsDisplayOnBoundsChange = YES;
        [playerLayer setPlayer:_player];
    }
}

- (void)updateFramePlayer:(CGRect)frame {
    [self updateAutolayout];
}

- (void)updateAutolayout {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        if (_viewPlayBackControls) {
            [_viewPlayBackControls.seekSlider removeFromSuperview];
            [_viewPlayBackControls.viewFooter addSubview:_viewPlayBackControls.seekSlider];
            bottomViewPlayer.constant = 0.f;
            [self addAutoLayoutWithSeekSliderLandscape:_viewPlayBackControls.seekSlider];
        }
    }else {
        if (_viewPlayBackControls) {
            [_viewPlayBackControls.seekSlider removeFromSuperview];
            [_viewPlayBackControls.contentView addSubview:_viewPlayBackControls.seekSlider];
            bottomViewPlayer.constant = -kSpaceForSeek;
            [self addAutoLayoutWithSeekSliderPortrait:_viewPlayBackControls.seekSlider];
        }
    }
    [self removeThumbImageSlider];
}

- (void)addAutoLayoutWithSeekSliderLandscape:(UIView *)subView{
    if (!subView) {
        return;
    }
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:_viewPlayBackControls.lbElapsedTime
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Trailing
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:subView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:_viewPlayBackControls.lbDuration
                                    attribute:NSLayoutAttributeLeading
                                    multiplier:1.0f
                                    constant:0.f];
    
    //Center
    NSLayoutConstraint *center = [NSLayoutConstraint
                                  constraintWithItem:subView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:_viewPlayBackControls.lbElapsedTime
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0f
                                  constant:0.f];
    
    //Add constraints to the Parent
    [_viewPlayBackControls.viewFooter addConstraint:leading];
    [_viewPlayBackControls.viewFooter addConstraint:trailing];
    [_viewPlayBackControls.viewFooter addConstraint:center];
    _viewPlayBackControls.seekSlider.alpha = 1;
    self.backgroundColor = [UIColor blackColor];
}

- (void)addAutoLayoutWithSeekSliderPortrait:(UIView *)subView{
    if (!subView) {
        return;
    }
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:_viewPlayBackControls.contentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Trailing
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:subView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:_viewPlayBackControls.contentView
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.f];
    
    //Bottom
    _viewPlayBackControls.bottomSlider = [NSLayoutConstraint
                                          constraintWithItem:subView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:_viewPlayBackControls.contentView
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1.0f
                                          constant:-kSpaceForSeek];
    
    //Add constraints to the Parent
    [_viewPlayBackControls.contentView addConstraint:leading];
    [_viewPlayBackControls.contentView addConstraint:trailing];
    [_viewPlayBackControls.contentView addConstraint:_viewPlayBackControls.bottomSlider];
    self.backgroundColor = [UIColor clearColor];
}

- (void)addAutoLayoutWithPlayerView:(UIView *)subView parentView:(UIView *)parentView{
    if (!subView || !parentView) {
        return;
    }
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Trailing
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:subView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:parentView
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.f];
    
    //Top
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:subView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:parentView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    
    //Bottom
    bottomViewPlayer = [NSLayoutConstraint
                        constraintWithItem:subView
                        attribute:NSLayoutAttributeBottom
                        relatedBy:NSLayoutRelationEqual
                        toItem:parentView
                        attribute:NSLayoutAttributeBottom
                        multiplier:1.0f
                        constant:-kSpaceForSeek];
    
    //Add constraints to the Parent
    [parentView addConstraint:leading];
    [parentView addConstraint:trailing];
    [parentView addConstraint:top];
    [parentView addConstraint:bottomViewPlayer];
}

- (void)detachPlayer {
    [(AVPlayerLayer *)[viewPlayer layer] setPlayer:nil];
}

- (void)initPlayBackControlsView {
    _viewPlayBackControls = [[MyCustomPlayerOverlayView alloc] init];
    __weak typeof(self) wself = self;
    [_viewPlayBackControls setDidTapShrink:^(id sender) {
        [wself shrinkPlayer:sender];
    }];
    [_viewPlayBackControls setDidTapClose:^(id sender){
        [wself closePlayer:sender];
    }];
    [_viewPlayBackControls setDidTapSettings:^(id sender) {
        [wself showSetting:sender];
    }];
    [_viewPlayBackControls setDidAddToPlaylist:^(id sender) {
        [wself onAddToPlaylist:sender];
    }];
    [_viewPlayBackControls setDidShare:^(id sender) {
        [wself onShare:sender];
    }];
    [_viewPlayBackControls setDidTapLockScreen:^(id sender) {
        [wself onLockScreen:sender];
    }];
    [_viewPlayBackControls setDidTapVolume:^(id sender) {
        [wself onChangeVolume:sender];
    }];
    [_viewPlayBackControls setDidTapToggleLike:^(id sender) {
        [wself onToggleLike:sender];
    }];
    [_viewPlayBackControls setDidTapBack:^(id sender) {
        [wself onBack:sender];
    }];
    [_viewPlayBackControls setDidTapPlay:^(id sender) {
        [wself onPlayAttempt:sender];
    }];
    [_viewPlayBackControls setDidTapNext:^(id sender) {
        [wself onNext:sender];
    }];
    [_viewPlayBackControls setDidTapNextVideo:^(id sender) { // Next video at the end of the old video
        [wself onNextVideo:sender];
    }];
    [_viewPlayBackControls setDidTapCancelNextVideo:^(id sender) {
        [wself onCancelNextVideo:sender];
    }];
    [_viewPlayBackControls setDidTapBack:^(id sender) {
        [wself onPrevious:sender];
    }];

    [_viewPlayBackControls setDidTapToggleFullScreen:^(id sender) {
        [wself expandPlayer:sender];
    }];
    [_viewPlayBackControls setDidShowRelate:^(id sender) {
        [wself showControls];
    }];
    [_viewPlayBackControls setDidSelectRelatedItemAt:^(NSInteger index) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(selectRelatedItemAt:)]) {
            [wself.delegate selectRelatedItemAt:index];
        }
    }];
    [self addSubview:_viewPlayBackControls];
    [_viewPlayBackControls autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self updateAutolayout];
}

- (void)initSettingViews {
    _viewSettings = [[MyCustomePlayerSettingsView alloc] init];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewSettingsTapped:)];
    [_viewSettings setUserInteractionEnabled:YES];
    [_viewSettings addGestureRecognizer:tap];
    
    __weak typeof(self) wself = self;
    [_viewSettings setDidTapQualitySetting:^(id sender) {
        [wself onShowQualitySelection:sender];
    }];
    [_viewSettings setDidTapSpeedSetting:^(id sender) {
        [wself onShowSpeedSelection:sender];
    }];
    [_viewSettings setDidTapReport:^(id sender) {
        [wself onReport:sender];
    }];
    
    [self addSubview:_viewSettings];
    _viewSettings.alpha = 0;
    [self hiddenControlsAndSettings:YES];
    [_viewSettings autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self layoutIfNeeded];
}

#pragma mark - Private API
- (void)reportUnableToCreatePlayerItem:(NSError* )error {
    self.playerState = PLAYER_STATE_INVALID;
    if (_delegate && [_delegate respondsToSelector:@selector(onSetupError:)]) {
        if (error != nil) {
            [_delegate onSetupError:error];
        } else {
            NSError *error = [NSError errorWithDomain:@""
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey : @"Unable to create AVPlayerItem."}];
            [_delegate onSetupError:error];
        }
    }
}

- (void)resetPlayerItemIfNecessary {
    /**
     *  remove the player item if needed
     */
    if (_playerItem) {
        [self removePlayerItemObservers:_playerItem];
        [_player replaceCurrentItemWithPlayerItem:nil];
        _playerItem = nil;
        [self updateTimeLabel:kCMTimeZero duration:kCMTimeZero];
    }
    self.playerState = PLAYER_STATE_NEW;
}

- (void)preparePlayerItem:(AVPlayerItem *)playerItem {
    self.playerState = PLAYER_STATE_PREPARING;
    _playbackRate = 1.0;
    NSParameterAssert(playerItem);
    _playerItem = playerItem;
    
    [_playerItem addObserver:self
                  forKeyPath:@"loadedTimeRanges"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:PlayerViewControllerLoadedTimeRangesObservationContext];
    
    [self addPlayerItemObservers:playerItem];
    [_player replaceCurrentItemWithPlayerItem:playerItem];
}

#pragma mark - Player Observers

- (void)addPlayerObservers {
    [_player addObserver:self
              forKeyPath:NSStringFromSelector(@selector(currentItem))
                 options: NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                 context:VideoPlayer_PlayerCurrentItemContext];
    
    [_player addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(rate))
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:VideoPlayer_PlayerRateChangedContext];
    
    [_player addObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
}

- (void)removePlayerObservers {
    @try {
        [_player removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(currentItem))
                        context:VideoPlayer_PlayerCurrentItemContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try {
        [_player removeObserver:self
                         forKeyPath:NSStringFromSelector(@selector(rate))
                            context:VideoPlayer_PlayerRateChangedContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try {
        [_player removeObserver:self
                     forKeyPath:@"currentItem.playbackLikelyToKeepUp"
                        context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
}

#pragma mark - PlayerItem Observers

- (void)addPlayerItemObservers:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(status))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemStatusContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerFinishedPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAVPlayerAccess:)
                                                 name:AVPlayerItemNewAccessLogEntryNotification
                                               object:nil];
}

- (void)removePlayerItemObservers:(AVPlayerItem *)playerItem {
    [playerItem cancelPendingSeeks];
    @try {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(status))
                           context:VideoPlayer_PlayerItemStatusContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try {
        [playerItem removeObserver:self
                        forKeyPath:@"loadedTimeRanges"
                           context:PlayerViewControllerLoadedTimeRangesObservationContext];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewAccessLogEntryNotification object:playerItem];
}

#pragma mark - Time Observer

- (void)addTimeObserver {
    if (timeObserver || _player == nil) {
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(TimeObserverInterval, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf observerTime:time];
    }];
}

- (void)removeTimeObserver {
    if (timeObserver == nil) {
        return;
    }
    
    if (_player) {
        [_player removeTimeObserver:timeObserver];
    }
    
    timeObserver = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == VideoPlayer_PlayerCurrentItemContext) {
        
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        AVPlayerItem *oldPlayerItem = [change objectForKey:NSKeyValueChangeOldKey];
        
        /* New player item null? */
        if (newPlayerItem == (id)[NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableScrubber];
            });
        }
        else if (newPlayerItem != oldPlayerItem) { /* Replacement of player currentItem has occurred */
            dispatch_async(dispatch_get_main_queue(), ^{
                [self syncPlayPauseButtons];
                [self enableScrubber];
            });
        }
    }
    else if (context == VideoPlayer_PlayerItemPlaybackLikelyToKeepUp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_player.currentItem.isPlaybackLikelyToKeepUp) {
                [loadingIndicator stopAnimating];
                /**
                 *  play button's alpha value is the same with view header
                 */
                _viewPlayBackControls.btPlay.alpha = _viewPlayBackControls.viewHeader.alpha;
                if (_delegate && [_delegate respondsToSelector:@selector(onFinishBuffering)]) {
                    [_delegate onFinishBuffering];
                }
            } else {
                if ([self isPlaying]) {
                    [loadingIndicator startAnimating];
                    _viewPlayBackControls.btPlay.alpha = 0;
                }
                if (_delegate && [_delegate respondsToSelector:@selector(onBuffering)]) {
                    [_delegate onBuffering];
                }
            }
            if ([_playerState isEqualToString:PLAYER_STATE_PLAYING]) {
                [self resumePlayingState];
            }
        });
    }
    else if (context == VideoPlayer_PlayerItemStatusContext){
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        AVPlayerStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        if (newStatus != oldStatus) {
            switch (_player.currentItem.status) {
                case AVPlayerItemStatusUnknown:
                    [self reportUnableToCreatePlayerItem:_player.currentItem.error];
                    break;
                case AVPlayerItemStatusFailed:
                    [self reportUnableToCreatePlayerItem:_player.currentItem.error];
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    self.playerState = PLAYER_STATE_READY_TO_PLAY;
                    shouldSeekToTime = CMTimeMakeWithSeconds(_config.shouldSeekToTime, NSEC_PER_SEC);
                    if (_config.autostart) {
                        [self play];
                    }
                    if (_delegate && [_delegate respondsToSelector:@selector(onReady:)]) {
                        [_delegate onReady:0];
                    }
                    /**
                     *  make AVPlayer player sound when device is muted
                     */
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                    if ([_playerState isEqualToString:PLAYER_STATE_PLAYING]) {
                        [self resumePlayingState];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self enableScrubber];
                    });
                    
                    /**
                     *  seek to last time viewed after change the streaming's quality
                     *
                     */
                    if (_player.currentItem && CMTIME_IS_VALID([self getPlayingItemDuration]) && CMTIME_IS_VALID(shouldSeekToTime)) {
                        [_player seekToTime:shouldSeekToTime];
                    }
                    /**
                     *  set shouldSeekToTime to CMTimeInvalid after seek the current item to the last segment
                     */
                    shouldSeekToTime = kCMTimeInvalid;
                    
                    imagesPreview = [NSMutableArray new];
                    urlPreview = _config.previewImage;
                    numberPagesPreview = 0;
                    [self getImageForPreviewWithURL:urlPreview];
                    break;
            }
        }
        else if (newStatus == AVPlayerItemStatusReadyToPlay) {
            // When playback resumes after a buffering event, a new ReadyToPlay status is set [RH]
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == VideoPlayer_PlayerRateChangedContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncPlayPauseButtons];
        });
    }
    else if (context == VideoPlayer_IsFullScreenContext) {
        BOOL newStatus = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (newStatus) {
            /**
             *  full screen
             */
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [_viewPlayBackControls setFullScreen:YES multiPart:NO];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            /**
             *  not full screen
             */
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [_viewPlayBackControls setFullScreen:NO multiPart:NO];
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if (context == VideoPlayer_PlayerStateContext) {
        if ([_playerState isEqualToString:PLAYER_STATE_INVALID]) {
            [loadingIndicator stopAnimating];
            [_player pause];            
            [self showControls];
        } else if ([_playerState isEqualToString:PLAYER_STATE_NEW] || [_playerState isEqualToString:PLAYER_STATE_PREPARING]) {
            [loadingIndicator startAnimating];
            _viewPlayBackControls.btPlay.alpha = 0;
        }
        [_viewPlayBackControls updatePlayerState:_playerState];
    }else if (context == PlayerViewControllerLoadedTimeRangesObservationContext) { // buffer time AVPlayer
        NSArray *timeRanges = (NSArray*)[change objectForKey:NSKeyValueChangeNewKey];
        
        if (timeRanges && [timeRanges count]) {
            CMTimeRange timerange = [[timeRanges objectAtIndex:0]CMTimeRangeValue];
            float bufferTimeValue = (CMTimeGetSeconds(timerange.duration) + CMTimeGetSeconds(timerange.start))/CMTimeGetSeconds(_playerItem.duration);
            NSLog(@"_playerItem.preferredForwardBufferDuration: %f",bufferTimeValue);
            [_viewPlayBackControls.seekSlider setBufferValue:bufferTimeValue >.95 ? 1:bufferTimeValue animated:YES];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSURL *)urlOfCurrentlyPlayingInPlayer:(AVPlayer *)player {
    // get current asset
    AVAsset *currentPlayerAsset = player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
    // return the NSURL
    return [(AVURLAsset *)currentPlayerAsset URL];
}

- (void)onOverlayTapped:(UIGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(onMaximizeRequested)]) {
        [_delegate onMaximizeRequested];
    }
    if (self.didTapOnOverLayView) {
        self.didTapOnOverLayView(nil);
    }
    if (!_shouldShowControls || self.playerState == PLAYER_STATE_FINISHED) {
        return;
    }
    CGFloat alpha = _viewPlayBackControls.viewHeader.alpha == 0 ? 1 : 0;
    if (alpha == 1) {
        [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
    } else {
        self.viewPlayBackControls.isShowRelateVideo = false;
        [self hiddenControlsAndSettings:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.viewPlayBackControls.collectionView] || [touch.view isKindOfClass:[UISlider class]]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;        
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)syncPlayPauseButtons {
    if ([self isPlaying]) {
        _viewPlayBackControls.btPlay.selected = YES;
    } else {
        _viewPlayBackControls.btPlay.selected = NO;
    }
}

- (BOOL)isPlaying {
    return [_player rate] != 0.f;
}

-(void)showControls {
    if (isAnimationing || !_shouldShowControls) {
        return;
    }
    isAnimationing = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGFloat alpha = 1;
        
        if (_config.nextId && _config.nextId.length > 0) {
            _viewPlayBackControls.btNext.alpha = alpha;
        }else {
            _viewPlayBackControls.btNext.alpha = 0;
        }
        if (_config.previousId && _config.previousId.length > 0) {
            _viewPlayBackControls.btBack.alpha = alpha;
        }else {
            _viewPlayBackControls.btBack.alpha = 0;
        }
        
        _viewPlayBackControls.contentView.alpha = alpha;
        _viewPlayBackControls.viewHeader.alpha = alpha;
        _viewPlayBackControls.viewFooter.alpha = alpha;
        _viewPlayBackControls.collectionView.alpha = alpha;
        _viewPlayBackControls.lbElapsedTime.alpha = alpha;
        _viewPlayBackControls.lbDuration.alpha = alpha;
        _viewPlayBackControls.btExpand.alpha = alpha;
        _viewPlayBackControls.seekSlider.alpha = alpha;
        
        [_viewPlayBackControls.viewFooter setUserInteractionEnabled:YES];
        
        [self addThumbImageSlider];
        
        if (loadingIndicator.isAnimating) {
            _viewPlayBackControls.btPlay.alpha = 0;
        }else{
            _viewPlayBackControls.btPlay.alpha = alpha;
        }
        
    } completion:^(BOOL finished) {
        isAnimationing = NO;
    }];
}

-(void)showControlsAndHiddenControlsAfter:(NSTimeInterval)time {
    [self showControls];
    if(time != 0) {
        [self performSelector:@selector(hiddenControlsAndSettings:) withObject:@1 afterDelay:time];
    }
}

-(void)hiddenControlsAndSettings:(BOOL)hideSettings {
    if (hideSettings) {
        [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            [_viewSettings setAlpha:0.0];
        } completion:^(BOOL finished) {
            
        }];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControlsAndSettings:) object:nil];
    if (isAnimationing || self.playerState == PLAYER_STATE_FINISHED) {
        return;
    }
    isAnimationing = YES;
    [self hidePreview];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            CGFloat alpha = 0;
//            _viewPlayBackControls.contentView.alpha = alpha;
            _viewPlayBackControls.viewHeader.alpha = alpha;
            _viewPlayBackControls.viewFooter.alpha = alpha;
            _viewPlayBackControls.lbElapsedTime.alpha = alpha;
            _viewPlayBackControls.lbDuration.alpha = alpha;
            _viewPlayBackControls.btExpand.alpha = alpha;
            _viewPlayBackControls.btPlay.alpha = alpha;
            _viewPlayBackControls.btBack.alpha = alpha;
            _viewPlayBackControls.btNext.alpha = alpha;
            
            [_viewPlayBackControls.viewFooter setUserInteractionEnabled:NO];
            
            [self removeThumbImageSlider];
            
            if (!self.viewPlayBackControls.isShowRelateVideo) {
                self.viewPlayBackControls.collectionView.alpha = alpha;
                self.viewPlayBackControls.isShowRelateVideo = false;
                [self.viewPlayBackControls setFrameRelate];
            }
        } completion:^(BOOL finished) {
            isAnimationing = NO;
        }];
    } completion:^(BOOL finished) {  
        isAnimationing = NO;
    }];
}

#pragma mark Load New Video When Finished Playing

- (void)playerFinishedPlaying:(NSNotification *)notification {
    if (notification.object != _player.currentItem) {
        return;
    }
    self.playerState = PLAYER_STATE_FINISHED;
    [self delayNextVideoWithDuration:kDurationDelayNextVideo];
}

- (void)createAnimationPlayButton {
    // setup Circle
    CGPoint center = CGPointMake(_viewPlayBackControls.btnNextVideo.frame.size.width*0.5, _viewPlayBackControls.btnNextVideo.frame.size.height*0.5);
    CGFloat radius = _viewPlayBackControls.btnNextVideo.frame.size.width/2;
    CGFloat startAngle = 2*M_PI*0-M_PI_2;
    CGFloat endAngle = 2*M_PI*1-M_PI_2;
    circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:center
                                                 radius:radius
                                             startAngle:startAngle
                                               endAngle:endAngle
                                              clockwise:YES].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = 3.0;
    circle.hidden = true;
    
    CAShapeLayer *circlePreview = [CAShapeLayer layer];
    circlePreview.path = [UIBezierPath bezierPathWithArcCenter:center
                                                 radius:radius
                                             startAngle:startAngle
                                               endAngle:endAngle
                                              clockwise:YES].CGPath;
    circlePreview.fillColor = [UIColor clearColor].CGColor;
    circlePreview.strokeColor = [UIColor whiteColor].CGColor;
    circlePreview.lineWidth = circle.lineWidth;
    circlePreview.opacity = 0.3;
    
    [_viewPlayBackControls.btnNextVideo.layer addSublayer:circlePreview];
    [_viewPlayBackControls.btnNextVideo.layer addSublayer:circle];
    
}

- (void)delayNextVideoWithDuration:(float)duration {
    if (isStopLoadNext) {
        [self showControls];
        [self showReloadButton];
        return;
    }
    BOOL shouldPlayNextVideo = [DataManager isAutoPlayNextVideo];
    if (!shouldPlayNextVideo) {
        [self playNextVideo];
        return;
    }
    [self showControlWhenFinishVideo];
    _viewPlayBackControls.viewNextVideo.hidden = false;
    // change circle
    [circle removeAllAnimations];
    circle.hidden = false;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [circle addAnimation:animation forKey:@"drawCircleAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && !circle.isHidden) {
        NSLog(@"stop animation circle");
        circle.hidden = true;
        [self playNextVideo];
    }
}

- (void)playNextVideo {
    [loadingIndicator stopAnimating];
    _viewPlayBackControls.viewNextVideo.hidden = true;
    if (_shouldShowControls) {
        [self showControls];
    }
    [_player pause];
    [self showReloadButton];
    if (_delegate && [_delegate respondsToSelector:@selector(onComplete)]) {
        [_delegate onComplete];
    }
    self.viewPlayBackControls.isShowRelateVideo = false;
}

- (void)showControlWhenFinishVideo {
    _viewPlayBackControls.contentView.alpha = 1.0;
    _viewPlayBackControls.viewFooter.alpha = 1.0;
    _viewPlayBackControls.btPlay.alpha = 0.0;
    _viewPlayBackControls.btBack.alpha = 0.0;
    _viewPlayBackControls.btNext.alpha = 0.0;
    _viewPlayBackControls.viewHeader.alpha = 0.0;
}

- (void)showReloadButton {
    [_viewPlayBackControls.btPlay setImage:[UIImage imageNamed:@"ic_replay_circle_outline"] forState:UIControlStateNormal];
    [_viewPlayBackControls.btPlay setSelected:NO];
    seekToZeroBeforePlay = YES;
}

- (void)handleAVPlayerAccess:(NSNotification *)notif {
    AVPlayerItemAccessLog *accessLog = [((AVPlayerItem *)notif.object) accessLog];
    AVPlayerItemAccessLogEvent *lastEvent = accessLog.events.lastObject;
//    float lastEventNumber = lastEvent.indicatedBitrate;
//    float lastEventNumberOb = lastEvent.observedBitrate;
    
    //NSLog(@"ManhHX Last bitrate here %f   %f", lastEventNumber, lastEventNumberOb);
//    if (lastEventNumber != self.lastBitRate) {
//        //Here is where you can increment a variable to keep track of the number of times you switch your bit rate.
//        NSLog(@"Switch indicatedBitrate from: %f to: %f", self.lastBitRate, lastEventNumber);
//        self.lastBitRate = lastEventNumber;
//    }
}

-(void) observerTime:(CMTime) elapsedTime {
    
    if (CMTIME_IS_VALID(shouldSeekToTime)) {
        /**
         *  dont update seek slider while change streaming's quality
         */
        return;
    }
    
    Float64 duration = CMTimeGetSeconds(_player.currentItem.duration);
    if (isfinite(duration)) {
        [self updateTimeLabel:elapsedTime duration:_player.currentItem.duration];
    } else {
        [self updateTimeLabel:elapsedTime duration:kCMTimeZero];
    }
    _position = ceil(CMTimeGetSeconds(elapsedTime));
}

- (void)updateTimeLabel:(CMTime)elapsedTime duration:(CMTime)duration {
    if (CMTimeGetSeconds(duration) == CMTimeGetSeconds(kCMTimeZero)) {
        _viewPlayBackControls.lbElapsedTime.text = [self getStringFromCMTime:elapsedTime];
        _viewPlayBackControls.lbDuration.text = @"--:--";
        _viewPlayBackControls.seekSlider.value = 0.0f;
        [self disableScrubber];
    } else {
        _viewPlayBackControls.lbElapsedTime.text = [self getStringFromCMTime:elapsedTime];
        _viewPlayBackControls.lbDuration.text = [self getStringFromCMTime:duration];
        _viewPlayBackControls.seekSlider.value = CMTimeGetSeconds(elapsedTime)/ CMTimeGetSeconds(duration);
        [self enableScrubber];
    }
}

- (NSString*)getStringFromCMTime:(CMTime)time {
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}


- (void)showControlWhenVideoIsViewed {
    if (self.playerState == PLAYER_STATE_FINISHED) { //video finished
        self.playerState = PLAYER_STATE_PAUSED;
        [_viewPlayBackControls.btPlay setImage:[UIImage imageNamed:@"iconPlay"] forState:UIControlStateNormal];
        circle.hidden = true;
        _viewPlayBackControls.viewNextVideo.hidden = true;
        if (_shouldShowControls) {
            [self showControls];
        }
    }
}

#pragma mark Seek

- (void)enableScrubber {
    _viewPlayBackControls.seekSlider.enabled = YES;
}

- (void)disableScrubber {
    _viewPlayBackControls.seekSlider.enabled = NO;
}

- (void)sliderBeganTracking:(UISlider *)slider {
    [[_player currentItem] cancelPendingSeeks];
    
    // seek video when finished
    [self showControlWhenVideoIsViewed];
    
    // Fixed bug incorrect hiding control
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControlsAndSettings:) object:@1];
    [self showPreview];
    [_player pause];
}

- (void)sliderValueChanged:(UISlider *)slider {
    CMTime seekTime = CMTimeMakeWithSeconds(slider.value * (double)_player.currentItem.duration.value/(double)_player.currentItem.duration.timescale, _player.currentTime.timescale);
    [self updateTimeLabel:seekTime duration:[self getPlayingItemDuration]];
    
    // Update preview position and Image when seek
    _viewPlayBackControls.viewPreview.center = CGPointMake(slider.value*_viewPlayBackControls.seekSlider.frame.size.width, -_viewPlayBackControls.viewPreview.frame.size.height/2 - 13);
    
    [self changeImageForPreviewWithValue:slider.value];
}

- (void)sliderEndedTracking:(UISlider *)slider {
    [self hidePreview];
    // Fixed bug incorrect hiding control
    [self performSelector:@selector(hiddenControlsAndSettings:) withObject:@1 afterDelay:kDurationToHideContol];
    CMTime seekTime = CMTimeMakeWithSeconds(slider.value * (double)_player.currentItem.duration.value/(double)_player.currentItem.duration.timescale, _player.currentTime.timescale);
    [self updateTimeLabel:seekTime duration:_player.currentItem.duration];
    [self seek:CMTimeGetSeconds(seekTime)];
}

- (CMTime)getPlayingItemDuration {
    return _player.currentItem.duration;
}

- (void)addThumbImageSlider {
    [_viewPlayBackControls.seekSlider addThumbImage];
    _viewPlayBackControls.bottomSlider.constant = -(-thumbImageSize/2 + 1 + kSpaceForSeek);
    _viewPlayBackControls.seekSlider.enabled = true;
}

- (void)removeThumbImageSlider {
    [_viewPlayBackControls.seekSlider removeThumbImge];
    _viewPlayBackControls.bottomSlider.constant = -kSpaceForSeek;
    _viewPlayBackControls.seekSlider.enabled = false;
}

#pragma mark - Public API

- (void)load:(NSURL *)url {
    self.playerState = PLAYER_STATE_NEW;
    circle.hidden = true;
    isStopLoadNext = NO;
    [imagesPreview removeAllObjects];
    
    [self resetPlayerItemIfNecessary];
//    if (!file || ![[NSURL alloc] initWithString:file]) {
//        return;
//    }
//    NSURL *url = [[NSURL alloc] initWithString:file];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    if (!playerItem) {
        [self reportUnableToCreatePlayerItem:nil];
        return;
    }
    [self preparePlayerItem:playerItem];
}

- (void)loadQuality:(QualityModel *)quality {
    for (QualityModel *currentQuality in _levels) {
        if (currentQuality.isSelected && [currentQuality.name isEqualToString:quality.name]) {
            // the same quality is selected
            return;
        }
    }
    // remmember the current time of player & seek when ready to play
    if (_player.currentItem) {
        shouldSeekToTime = [_player.currentItem currentTime];
    } else {
        shouldSeekToTime = kCMTimeInvalid;
    }
    /**
     *  remove the player item if needed
     */
    if (_playerItem)
    {
        [self removePlayerItemObservers:_playerItem];
        [_player replaceCurrentItemWithPlayerItem:nil];
        _playerItem = nil;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:quality.url];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    if (!playerItem) {
        [self reportUnableToCreatePlayerItem:nil];
        return;
    }
    
    [self disableScrubber];
    NSMutableArray *newLevels = [NSMutableArray arrayWithArray:_levels];
    for (QualityModel *item in newLevels) {
        if ([item.name isEqualToString:quality.name]) {
            item.isSelected = YES;
        } else {
            item.isSelected = NO;
        }
    }
    _levels = newLevels;
    [self preparePlayerItem:playerItem];
}

#pragma mark - Preview Images

- (void)changeImageForPreviewWithValue:(float)sliderValue {
    _viewPlayBackControls.viewPreview.hidden = NO;
    if (imagesPreview.count == 0) {
        _viewPlayBackControls.viewPreview.hidden = YES;
        return;
    }
    _viewPlayBackControls.lbTimePreView.text = _viewPlayBackControls.lbElapsedTime.text;
    NSInteger durationPlayer = CMTimeGetSeconds(_player.currentItem.duration);
    NSInteger requiredImages = durationPlayer/kTimeChangedPreview;
    NSInteger indexImagePreview = sliderValue*requiredImages;
    if (indexImagePreview < imagesPreview.count) {
        _viewPlayBackControls.viewPreview.image = imagesPreview[indexImagePreview];
    }else {
        _viewPlayBackControls.viewPreview.image = nil;
    }
}

- (NSInteger)pageNumberToLoad {
    NSInteger durationPlayer = CMTimeGetSeconds([self getPlayingItemDuration]);
    if (durationPlayer < 1) {
        NSString *durationStr = _config.duration;
        NSArray *dateComponent = [durationStr componentsSeparatedByString:@":"];
        if (dateComponent.count == 1) {
            durationPlayer = [dateComponent[0] integerValue];
        }else if (dateComponent.count == 2) {
            durationPlayer = [dateComponent[0] integerValue]*60 + [dateComponent[1] integerValue];
        }else if ((dateComponent.count == 3)) {
            durationPlayer = [dateComponent[0] integerValue]*60*60 + [dateComponent[1] integerValue]*60 + [dateComponent[2] integerValue];
        }
    }
    NSInteger requiredImages = durationPlayer%kTimeChangedPreview > 0 ? ((durationPlayer/kTimeChangedPreview)+1) : durationPlayer/kTimeChangedPreview;
    NSInteger requiredPages = requiredImages%kNumberImagesInPage > 0 ? ((requiredImages/kNumberImagesInPage)+1) : requiredImages/kNumberImagesInPage;
    
    return requiredPages;
}

- (BOOL)checkConditionToLoad:(NSString *)url { // Check the condition to load new page
    if (!url || [url isEqualToString:@""]) { // check URL empty
        return false;
    }
    if (numberPagesPreview == [self pageNumberToLoad]) { // check number pages need for video
        return false;
    }
    
    return true;
}

- (void)getImageForPreviewWithURL:(NSString *)urlStr {
    if (![self checkConditionToLoad:urlStr]) {
        return;
    }
    
    urlPreview = [self newURLPreviewWithURL:urlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr]
                                                              options:SDWebImageDownloaderUseNSURLCache
                                                             progress:nil
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                NSArray *images = [image splitImageWithSizeItem:sizePreviewImage emptySpaceItem:1];
                [imagesPreview addObjectsFromArray:images];
                numberPagesPreview ++;
                [self getImageForPreviewWithURL:urlPreview];
            }else {
                NSLog(@"No preview available");
            }
        }];
    });
}

- (NSString *)newURLPreviewWithURL:(NSString *)oldURL { // get new URL for page - string
    NSArray *foo = [oldURL componentsSeparatedByString:@"/"];
    NSInteger lengthURL = oldURL.length;
    NSString *lastObject = foo.lastObject;
    NSString *numberPage = [oldURL substringWithRange:NSMakeRange(lengthURL-(lastObject.length-1), 3)];
    NSString *urlTemp = [oldURL substringWithRange:NSMakeRange(0, lengthURL-(lastObject.length-1))];
    int nextPagePreview = numberPage.intValue + 1;
    
    NSArray *foo2 = [oldURL componentsSeparatedByString:@"."];
    NSString *typeImage = foo2.lastObject;
    NSString *newURL = @"";
    if (nextPagePreview < 10) {
        newURL = [NSString stringWithFormat:@"%@00%d.%@",urlTemp, nextPagePreview, typeImage];
    }else if (nextPagePreview < 100) {
        newURL = [NSString stringWithFormat:@"%@0%d.%@",urlTemp, nextPagePreview, typeImage];
    }else {
        newURL = [NSString stringWithFormat:@"%@%d.%@",urlTemp, nextPagePreview, typeImage];
    }
    
    return newURL;
}

- (void)showPreview {
    NSLog(@"show preview");
    _viewPlayBackControls.viewPreview.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _viewPlayBackControls.viewPreview.alpha = 1;
    }];
}

- (void)hidePreview {
    NSLog(@"hide preview");
    [UIView animateWithDuration:0.5 animations:^{
        _viewPlayBackControls.viewPreview.alpha = 0;
    } completion:^(BOOL finished) {
        _viewPlayBackControls.viewPreview.hidden = YES;
    }];
}



#pragma mark - Playback
- (void)resumePlayingState {
    [_player play];
    [_player setRate:_playbackRate];
}

- (void)play {
    [_viewPlayBackControls.btPlay setImage:[UIImage imageNamed:@"iconPlay"] forState:UIControlStateNormal];
    if (_player.currentItem == nil) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(onPlay:)]) {
        [_delegate onPlay:_playerState];
    }
    self.playerState = PLAYER_STATE_PLAYING;
    if ([_player.currentItem status] == AVPlayerItemStatusReadyToPlay) {
        if (seekToZeroBeforePlay) {
            [self restart];
            seekToZeroBeforePlay = NO;
        }
        else {
            [self resumePlayingState];
        }
    }
}

- (void)pause {
    if (_delegate && [_delegate respondsToSelector:@selector(onPause:)]) {
        [_delegate onPause:_playerState];
    }
    self.playerState = PLAYER_STATE_PAUSED;
    [_player pause];
}

- (void)togglePlayPause {
    if (_playerState == PLAYER_STATE_INVALID) {
        if (_config.fileUrl) {
            [self load:_config.fileUrl];
        }
    } else {
        [self onPlay:nil];
    }
}

- (void)seek:(NSInteger)position {
    if (isSeeking) {
        return;
    }
    
    if (_player) {
        CMTime cmTime = CMTimeMakeWithSeconds(position, _player.currentTime.timescale);
        if (CMTIME_IS_INVALID(cmTime) || _player.currentItem.status != AVPlayerStatusReadyToPlay) {
            shouldSeekToTime = cmTime;
            return;
        }
        isSeeking = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(onSeek:fromPosition:)]) {
            [_delegate onSeek:position fromPosition:CMTimeGetSeconds(_player.currentTime)];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_player seekToTime:cmTime completionHandler:^(BOOL finished) {
                if ([_playerState isEqualToString:PLAYER_STATE_PLAYING]) {
                    [self resumePlayingState];
                }
                seekToZeroBeforePlay = NO;
                isSeeking = NO;
                if (_delegate && [_delegate respondsToSelector:@selector(onSeeked)]) {
                    [_delegate onSeeked];
                }
            }];
        });
    }
}

- (void)stop {
    [self pause];
    [self resetPlayerItemIfNecessary];
}

- (void)restart {
    [_player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            seekToZeroBeforePlay = NO;
            if ([_playerState isEqualToString:PLAYER_STATE_PLAYING]) {
                [self resumePlayingState];
            }
        }
    }];
}

#pragma mark IBAction
- (void)closePlayer:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCloseRequested)]) {
        [self.delegate onCloseRequested];
    }
    if (self.didTapOnCloseButton) {
        self.didTapOnCloseButton(sender);
    }
}

- (void)shrinkPlayer:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onMinimizeRequested)]) {
        [_delegate onMinimizeRequested];
    }
    if (self.didTapOnShrinkButton) {
        self.didTapOnShrinkButton(sender);
    }
}

- (void)showSetting:(id)sender {
    [self hiddenControlsAndSettings:NO];
    
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        _viewSettings.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)onLockScreen:(id)sender {
    if (self.didTapLockScreen) {
        self.didTapLockScreen(sender);
    }
}

- (void)onAddToPlaylist:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onAddToPlaylist)]) {
        [_delegate onAddToPlaylist];
    }
}

- (void)onShare:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onShare)]) {
        [_delegate onShare];
    }
}

- (void)onChangeVolume:(id)sender {
    if (_player.volume != 0) {
        _player.volume = 0;
        [sender setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    } else {
        _player.volume = 1;
        [sender setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    }
}

- (void)onToggleLike:(id)sender {
}

- (void)onBack:(id)sender {
}

- (void)onPlayAttempt:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onPlayAttempt)]) {
        [_delegate onPlayAttempt];
    } else {
        if (_config.autostart) {
            [self onPlay:sender];
        }
    }
}

- (void)onPlay:(id)sender {
    BOOL isPlaying = [self isPlaying];
    if (isPlaying) {
        [self pause];
    }else{
        [self play];
    }
    [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
}

- (void)onPrevious:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onPrevious)]) {
        [_delegate onPrevious];
    }
}

- (void)onNext:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onNext)]) {
        [_delegate onNext];
    }
}

- (void)onNextVideo:(id)sender {
    if (self.playerState == PLAYER_STATE_FINISHED) {
        circle.hidden = true;
        [self playNextVideo];
        [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
    }
}

- (void)onCancelNextVideo:(id)sender {
    circle.hidden = true;
    isStopLoadNext = YES;
    
    _viewPlayBackControls.viewNextVideo.hidden = true;
    if (_shouldShowControls) {
        [self showControls];
    }
    [self showReloadButton];
}


- (void)expandPlayer:(id)sender {
    
    Boolean status = !_isInFullscreen;
    if (_delegate && [_delegate respondsToSelector:@selector(onFullscreenRequested:)]) {
        [_delegate onFullscreenRequested:status];
    }
    if (self.didTapOnToggleFullScreen) {
        self.didTapOnToggleFullScreen(sender);
    }
}

/**
 *  view settings actions
 */
#pragma mark view settings actions
- (void)onShowQualitySelection:(id)sender {
    [self onViewSettingsTapped:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(onRequestToShowQualitySettings)]) {
        [_delegate onRequestToShowQualitySettings];
    }
}

- (void)onShowSpeedSelection:(id)sender {
    [self onViewSettingsTapped:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(onRequestToShowSpeedSettings)]) {
        [_delegate onRequestToShowSpeedSettings];
    }
}

- (void)onReport:(id)sender {
    [self onViewSettingsTapped:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(onRequestToShowReport)]) {
        [_delegate onRequestToShowReport];
    }
}

- (void)onViewSettingsTapped:(id)sender {
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [_viewSettings setAlpha:0.0];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark view selection actions
- (void)setPlaybackRate:(CGFloat)playbackRate {
    _playbackRate = playbackRate;
    if (_player.rate == playbackRate) {
        return;
    }
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [_viewSettings setAlpha:0.0];
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_player setRate:playbackRate];
        });
    }];
}

- (BOOL)isReadyToPlay {
    if ([_playerState isEqualToString:PLAYER_STATE_READY_TO_PLAY] ||
        [_playerState isEqualToString:PLAYER_STATE_PLAYING] ||
        [_playerState isEqualToString:PLAYER_STATE_PAUSED] ||
        [_playerState isEqualToString:PLAYER_STATE_FINISHED]) {
        return true;
    } else {
        return false;
    }
}

- (double)currentTime {
    if (_playerItem && CMTIME_IS_VALID(_playerItem.currentTime)) {
        return CMTimeGetSeconds(_playerItem.currentTime);
    } else {
        return 0;
    }
}

- (AVPlayer*) getPlayer{
    return _player;
}

-(AVPlayerItem *)getCurPlayerItem{
    return _playerItem;
}

#pragma mark dealloc
-(void) dealloc {
    NSLog(@"MyCustomPlayer dealloc");
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    [self resetPlayerItemIfNecessary];
    [self removePlayerObservers];
    [self removeTimeObserver];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(isInFullscreen)) context:VideoPlayer_IsFullScreenContext];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(playerState)) context:VideoPlayer_PlayerStateContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
