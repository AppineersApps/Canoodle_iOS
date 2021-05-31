//
//  MPAdContainerView.m
//
//  Copyright 2018-2021 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

#import "MPAdContainerView.h"
#import "MPAdContainerView+Private.h"
#import "MPAdViewOverlay.h"
#import "MPLogging.h"
#import "MPVideoPlayerView.h"
#import "MPVideoPlayerViewOverlay.h"
#import "MPViewableVisualEffectView.h"
#import "UIView+MPAdditions.h"

// For non-module targets, UIKit must be explicitly imported
// since MoPubSDK-Swift.h will not import it.
#if __has_include(<MoPubSDK/MoPubSDK-Swift.h>)
    #import <UIKit/UIKit.h>
    #import <MoPubSDK/MoPubSDK-Swift.h>
#else
    #import <UIKit/UIKit.h>
    #import "MoPubSDK-Swift.h"
#endif

static const NSTimeInterval kAnimationTimeInterval = 0.5;

#pragma mark -

@interface MPAdContainerView (MPAdViewOverlayDelegate) <MPAdViewOverlayDelegate>
@end

@interface MPAdContainerView (MPVideoPlayerViewDelegate) <MPVideoPlayerViewDelegate>
@end

@interface MPAdContainerView (MPVASTCompanionAdViewDelegate) <MPVASTCompanionAdViewDelegate>
@end

#pragma mark -

@implementation MPAdContainerView

- (instancetype)initWithFrame:(CGRect)frame webContentView:(MPWebView *)webContentView {
    if (self = [self initWithFrame:frame]) {
        _webContentView = webContentView;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.clipsToBounds = YES;

        MPAdViewOverlay *overlay = [[MPAdViewOverlay alloc] initWithFrame:CGRectZero];
        overlay.delegate = self;
        self.overlay = overlay;
        [self sharedInitializationStepsWithContentView:webContentView];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageCreativeView:(MPImageCreativeView *)imageCreativeView {
    if (self = [self initWithFrame:frame]) {
        _imageCreativeView = imageCreativeView;
        self.opaque = NO;
        self.clipsToBounds = YES;

        MPAdViewOverlay *overlay = [[MPAdViewOverlay alloc] initWithFrame:CGRectZero];
        // Set the delegate on the overlay view because we must receive close button events
        overlay.delegate = self;
        self.overlay = overlay;
        [self sharedInitializationStepsWithContentView:imageCreativeView];
        // Set the background color to black to make the presentation animation smooth.
        self.backgroundColor = [UIColor blackColor];
    }

    return self;
}

- (void)sharedInitializationStepsWithContentView:(UIView *)contentView {
    self.accessibilityIdentifier = @"com.mopub.adcontainer";
    // It's possible for @c contentView to be @c nil. Don't try to set constraints on a @c nil
    // @c contentView.
    if (contentView != nil) {
        contentView.frame = self.bounds;
        [self addSubview:contentView];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [contentView.mp_safeTopAnchor constraintEqualToAnchor:self.mp_safeTopAnchor],
            [contentView.mp_safeLeadingAnchor constraintEqualToAnchor:self.mp_safeLeadingAnchor],
            [contentView.mp_safeBottomAnchor constraintEqualToAnchor:self.mp_safeBottomAnchor],
            [contentView.mp_safeTrailingAnchor constraintEqualToAnchor:self.mp_safeTrailingAnchor]
        ]];
    }
    // add after the content view so that the overlay is on top
    [self addSubview:self.overlay];

    self.overlay.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.overlay.mp_safeTopAnchor constraintEqualToAnchor:self.mp_safeTopAnchor],
        [self.overlay.mp_safeLeadingAnchor constraintEqualToAnchor:self.mp_safeLeadingAnchor],
        [self.overlay.mp_safeBottomAnchor constraintEqualToAnchor:self.mp_safeBottomAnchor],
        [self.overlay.mp_safeTrailingAnchor constraintEqualToAnchor:self.mp_safeTrailingAnchor]
    ]];
}

- (BOOL)wasTapped {
    return self.overlay.wasTapped;
}

+ (CGRect)closeButtonFrameForAdSize:(CGSize)adSize atLocation:(MPAdViewCloseButtonLocation)location {
    return [MPAdViewOverlay closeButtonFrameForAdSize:adSize atLocation:location];
}

- (void)setCloseButtonLocation:(MPAdViewCloseButtonLocation)closeButtonLocation {
    self.overlay.closeButtonLocation = closeButtonLocation;
}

- (void)setCloseButtonType:(MPAdViewCloseButtonType)closeButtonType {
    self.overlay.closeButtonType = closeButtonType;
}

- (void)showCountdownTimer:(NSTimeInterval)duration {
    [self.overlay showCountdownTimerForDuration:duration];
}

#pragma mark - UIView Override

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    if ([self.webAdDelegate respondsToSelector:@selector(adContainerView:didMoveToWindow:)]) {
        [self.webAdDelegate adContainerView:self didMoveToWindow:self.window];
    }
}

#pragma mark - Private: Companion Ad

- (void)preloadCompanionAd {
    MPVASTCompanionAd *ad = [self.videoConfig companionAdForContainerSize:self.bounds.size];
    if (ad == nil) {
        return;
    }

    // If a companion ad is already loaded, don't load another one
    if (self.companionAdView != nil) {
        return;
    }

    self.companionAdView = [[MPVASTCompanionAdView alloc] initWithCompanionAd:ad];
    self.companionAdView.delegate = self;
    self.companionAdView.clipsToBounds = YES;
    [self insertSubview:self.companionAdView belowSubview:self.overlay];
    self.companionAdView.translatesAutoresizingMaskIntoConstraints = NO;

    // All companion ad types may pin to the edges of the container.
    [NSLayoutConstraint activateConstraints:@[
        [self.companionAdView.mp_safeTopAnchor constraintEqualToAnchor:self.mp_safeTopAnchor],
        [self.companionAdView.mp_safeLeadingAnchor constraintEqualToAnchor:self.mp_safeLeadingAnchor],
        [self.companionAdView.mp_safeBottomAnchor constraintEqualToAnchor:self.mp_safeBottomAnchor],
        [self.companionAdView.mp_safeTrailingAnchor constraintEqualToAnchor:self.mp_safeTrailingAnchor]
    ]];

    [self.companionAdView setHidden:YES]; // hidden by default, only show after loaded and video finishes
    [self.companionAdView loadCompanionAd]; // delegate will handle load status updates
}

/**
 Note: Do nothing before the video finishes.
 */
- (void)showCompanionAd {
    if (self.isVideoFinished == NO) { // timing guard
        return;
    }

    if (self.companionAdView != nil
        && self.companionAdView.isLoaded
        && self.companionAdView.isHidden) {
        // Notify UI that contraints and layout need to be updated
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];

        // make companion ad view transparent but unhidden
        self.companionAdView.alpha = 0;
        [self.companionAdView setHidden:NO];
        [UIView animateWithDuration:kAnimationTimeInterval animations:^{
            self.companionAdView.alpha = 1;
            self.videoPlayerView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.videoPlayerView removeFromSuperview];
            self.videoPlayerView = nil;
        }];

        [self.videoPlayerDelegate videoPlayer:self didShowCompanionAdView:self.companionAdView];
    } else {
        [self makeVideoBlurry];
    }
}

/**
 Make the video blurry if there is no companion ad to show after the video finishes.
 */
- (void)makeVideoBlurry {
    // No need to blur more than once
    if (self.blurEffectView != nil) {
        return;
    }

    self.blurEffectView = [MPViewableVisualEffectView new];
    [self.videoPlayerView addSubview:self.blurEffectView];

    // Safeguard against edge case crash where videoPlayerView is nil or off view hierarchy. see ADF-5838
    if (self.videoPlayerView == nil || self.videoPlayerView.window == nil) {
        return;
    }
    self.blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.blurEffectView.mp_safeTopAnchor constraintEqualToAnchor:self.mp_safeTopAnchor],
        [self.blurEffectView.mp_safeLeadingAnchor constraintEqualToAnchor:self.mp_safeLeadingAnchor],
        [self.blurEffectView.mp_safeBottomAnchor constraintEqualToAnchor:self.mp_safeBottomAnchor],
        [self.blurEffectView.mp_safeTrailingAnchor constraintEqualToAnchor:self.mp_safeTrailingAnchor]
    ]];

    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.blurEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }];
}

#pragma mark - Timer methods

- (void)pauseCountdownTimer {
    [self.overlay pauseTimer];
}

- (void)resumeCountdownTimer {
    [self.overlay resumeTimer];
}

@end

#pragma mark -

@implementation MPAdContainerView (MPVideoPlayer)


- (instancetype)initWithVideoURL:(NSURL *)videoURL videoConfig:(MPVideoConfig *)videoConfig  {
    if (self = [super init]) {
        _videoConfig = videoConfig;
        MPVideoPlayerView *videoPlayerView = [[MPVideoPlayerView alloc] initWithVideoURL:videoURL
                                                                             videoConfig:videoConfig];
        videoPlayerView.delegate = self;
        self.videoPlayerView = videoPlayerView;
        self.backgroundColor = UIColor.blackColor;

        MPVideoPlayerViewOverlayConfig *config
        = [[MPVideoPlayerViewOverlayConfig alloc]
           initWithCallToActionButtonTitle:self.videoConfig.callToActionButtonTitle
           isRewardExpected:self.videoConfig.isRewardExpected
           isClickthroughAllowed:self.videoConfig.clickThroughURL.absoluteString.length > 0
           hasCompanionAd:self.videoConfig.hasCompanionAd
           enableEarlyClickthroughForNonRewardedVideo:self.videoConfig.enableEarlyClickthroughForNonRewardedVideo];
        MPAdViewOverlay *overlay = [[MPAdViewOverlay alloc] initWithVideoOverlayConfig:config];
        overlay.delegate = self;
        self.overlay = overlay;
        [self sharedInitializationStepsWithContentView:self.videoPlayerView];
    }
    return self;
}

- (void)loadVideo {
    if (self.videoPlayerView.isVideoLoaded) {
        return;
    }

    [self.videoPlayerView loadVideo];
}

- (void)playVideo {
    if (self.videoPlayerView.isVideoPlaying == NO) {
        [self preloadCompanionAd];
        [self.overlay handleVideoStartForSkipOffset:self.skipOffset
                                      videoDuration:self.videoPlayerView.videoDuration];
    }

    [self.videoPlayerView playVideo];

    [self resumeCountdownTimer];
}

- (void)pauseVideo {
    [self.videoPlayerView pauseVideo];

    [self pauseCountdownTimer];
}

- (void)stopVideo {
    [self.videoPlayerView stopVideo];
    [self.overlay stopTimer];
}

- (void)enableAppLifeCycleEventObservationForAutoPlayPause {
    [self.videoPlayerView enableAppLifeCycleEventObservationForAutoPlayPause];
}

- (void)disableAppLifeCycleEventObservationForAutoPlayPause {
    [self.videoPlayerView disableAppLifeCycleEventObservationForAutoPlayPause];
}

@end

#pragma mark -

@implementation MPAdContainerView (MPAdViewOverlayDelegate)

- (void)videoPlayerViewOverlay:(id<MPVideoPlayerViewOverlay>)overlay
               didTriggerEvent:(MPVideoEvent)event {
    // Treat skips with an end card the same as video completed.
    if ([event isEqualToString:MPVideoEventSkip] && self.videoConfig.hasCompanionAd) {
        self.isVideoFinished = YES;
        [self showCompanionAd];
        [self.overlay handleVideoComplete];
    }
    if (self.videoPlayerDelegate != nil) {
        [self.videoPlayerDelegate videoPlayer:self
                              didTriggerEvent:event
                                videoProgress:self.videoPlayerView.videoProgress];
    }
    else if ([event isEqualToString:MPVideoEventClose]) {
        [self.webAdDelegate adContainerViewDidHitCloseButton:self];
    }
}


- (void)videoPlayerViewOverlayDidFinishCountdown:(id<MPVideoPlayerViewOverlay>)overlay {
    [self.countdownTimerDelegate countdownTimerDidFinishCountdown:self];
    // Now that the timer is complete, enable clickthrough on image ads
    [self.imageCreativeView enableClick];
}

- (void)industryIconView:(MPVASTIndustryIconView *)iconView
         didTriggerEvent:(MPVASTResourceViewEvent)event {
    switch (event) {
        case MPVASTResourceViewEvent_ClickThrough: {
            [self.videoPlayerDelegate videoPlayer:self
                         didClickIndustryIconView:iconView
                        overridingClickThroughURL:nil];
            break;
        }
        case MPVASTResourceViewEvent_DidLoadView: {
            [self.videoPlayerDelegate videoPlayer:self didShowIndustryIconView:iconView];
            break;
        }
        case MPVASTResourceViewEvent_FailedToLoadView: {
            MPLogError(@"Failed to load industry icon view: %@", iconView.icon);
            break;
        }
    }
}

- (void)industryIconView:(MPVASTIndustryIconView *)iconView
didTriggerOverridingClickThrough:(NSURL *)url {
    [self.videoPlayerDelegate videoPlayer:self
                 didClickIndustryIconView:iconView
                overridingClickThroughURL:url];
}

@end

#pragma mark -

@implementation MPAdContainerView (MPVideoPlayerViewDelegate)

- (void)videoPlayerViewDidLoadVideo:(MPVideoPlayerView *)videoPlayerView {
    [self.videoPlayerDelegate videoPlayerDidLoadVideo:self];
}

- (void)videoPlayerViewDidFailToLoadVideo:(MPVideoPlayerView *)videoPlayerView error:(NSError *)error {
    [self.videoPlayerDelegate videoPlayerDidFailToLoadVideo:self error:error];
}

- (void)videoPlayerViewDidStartVideo:(MPVideoPlayerView *)videoPlayerView duration:(NSTimeInterval)duration {
    [self.videoPlayerDelegate videoPlayerDidStartVideo:self duration:duration];
}

- (void)videoPlayerViewDidCompleteVideo:(MPVideoPlayerView *)videoPlayerView duration:(NSTimeInterval)duration {
    self.isVideoFinished = YES;
    [self showCompanionAd];
    [self.overlay handleVideoComplete];
    [self.videoPlayerDelegate videoPlayerDidCompleteVideo:self duration:duration];
}

- (void)videoPlayerView:(MPVideoPlayerView *)videoPlayerView
videoDidReachProgressTime:(NSTimeInterval)videoProgress
               duration:(NSTimeInterval)duration {
    [self.videoPlayerDelegate videoPlayer:self
                videoDidReachProgressTime:videoProgress
                                 duration:duration];
}

- (void)videoPlayerView:(MPVideoPlayerView *)videoPlayerView
        didTriggerEvent:(MPVideoEvent)event
          videoProgress:(NSTimeInterval)videoProgress {
    [self.videoPlayerDelegate videoPlayer:self
                          didTriggerEvent:event
                            videoProgress:videoProgress];
}

- (void)videoPlayerView:(MPVideoPlayerView *)videoPlayerView
       showIndustryIcon:(MPVASTIndustryIcon *)icon {
    [self.overlay showIndustryIcon:icon];
}

- (void)videoPlayerViewHideIndustryIcon:(MPVideoPlayerView *)videoPlayerView {
    [self.overlay hideIndustryIcon];
}

@end

#pragma mark -

@implementation MPAdContainerView (MPVASTCompanionAdViewDelegate)

- (UIViewController *)viewControllerForPresentingModalMRAIDExpandedView {
    return self.videoPlayerDelegate.viewControllerForPresentingModalMRAIDExpandedView;
}

- (void)companionAdView:(MPVASTCompanionAdView *)companionAdView
        didTriggerEvent:(MPVASTResourceViewEvent)event {
    switch (event) {
        case MPVASTResourceViewEvent_ClickThrough: {
            [self.videoPlayerDelegate videoPlayer:self
                          didClickCompanionAdView:companionAdView
                        overridingClickThroughURL:nil];
            break;
        }
        case MPVASTResourceViewEvent_DidLoadView: {
            if (self.isVideoFinished) {
                [self showCompanionAd];
            }
            break;
        }
        case MPVASTResourceViewEvent_FailedToLoadView: {
            MPLogError(@"Failed to load companion ad view: %@", companionAdView.ad);
            [self.companionAdView removeFromSuperview];
            self.companionAdView = nil;
            [self.videoPlayerDelegate videoPlayer:self didFailToLoadCompanionAdView:companionAdView];
            break;
        }
    }
}

- (void)companionAdView:(MPVASTCompanionAdView *)companionAdView
didTriggerOverridingClickThrough:(NSURL *)url {
    [self.videoPlayerDelegate videoPlayer:self
                  didClickCompanionAdView:companionAdView
                overridingClickThroughURL:url];
}

- (void)companionAdViewRequestDismiss:(MPVASTCompanionAdView *)companionAdView {
    [self.videoPlayerDelegate videoPlayer:self companionAdViewRequestDismiss:companionAdView];
}

@end
