//
//  FWDraggableManager.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWDraggableManager.h"
#import "UIApplication+AppDimensions.h"
#import "MeuClip-Swift.h"
#define ANIMATION_TIME 0.2f

NSString *FWSwipePlayerViewStateChange = @"FWSwipePlayerViewStateChange";
NSString *FWShouldExitPlayer = @"FWShouldExitPlayer";
NSString *FWDidExitPlayer = @"FWDidExitPlayer";
NSString *FWDidExitPlayerBySwipe = @"FWDidExitPlayerBySwipe";
NSString *FWPlayerCanRotate = @"FWPlayerCanRotate";

@interface FWDraggableManager() {
    FWSwipePlayerConfig *config;
    UIView* rootView;
    
    UIPanGestureRecognizer *dragRecognizer;
    
    BOOL isAnimation;
    BOOL isVertical;
    BOOL isHorizontal;
    BOOL isLock;
    BOOL isPanGesture;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
}
@property (nonatomic) BOOL isSmall;
@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic, strong) VideoDetailViewController *detailViewController;
@end
@implementation FWDraggableManager

- (id)init {
    self = [super init];
    if (self) {
        self.swipeState = FWSwipeNone;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            _bottomMargin = window.safeAreaInsets.bottom;
        } else {
            _bottomMargin = 0;
        }
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] ;
        [dragRecognizer setMinimumNumberOfTouches:1];
        [dragRecognizer setMaximumNumberOfTouches:1];
        [dragRecognizer setDelegate:self];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
        
        [self addObserver:self
               forKeyPath:NSStringFromSelector(@selector(isSmall))
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:nil];
    }
    
    return self;
}

- (BOOL)isInFullMode {
    if (!_detailViewController || _isSmall == true) {
        return false;
    } else {
        return true;
    }
}

- (void)setDetailViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass: VideoDetailViewController.class]) {
        _detailViewController = viewController;
    }
}

- (id)initWithConfiguration:(FWSwipePlayerConfig *) configuration {
    self = [self init];
    if (self) {
        config = configuration;
    }
    return self;
}

- (void)initConfig {
    [self configPlayer];
    [self configSetting];
}

- (void)configPlayer {
    if(config.draggable) {
        [self.detailViewController.myPlayer addGestureRecognizer:dragRecognizer];
    }
    __weak typeof(self) wself = self;
    [self.detailViewController.myPlayer setDidTapOnCloseButton:^(id sender) {
        [wself closeDetailView];
    }];
    [self.detailViewController.btnClose addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    [self.detailViewController.myPlayer setDidTapOnShrinkButton:^(id sender) {
        [wself minimizePlayerView];
    }];
    [self.detailViewController.miniPlayerControl setUserInteractionEnabled:YES];
    [self.detailViewController.miniPlayerControl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maximizePlayerView)]];
    [self.detailViewController.myPlayer setDidTapOnToggleFullScreen:^(id sender) {
        [wself toggleFullScreen:sender];
    }];
    [self.detailViewController.myPlayer setDidTapOnOverLayView:^(id sender) {
        [wself maximizePlayerView];
    }];
    [self.detailViewController.myPlayer setDidTapLockScreen:^(id sender) {
        [wself lockScreenBtnOnClick:sender];
    }];
    [self.detailViewController.myPlayer setBackgroundColor:[UIColor clearColor]];
}

- (void)configSetting {
    self.isSmall = NO;
    isLock = NO;
    isAnimation = NO;
    isVertical = NO;
    isHorizontal = NO;
}

#pragma mark Observer
- (void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isSmall))]) {
        [self.detailViewController.myPlayer setShouldShowControls:!_isSmall];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Show methods
- (void)showAtView:(UIView *)view {
    /**
     *  add new one
     */
    rootView = view;
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = kCATransitionFromBottom; //choose your animation
    [self.detailViewController.view.layer addAnimation:transition forKey:nil];
    [view addSubview:self.detailViewController.view];
    
    [self initConfig];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]], FWPlayerCanRotate, nil]];
    [self setStatusBarHidden:YES];
}

- (void)showAtController:(UIViewController *)controller {
    [controller addChildViewController:self.detailViewController];
    [self showAtView:controller.view];
    [self.detailViewController didMoveToParentViewController:controller];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)move:(id)sender {
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    CGPoint location = [sender locationInView:panGesture.view];
    CGRect panRect = CGRectMake(0, 0, panGesture.view.bounds.size.width, panGesture.view.bounds.size.height-30);
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(panRect, location)) {
            isPanGesture = YES;
        }else {
            isPanGesture = NO;
        }
    }
    
    if (isPanGesture) {
        // point is in specified area
        CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.detailViewController.view];
        [self.detailViewController.myPlayer hiddenControlsAndSettings:YES];
        if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
            if(!isAnimation) {
                [self updateSwipeState:translatedPoint];
                [self updateEndingMovingFrame];
            }
        } else {
            if(!isAnimation) {
                [self updateMovingSwipeState:translatedPoint];
                [self updateMovingFrame:translatedPoint];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]],FWPlayerCanRotate, nil]];
    }
}

- (void)updateMovingSwipeState:(CGPoint)translatedPoint {
    if(!_isSmall && translatedPoint.y > 0 && !isHorizontal) {
        isVertical = YES;
        self.swipeState = FWSwipeDown;
    } else if(_isSmall) {
        if(translatedPoint.y < 0 && !isHorizontal) {
            isVertical = YES;
            self.swipeState = FWSwipeUp;
        }
        else if(translatedPoint.x > 15 && translatedPoint.x > 0 && !isVertical) {
            isHorizontal = YES;
            self.swipeState = FWSwipeRight;
        }
        else if(translatedPoint.x < -15 && translatedPoint.x < 0 && !isVertical) {
            isHorizontal = YES;
            self.swipeState = FWSwipeLeft;
        }
        else
            self.swipeState = FWSwipeNone;
    }
    else
        self.swipeState = FWSwipeNone;
}

- (void)updateMovingFrame:(CGPoint)translatedPoint {
    switch (self.swipeState) {
        case FWSwipeDown:
        case FWSwipeUp:
            [self movingSwipeVertical:translatedPoint];
            break;
        case FWSwipeRight:
        case FWSwipeLeft:
            [self movingSwipeHorizontal:translatedPoint];
            break;
        default:
            break;
    }
}

- (void)movingSwipeVertical:(CGPoint)translatedPoint {
    
    [self setStatusBarHidden:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    float HeightPre = translatedPoint.y / (config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin) + ((self.swipeState == FWSwipeDown) ? 0: 1);
    if (HeightPre <= 1 && HeightPre > 0) {
        
        CGFloat playerWidth = ceil(screenWidth * (CGFloat)(1.0 - HeightPre / (screenWidth/(screenWidth - config.miniPlayerWidth))));
        CGFloat playerHeight = config.topPlayerHeight * (1.0 - HeightPre / (screenWidth/(screenWidth - config.miniPlayerWidth)));
        
//        if (playerHeight > config.miniPlayerHeight) {
//            playerWidth = screenWidth;
//        }
        
        if (playerHeight <= config.miniPlayerHeight) {
            playerHeight = config.miniPlayerHeight;
            
            return;
        }
        
        [self.detailViewController.view setFrame: CGRectMake(kSpaceForSeek * HeightPre ,
                                                             HeightPre * (config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin),
                                                             screenWidth - 2 * kSpaceForSeek * HeightPre,
                                                             screenHeight - HeightPre * (config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin))];
        [self.detailViewController.myPlayer setFrame: CGRectMake(0, 0, playerWidth, playerHeight)];
        [self.detailViewController.miniPlayerControlLeft setConstant: config.miniPlayerWidth + kSpaceForSeek];
        [self.detailViewController.miniPlayerControlHeight setConstant: config.miniPlayerHeight];
        [self.detailViewController.myPlayer updateFramePlayer:CGRectMake(0, 0, playerWidth , playerHeight)];
        [self.detailViewController.heightPlayerView setConstant:self.detailViewController.myPlayer.frame.size.height];
        [self.detailViewController.view layoutIfNeeded];
    }
    if(self.detailViewController.view.frame.origin.y < screenHeight / 2) {
        CGFloat alpha = self.detailViewController.view.frame.origin.y / (screenHeight / 2);
        [self.detailViewController setContentViewAlpha: 1 - alpha];
        [self.detailViewController setMiniPlayerViewAlpha: 0];
        [NSNotificationCenter.defaultCenter postNotificationName: @"removeShadow" object: self];
    } else {
        [self.detailViewController setMiniPlayerViewAlpha: self.detailViewController.view.frame.origin.y / (screenHeight - HeightPre * (config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin))];
        [self.detailViewController setContentViewAlpha:0];
    }
}

- (void)movingSwipeLeft:(CGPoint)translatedPoint {
    CGRect frame = self.detailViewController.view.frame;
    [self.detailViewController.view setFrame:CGRectMake(config.miniPlayerWidth + translatedPoint.x ,  frame.origin.y, frame.size.width, frame.size.height)];
    [self.detailViewController.view setAlpha: 1 + ((translatedPoint.x / config.miniPlayerWidth)) / 2];
}

- (void)movingSwipeHorizontal:(CGPoint)translatedPoint {
    CGRect frame = self.detailViewController.view.frame;
    [self.detailViewController.view setFrame:CGRectMake(config.miniPlayerWidth + translatedPoint.x ,  frame.origin.y, frame.size.width, frame.size.height)];
    
    CGFloat alpha = 1 + ((translatedPoint.x / config.miniPlayerWidth)) / 2;
    if(self.swipeState == FWSwipeRight)
        alpha = 1 - ((translatedPoint.x / config.miniPlayerWidth)) / 2;
    [self.detailViewController.view setAlpha: alpha];
}

- (void)updateSwipeState:(CGPoint)translatedPoint {
    self.swipeState = FWSwipeNone;
    CGRect frame = self.detailViewController.view.frame;
    if(_isSmall && !isVertical) {
        if((translatedPoint.x < 0 && fabs(translatedPoint.x) >= config.miniPlayerWidth/2) || (translatedPoint.x < 0 && frame.origin.x <= 0)) {
            self.swipeState = FWSwipeLeft;
        }
        else if (translatedPoint.x > 0 && fabs(translatedPoint.x) >= config.miniPlayerWidth/2) {
            self.swipeState = FWSwipeRight;
        }
        else
            self.swipeState = FWSwipeNone;
    } else {
        if (_isSmall) {
            if(translatedPoint.y < 0 && fabs(translatedPoint.y) >= config.miniPlayerHeight/2) {
                self.swipeState = FWSwipeUp;
            } else {
                self.swipeState = FWSwipeDown;
            }
        } else {
            if(translatedPoint.y > 0 && fabs(translatedPoint.y) >= config.miniPlayerHeight/2) {
                self.swipeState = FWSwipeDown;
            } else {
                self.swipeState = FWSwipeUp;
            }
        }
    }
}

- (void)updateEndingMovingFrame {
    switch (self.swipeState) {
        case FWSwipeLeft:
        case FWSwipeRight:
            [self endingSwipeHorizontal];
            break;
        case FWSwipeDown:
            [self endingSwipeVertical];
            [self setStatusBarHidden:NO];
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            break;
        case FWSwipeUp:
            [self endingSwipeVertical];
            [self setStatusBarHidden:NO];
            break;
        case FWSwipeNone:
            [self endingSwipeNone];
            break;
        default:
            break;
    }
    isVertical = NO;
    isHorizontal = NO;
}

- (void)endingSwipeHorizontal {
    isAnimation = YES;
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.detailViewController.view setFrame:CGRectMake((self.swipeState == FWSwipeLeft)? 0 : screenWidth , config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin, screenWidth, screenHeight)];
        [self.detailViewController.view setAlpha:0];
    } completion:^(BOOL finished) {
        if(finished) {
            isAnimation = NO;
            self.isSmall = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:FWDidExitPlayerBySwipe object:nil];
            [self exit];
        }
    }];
}


- (void)endingSwipeVertical {
    isAnimation = YES;
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        if(self.swipeState == FWSwipeUp) {
            [self.detailViewController.view setFrame:CGRectMake(0 , 0, screenWidth, screenHeight)];
            [self.detailViewController.myPlayer setFrame:CGRectMake(0 , 0, screenWidth, config.topPlayerHeight + kSpaceForSeek)];
            [self.detailViewController.myPlayer updateFramePlayer:CGRectMake(0 , 0, screenWidth, config.topPlayerHeight)];
            [self.detailViewController.heightPlayerView setConstant: config.topPlayerHeight + kSpaceForSeek];
            [self.detailViewController.view setNeedsDisplay];
            [self.detailViewController setContentViewAlpha:1];
            [self.detailViewController setMiniPlayerViewAlpha:0];
            [NSNotificationCenter.defaultCenter postNotificationName: @"removeShadow" object: self];
       }
       else {
           [self.detailViewController.view setFrame:CGRectMake(kSpaceForSeek , config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin - kSpaceForSeek, screenWidth - 2 * kSpaceForSeek, config.miniPlayerHeight)];
           [self.detailViewController.myPlayer setFrame:CGRectMake(0 , 0, config.miniPlayerWidth, config.miniPlayerHeight + kSpaceForSeek)];
           [self.detailViewController.myPlayer updateFramePlayer:CGRectMake(0 , 0, config.miniPlayerWidth, config.miniPlayerHeight)];
           [self.detailViewController.view setNeedsDisplay];
           
           [self.detailViewController setMiniPlayerViewAlpha:1];
           [self.detailViewController setContentViewAlpha:0];
           [NSNotificationCenter.defaultCenter postNotificationName: @"addShadow" object: self];
       }
           
    } completion:^(BOOL finished){
        if(finished) {
            isAnimation = NO;
            if(_isSmall != ( self.swipeState == FWSwipeDown )) {
                self.isSmall = ( self.swipeState == FWSwipeDown );
                [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]],FWPlayerCanRotate, nil]];
            }
            
            if (self.swipeState == FWSwipeUp) {
                [self setStatusBarHidden:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]],FWPlayerCanRotate, nil]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(player:finishedVerticalSwipe:)])
                [self.delegate player:_detailViewController.myPlayer finishedVerticalSwipe:_isSmall];
        }
    }];
}

- (void)endingSwipeNone {
    isAnimation = YES;
    CGRect frame = self.detailViewController.view.frame;
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.detailViewController.view setFrame:CGRectMake(kSpaceForSeek , config.maxVerticalMovingHeight - config.miniPlayerHeight - _bottomMargin, frame.size.width, self.detailViewController.view.frame.size.height)];
        [self.detailViewController.view setAlpha:1];
    } completion:^(BOOL finished){
        if(finished)
        {
            isAnimation = NO;
            self.isSmall = YES;
        }
    }];
}

#pragma mark UIDeviceOrientationDidChangeNotification

- (void) orientationChanged:(NSNotification *)note {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    /**
     *  this frame is used for lanscape mode only
     */
    
    CGFloat width = MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    CGFloat height = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    CGRect frame;
    frame = CGRectMake(0, 0, width, height);

    if(orientation == UIDeviceOrientationLandscapeLeft ) {
        if(!isAnimation && !_isSmall && _detailViewController) {
            [self setStatusBarHidden:YES];
            /**
             *  dismiss keyboard on all screens
             *
             */
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [self.detailViewController.myPlayer setIsInFullscreen:YES];
            if(config.draggable)
                [self.detailViewController.myPlayer  removeGestureRecognizer:dragRecognizer];
            [self.detailViewController setContentViewAlpha:0];
            [self.detailViewController setMiniPlayerViewAlpha:1];
            [NSNotificationCenter.defaultCenter postNotificationName: @"addShadow" object: self];
            
            [UIView animateWithDuration:0.2f animations:^{
                CGFloat lastRadians = fabsf(atan2f(self.detailViewController.myPlayer.transform.b, self.detailViewController.myPlayer.transform.a));
                if (!(M_PI_2 - lastRadians <= FLT_EPSILON)) {
                    [self.detailViewController.myPlayer setFrame:frame];
                    [self.detailViewController.myPlayer.layer setFrame:frame];
                    self.detailViewController.heightPlayerView.constant = frame.size.height;
                    [self.detailViewController.myPlayer updateFramePlayer:frame];
                }
            } completion:^(BOOL finished) {
            }];
        }
    } else if (orientation == UIDeviceOrientationLandscapeRight){
        if(!isAnimation && !_isSmall && _detailViewController) {
            [self setStatusBarHidden:YES];
            /**
             *  dismiss keyboard on all screens
             *
             */
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [self.detailViewController.myPlayer setIsInFullscreen:YES];
            if(config.draggable)
                [self.detailViewController.myPlayer  removeGestureRecognizer:dragRecognizer];
            [self.detailViewController setContentViewAlpha:0];
            [self.detailViewController setMiniPlayerViewAlpha:1];
            [NSNotificationCenter.defaultCenter postNotificationName: @"addShadow" object: self];
            
            [UIView animateWithDuration:0.2f animations:^{
                CGFloat lastRadians = fabsf(atan2f(self.detailViewController.myPlayer.transform.b, self.detailViewController.myPlayer.transform.a));
                if (!(M_PI_2 - lastRadians <= FLT_EPSILON)) {
                    [self.detailViewController.myPlayer setFrame:frame];
                    [self.detailViewController.myPlayer.layer setFrame:frame];
                    self.detailViewController.heightPlayerView.constant = frame.size.height;
                    [self.detailViewController.myPlayer updateFramePlayer:frame];
                }
                
            } completion:^(BOOL finished) {
            }];
        }
    } else if(orientation == UIDeviceOrientationPortrait) {
        if (_detailViewController) {
            if(!isAnimation && !_isSmall && !isLock) {
                [self setStatusBarHidden:YES];
                [self.detailViewController.myPlayer setIsInFullscreen:NO];
                if(config.draggable)
                    [self.detailViewController.myPlayer  addGestureRecognizer:dragRecognizer];
                [self.detailViewController setContentViewAlpha:1];
                [self.detailViewController setMiniPlayerViewAlpha:0];
                [NSNotificationCenter.defaultCenter postNotificationName: @"removeShadow" object: self];
                
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect frame = CGRectMake(0, 0, screenWidth, screenWidth*9/16 + kSpaceForSeek);
                    CGRect framePlayer = CGRectMake(0, 0, screenWidth, screenWidth*9/16);
                    [self.detailViewController.myPlayer setFrame:frame];
                    [self.detailViewController.myPlayer.layer setFrame:frame];
                    self.detailViewController.heightPlayerView.constant = frame.size.height;
                    [self.detailViewController.myPlayer updateFramePlayer:framePlayer];
                } completion:^(BOOL finished) {
                }];
            }else if (_isSmall){
                [self setStatusBarHidden:NO];
            }
        } else {
            [self setStatusBarHidden:NO];
        }
    } else if (orientation == UIDeviceOrientationUnknown) {
        [self setStatusBarHidden:NO];
    }
}

- (void)exit {
    [[NSNotificationCenter defaultCenter] postNotificationName:FWShouldExitPlayer object:nil];
    [self.detailViewController.myPlayer stop];
    self.detailViewController.myPlayer = nil;
    
    [self.detailViewController.view removeFromSuperview];
    [self.detailViewController removeFromParentViewController];
    self.detailViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    @try {
        [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(isSmall)) context:nil];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FWDidExitPlayer object:nil];
    [self setStatusBarHidden:NO];
}

#pragma player delegate

- (void) closeDetailView {
    [self exit];
    [NSNotificationCenter.defaultCenter postNotificationName: @"removeShadow" object: self];
}

- (void)minimizePlayerView {
    if(config.draggable) {
        self.swipeState = FWSwipeDown;
        [self updateEndingMovingFrame];
        [self.detailViewController.myPlayer hiddenControlsAndSettings:YES];
        self.isSmall = YES;
        [NSNotificationCenter.defaultCenter postNotificationName: @"addShadow" object: self];
    }
}

- (void)maximizePlayerView {
    
    if(_isSmall) {
        self.swipeState = FWSwipeUp;
        [self endingSwipeVertical];
        [NSNotificationCenter.defaultCenter postNotificationName: @"removeShadow" object: self];
    }
}

- (void)toggleFullScreen:(id) sender {
    isLock = NO;
    [self.detailViewController.myPlayer.viewPlayBackControls.btnLockScreen setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]],FWPlayerCanRotate, nil]];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];    
    if (UIDeviceOrientationIsPortrait(orientation)) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    } else {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

- (void)lockScreenBtnOnClick:(id)sender {
    isLock = !isLock;
    if (!isLock) {
        [sender setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[self canRotate]],FWPlayerCanRotate, nil]];
}

#pragma mark Can rotate checker
- (BOOL)canRotate {
    if (_isSmall || isLock || isAnimation) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    if (self.isSmall) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            [self.detailViewController.view setFrame:CGRectMake(kSpaceForSeek , config.maxVerticalMovingHeight - config.miniPlayerHeight - bottomMargin, config.miniPlayerWidth, config.miniPlayerHeight)];
        } completion:^(BOOL finished){
        }];
    }
}

- (void)setStatusBarHidden:(BOOL) hide {
    if (isIphoneX) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)dealloc {
    NSLog(@"FWDraggableManager dealloc");
}
@end
