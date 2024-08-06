//
//  MyCustomPlayerOverlayView.m
//  MobiTV
//
//  Created by GEM on 7/7/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "MyCustomPlayerOverlayView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyCustomPlayerState.h"
#import "MeuClip-Swift.h"
#import "RelateVideoCollectionViewCell.h"
#import <DateToolsSwift/DateToolsSwift-Swift.h>
#import <GoogleCast/GoogleCast.h>

@interface MyCustomPlayerOverlayView() {
    CGFloat firstX, firstY;
    BOOL isFullScreen;
    CGRect contentFrame;
}
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation MyCustomPlayerOverlayView

-(void) awakeFromNib {
    [super awakeFromNib];
    _viewHeader.gradientOrientation = GRKGradientOrientationUp;
    _viewHeader.gradientColors = [NSArray arrayWithObjects:[UIColor clearColor], [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.67], nil];
    
    _viewFooter.gradientOrientation = GRKGradientOrientationUp;
    _viewFooter.gradientColors = [NSArray arrayWithObjects:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.67], [UIColor clearColor], nil];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognize:)];
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGesture];
    _isShowRelateVideo = false;
    isFullScreen = false;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RelateVideoCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"RelateVideoCollectionViewCell"];

    contentFrame = _countdownContentView.frame;
    
    _lbCountDown.text = NSLocalizedString(@"chuong_trinh_se_bat_dau_sau", @"");
    _lbUpNext.text = NSLocalizedString(@"tiep_theo", @"");
    [_btnCancelNextVideo setTitle:NSLocalizedString(@"huy", @"") forState:UIControlStateNormal];
    
    [self createViewPreview];
}

- (void)createViewPreview {
    _viewPreview = [[UIImageView alloc] initWithFrame:CGRectMake(-sizePreviewImage.width/2, -sizePreviewImage.height, sizePreviewImage.width, sizePreviewImage.height)];
    _viewPreview.backgroundColor = UIColor.blackColor;
    _viewPreview.hidden = YES;
    _viewPreview.alpha = 0;
    
    _lbTimePreView = [[UILabel alloc] initWithFrame:CGRectMake(0, sizePreviewImage.height-30, sizePreviewImage.width, 30)];
    _lbTimePreView.font = _lbElapsedTime.font;
    _lbTimePreView.textColor = UIColor.whiteColor;
    _lbTimePreView.textAlignment = NSTextAlignmentCenter;
    
    [_viewPreview addSubview:_lbTimePreView];
    
    [_seekSlider insertSubview:_viewPreview atIndex:0];
}

- (void)layoutSubviews {
    CGFloat originalWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = self.frame.size.width;
    CGFloat changePercent = width / originalWidth + 0.1;
    _countdownContentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, changePercent, changePercent);
    _castDeviceNameLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, changePercent, changePercent);
}

- (void)panGestureRecognize:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        firstX = sender.view.center.x;
        firstY = [sender velocityInView:self.view].y;
        firstY = [sender locationInView:self.view].y;
    }
    
    translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y+translatedPoint.y);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat deltaY = ABS(firstY - [sender locationInView:self.view].y);
        if (deltaY > 20) {
            CGFloat velocityX = (0.2*[sender velocityInView:self.view].x);
            CGFloat velocityY = (0.2*[sender velocityInView:self.view].y);
            
            CGFloat finalX = 0;
            CGFloat finalY = translatedPoint.y + velocityY;
            
            CGRect viewFrame = self.view.frame;
            CGFloat maxY = viewFrame.size.height - self.collectionView.frame.size.height;
            if (isFullScreen) {
                if (finalY < maxY) { // to avoid status bar
                    finalY = maxY;
                    _isShowRelateVideo = false;
                    self.collectionView.alpha = 1;
                    self.isShowRelateVideo = true;
                    if (self.didShowRelate) {
                        self.didShowRelate(sender);
                    }
                } else {
                    finalY = viewFrame.size.height - 25;
                    _isShowRelateVideo = true;
                    self.isShowRelateVideo = false;
                    [UIView animateWithDuration:0.3 animations:^{
                    } completion:^(BOOL finished) {
                    }];
                }
            }
            
            CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
            
            NSLog(@"the duration is: %f", animationDuration);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            
            [_collectionView setFrame:CGRectMake(finalX, finalY, viewFrame.size.width, 135)];
            [UIView commitAnimations];
        }
    }
}

-(void)setFrameRelate {
    if(isFullScreen) {
        if (_isShowRelateVideo) {
            CGRect viewFrame = self.view.frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [_collectionView setFrame:CGRectMake(0,
                                                 viewFrame.size.height - self.collectionView.frame.size.height,
                                                 viewFrame.size.width,
                                                 135)];
            [UIView commitAnimations];
        } else {
            CGRect viewFrame = self.view.frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [_collectionView setFrame:CGRectMake(0, viewFrame.size.height - 25, viewFrame.size.width, 135)];
            [UIView commitAnimations];
        }
    }
}

-(void) setFullScreen:(BOOL) fullScreen multiPart:(BOOL) multiPart {
    [self.collectionView reloadData];
    if (fullScreen) {
        _lbName.alpha = 1;
        [_btnLockScreen setHidden:NO];
        _btnLockWidth.constant = 40;
        self.btExpand.selected = YES;
        self.btShrink.alpha = 0;
        self.btShrinkCountDown.alpha = 0;
        self.btShrinkChromecast.alpha = 0;
        self.collectionView.hidden = NO;
        isFullScreen = true;
        self.gradientFooterHeightConstraint.constant = 53;
    } else {
        self.lbName.alpha = 0;
        [_btnLockScreen setHidden:YES];
        _btnLockWidth.constant = 0;
        self.btExpand.selected = NO;
        self.btShrink.alpha = 1;
        self.btShrinkCountDown.alpha = 1;
        self.btShrinkChromecast.alpha = 1;
        isFullScreen = false;
        self.collectionView.hidden = YES;
        self.gradientFooterHeightConstraint.constant = 40;
    }
}

- (IBAction)shrinkPlayer:(id)sender {
    if (self.didTapShrink) {
        self.didTapShrink(sender);
    }
}

- (IBAction)onClose:(id)sender {
    if (self.didTapClose) {
        self.didTapClose(sender);
    }
}

- (IBAction)showSetting:(id)sender {
    if (self.didTapSettings) {
        self.didTapSettings(sender);
    }
}

- (IBAction)addToPlaylistClicked:(id)sender {
    if (self.didAddToPlaylist) {
        self.didAddToPlaylist(sender);
    }
}
- (IBAction)onShare:(id)sender {
    if (self.didShare) {
        self.didShare(sender);
    }
}

- (IBAction)onLockScreen:(id)sender {
    if (self.didTapLockScreen) {
        self.didTapLockScreen(sender);
    }
}

- (IBAction)onShowVolume:(id)sender {
    if (self.didTapVolume) {
        self.didTapVolume(sender);
    }
}


- (IBAction)onToggleLike:(id)sender {
    if (self.didTapToggleLike) {
        self.didTapToggleLike(sender);
    }
}

- (IBAction)onBack:(id)sender {
    if (self.didTapBack) {
        self.didTapBack(sender);
    }
}

- (IBAction)onPlay:(id)sender {
    if (self.didTapPlay) {
        self.didTapPlay(sender);
    }
}

- (IBAction)onNext:(id)sender {
    if (self.didTapNext) {
        self.didTapNext(sender);
    }
}

// Next video at the end of the old video
- (IBAction)onNextVideo:(id)sender {
    if (self.didTapNextVideo) {
        self.didTapNextVideo(sender);
    }
}

- (IBAction)onCanceNextVideo:(id)sender {
    if (self.didTapCancelNextVideo) {
        self.didTapCancelNextVideo(sender);
    }
}

- (IBAction)expandPlayer:(id)sender {
    if (self.didTapToggleFullScreen) {
        self.didTapToggleFullScreen(sender);
    }
}

- (void)updatePlayerState:(NSString *)state {
    if ([state isEqualToString:PLAYER_STATE_NEW] || [state isEqualToString:PLAYER_STATE_INVALID]) {
        [_coverImageView setHidden:false];
    } else {
        [_coverImageView setHidden:true];
    }
}

- (void)loadConfig:(MyCustomPlayerConfig *)config {
    _config = config;
    _lbName.text = config.title;
    if (config.nextId && config.nextId.length > 0) {
        _btNext.alpha = _viewHeader.alpha;
    } else {
        _btNext.alpha = 0;
    }
    if (config.previousId && config.previousId.length > 0) {
        _btBack.alpha = _btNext.alpha;
    } else {
        _btBack.alpha = 0;
    }
    [self updateCountdownView];
    [self updateChromeCastView];
    [self updateDataNextView];
    if (!config.image || ![[NSURL alloc] initWithString:config.image]) {
        return;
    }
    NSURL *imageUrl = [[NSURL alloc] initWithString:config.image];
    if (imageUrl != nil) {
        [_coverImageView sd_setImageWithURL:imageUrl];
    }
    [_collectionView reloadData];
}

- (void)updateDataNextView {
    if (!_config.nextId) {
        return;
    }
    NSArray *playlists = @[];
    _lbNextVideoName.text = @"";
    _lbNextChannelName.text = @"";
    if (_config.playlistSections.count > 0) {
        playlists = _config.playlistSections.copy;
    }else {
        playlists = _config.related.copy;
    }
    for (ContentModel *content in playlists) {
        if (content.id.intValue == _config.nextId.intValue) {
            _lbNextVideoName.text = content.fullName;
            _lbNextChannelName.text = @""/*content.fullUserName*/;
        }
    }
}

- (void)updateCountdownView {
    // check if stream status is okay & show_times > 0
    if (_config.streamStatus == 200 && _config.showTimes > 0) {
        [_countdownView setHidden:FALSE];
    } else {
        [_countdownView setHidden:TRUE];
    }
    [self updateCountdown:_config.showTimes];
}

- (void)updateChromeCastView {
    NSLog(@"updateChromeCastView: %d", _config.isCasting ? 1 : 0);
    if (_config.isCasting) {
        [_chromeCastOverlayView setHidden:false];
    } else {
        [_chromeCastOverlayView setHidden:true];
    }
    NSString *deviceName = [[[GoogleChromcastHelper shareInstance] castSession] device].friendlyName;
    deviceName = deviceName ? deviceName : @"TV";
    _castDeviceNameLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"dang_phat_tren", @""), deviceName];
}

- (void)updateCountdown:(double) showTimes {
    double dayToSeconds = 86400;
    double hourToSeconds = 3600;
    double minuteToSeconds = 60;

    NSInteger dayRemaining = showTimes / dayToSeconds;
    NSInteger hourRemaining = (showTimes - dayRemaining*dayToSeconds)/hourToSeconds;
    NSInteger minuteRemaining = (showTimes - dayRemaining*dayToSeconds - hourRemaining*hourToSeconds)/minuteToSeconds;
    NSInteger secondRemaining = showTimes - dayRemaining*dayToSeconds - hourRemaining*hourToSeconds - minuteRemaining*minuteToSeconds;

    _dayLabel.text = [NSString stringWithFormat:@"%0*ld",2, (long)dayRemaining];
    _hourLabel.text = [NSString stringWithFormat:@"%0*ld",2, (long)hourRemaining];
    _minuteLabel.text = [NSString stringWithFormat:@"%0*ld",2, (long)minuteRemaining];
    _secondLabel.text = [NSString stringWithFormat:@"%0*ld",2, (long)secondRemaining];
}

#pragma mark - collectionView delegate, datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.config.related.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RelateVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RelateVideoCollectionViewCell" forIndexPath:indexPath];
    ContentModel *model = self.config.related[indexPath.row];
    cell.titleLabel.text = model.name;
    NSURL *imageUrl = [NSURL URLWithString:model.coverImage];
    cell.durationLabel.text = model.duration;
    [cell.coverImageView sd_setImageWithURL:imageUrl placeholderImage: [UIImage imageNamed:@"placeholder_video"]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(191, 110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectRelatedItemAt(indexPath.row);
    self.isShowRelateVideo = false;
    [self setFrameRelate];
}
@end
