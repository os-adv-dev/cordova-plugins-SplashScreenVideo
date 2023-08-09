//
//  MainViewController+SplashScreenVideo.m
//
//  Created by Andre Grillo on 12/07/2023.
//

#import "MainViewController+SplashScreenVideo.h"
#import <objc/runtime.h>

static char PlayerViewControllerKey;

@implementation MainViewController (CDVSplashScreenVideo)

bool shouldHideStatusBar = YES;

- (BOOL)prefersStatusBarHidden {
    return shouldHideStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    bool darkStatusBar;
    NSString *darkStatusBarStr = self.commandDelegate.settings[@"dark_statusbar"];
    if (darkStatusBarStr == nil) {
        darkStatusBar = YES;
    } else {
        darkStatusBar = [darkStatusBarStr boolValue];
    }
    
    if (darkStatusBar){
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)setPlayerViewController:(AVPlayerViewController *)playerViewController
{
    objc_setAssociatedObject(self, &PlayerViewControllerKey, playerViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AVPlayerViewController *)playerViewController
{
    return objc_getAssociatedObject(self, &PlayerViewControllerKey);
}

AVPlayerViewController *playerViewController;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self playVideo];
}

-(void)videoDidFinishPlaying:(id)notification {
    NSString *fadeDurationStr = self.commandDelegate.settings[@"fade_duration"];
    double fadeDuration = [fadeDurationStr doubleValue];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationProtectedDataDidBecomeAvailable object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:fadeDuration animations:^{
                self.playerViewController.view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.playerViewController dismissViewControllerAnimated:false completion:nil];
                [self.playerViewController.view removeFromSuperview];
                self.playerViewController = nil;
            }];
        shouldHideStatusBar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoDidFinish" object:nil];
}

- (void)playVideo{
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:@"splashscreen" ofType:@"mp4"];
    NSURL *videoURL =[NSURL fileURLWithPath:fullpath];
    NSLog(@"⭐️ Path: %@", fullpath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:fullpath]) {
        NSLog(@"▶️ Video found. Let's play it!");
    } else {
        NSLog(@"🚨 Video file does not exist. Skiping it.");
        return;
    }

    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    AVPlayer* playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    playVideo.allowsExternalPlayback = NO;
    playVideo.usesExternalPlaybackWhileExternalScreenIsActive = NO;
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.showsPlaybackControls = false;
    self.playerViewController.player = playVideo;
    self.playerViewController.player.volume = 0;
    self.playerViewController.view.frame = self.view.bounds;
    self.playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //Notification when the app becomes active again
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppStateChanged:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppStateChanged:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    //Notification when the phone is unlocked
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppStateChanged:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppStateChanged:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];

    //Notification when the app comes back to foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppStateChanged:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    //Notification when the video finishes playing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
    
    [self.view addSubview:self.playerViewController.view];
    [playVideo play];
}

- (void)handleAppStateChanged:(NSNotification *)notification
{
    if ([notification.name isEqualToString:UIApplicationWillResignActiveNotification] ||
        [notification.name isEqualToString:UIApplicationProtectedDataWillBecomeUnavailable]) {
        if (self.playerViewController.player.rate != 0) {
            [self.playerViewController.player pause];
        }
    } else if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification] ||
               [notification.name isEqualToString:UIApplicationProtectedDataDidBecomeAvailable] ||
               [notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        if (self.playerViewController.player.rate == 0) {
            [self.playerViewController.player play];
        }
    }
}

@end
