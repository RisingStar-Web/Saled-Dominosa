//
//  DominosaViewController.m
//  Dominosa
//
//  Created by Anjona Inc. on 6/4/12.
//  Copyright (c) 2012 Anjona Inc. All rights reserved.
//

#import "DominosaViewController.h"
#import "Constants.h"
#import "GameCenterManager.h"
#import "SoundManager.h"
#import "DominosaView.h"
#import "CMPopTipView.h"

extern BOOL isPad;
extern BOOL isPhone5;
extern BOOL isPhoneX;
extern BOOL removeAd;
extern NSInteger adCount;
extern NSInteger gameType;

@interface DominosaViewController () <GameViewDelegate, CMPopTipViewDelegate>

@end

@implementation DominosaViewController
@synthesize interstitial_ = interstitial__;

#pragma mark View Functions;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isPhoneX) {
        topLayout.constant = 49;
        bottomLayout.constant = 94.0f;
        offsetY = 34;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveGame) name:@"applicationDidEnterBackground" object:nil];

    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    
    [self updateRankingLabel];
   
    [[GameCenterManager sharedManager] setDelegate:self];
    if (_init_inprogress) {
        count += [[NSUserDefaults standardUserDefaults] integerForKey:KEY_TIME_COUNT];
    }
    isGamePlaying = YES;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    gameview = [[DominosaView alloc] initWithFrame:[UIScreen mainScreen].bounds nc:self.navigationController game:_thegame saved:_saved inprogress:_init_inprogress];
    gameview.delegate = self;
    [self.view insertSubview:gameview atIndex:0];
    
    removeAd = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_REMOVEAD];
    //removeAd = YES;
    if (!removeAd) {
        bannerView_ = [[GADBannerView alloc] init];
        bannerView_.adSize = kGADAdSizeSmartBannerPortrait;
        bannerView_.adUnitID = KEY_ADMOB;
        bannerView_.rootViewController = self;
        bannerView_.delegate = self;
        [self.view addSubview:bannerView_];
        [bannerView_ loadRequest:[GADRequest request]];
        [bannerView_ setHidden:YES];
        self.interstitial_ = [self createAndLoadInterstitial];
    }
}

- (void)showConfetti:(BOOL)stop {
    if (!_confettiView) {
        self.confettiView = [[PHConfettiView alloc] initWithFrame:self.view.bounds];
        self.confettiView.colors = @[[UIColor colorWithRed:0.95 green:0.40 blue:0.27 alpha:1.0],
                                     [UIColor colorWithRed:1.00 green:0.78 blue:0.36 alpha:1.0],
                                     [UIColor colorWithRed:0.48 green:0.78 blue:0.64 alpha:1.0],
                                     [UIColor colorWithRed:0.30 green:0.76 blue:0.85 alpha:1.0],
                                     [UIColor colorWithRed:0.58 green:0.39 blue:0.55 alpha:1.0]];
        [self.view addSubview:self.confettiView];
        
    }
    //    self.confettiView.intensity = 0.6;
    //    self.confettiView.birthRate = 10;
    
    NSInteger t = arc4random()%4;
    self.confettiView.type = t;
    [self.confettiView startConfetti];
    
    if (!stop) {
        [self performSelector:@selector(hideConfetti) withObject:nil afterDelay:(isPad?2.0f:1.0f)];
    } else {
        [self performSelector:@selector(hideConfetti) withObject:nil afterDelay:(isPad?5.0f:3.0f)];
    }
}

- (void)hideConfetti {
    [self.confettiView stopConfetti];
}

- (void)viewDidLayoutSubviews {
    if (!isLaunch) {
        isLaunch = YES;
        
        gameview.frame = [UIScreen mainScreen].bounds;
        
        gameview.offsetY = offsetY;
        
        CGRect f = gameview.toolbar.frame;
        f.origin.y = self.view.frame.size.height - f.size.height - offsetY;
        gameview.toolbar.frame = f;
        
        f = gameview.game_toolbar.frame;
        f.origin.y = self.view.frame.size.height - gameview.toolbar.frame.size.height - f.size.height - offsetY;
        gameview.game_toolbar.frame = f;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (removeAd) {
        bannerView_.delegate = nil;
        [bannerView_ removeFromSuperview];
        bannerView_ = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveGame];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    if (!removeAd) {
        [view setHidden:NO];
    } else {
        [view setHidden:YES];
    }
    
    CGRect f = view.frame;
    //gameview.offsetY = f.size.height - offsetY;
    f.origin.y = self.view.frame.size.height - f.size.height - offsetY;
    view.frame = f;
    
    f = gameview.toolbar.frame;
    f.origin.y = self.view.frame.size.height - view.frame.size.height - f.size.height - offsetY;
    gameview.toolbar.frame = f;
    
    f = gameview.game_toolbar.frame;
    f.origin.y = self.view.frame.size.height - gameview.toolbar.frame.size.height - f.size.height - offsetY;
    gameview.game_toolbar.frame = f;
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [view setHidden:YES];
    
    CGRect f = gameview.toolbar.frame;
    f.origin.y = self.view.frame.size.height - f.size.height - offsetY;
    gameview.toolbar.frame = f;
    
    f = gameview.game_toolbar.frame;
    f.origin.y = self.view.frame.size.height - gameview.toolbar.frame.size.height - f.size.height - offsetY;
    gameview.game_toolbar.frame = f;
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:KEY_ADMOB_INTERSTITIAL];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial_ = [self createAndLoadInterstitial];
}

- (void)showBounceAnimation:(UIView*)sender {
    sender.center = self.view.center;
    [self.view addSubview:sender];
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         sender.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         sender.alpha = 0.5;
     } completion:^(BOOL finished){
         [self bounceInAnimationStoped:sender];
     }];
}

- (void)bounceInAnimationStoped:(UIView*)sender {
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         sender.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
         sender.alpha = 1.0;
     } completion:^(BOOL finished){
         [self animationStoped:sender];
     }];
}

- (void)animationStoped:(UIView*)sender {
    sender.center = self.view.center;
}

- (void)closeBounceAnimation:(UIView*)sender {
    [UIView animateWithDuration:0.2f animations:^{
        sender.alpha = 0;
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
}

-(void)onTimer {
    if (isGamePlaying) {
        count++;
        timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)count/3600, (long)(count%3600)/60, (long)(count%3600)%60];
    }
}
//
- (void)popupMessageWithTitle: (NSString *)title 
                   andMessage: (NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:msg
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)isHighScore:(NSInteger)value {
    NSString *key = [NSString stringWithFormat:@"%ld_%ld_BEST", (long)_type, (long)gameType];
    NSInteger v = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (v == 0 || v > value) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

- (void)showAd {
    adCount++;
    if (adCount%2 == 0 && !removeAd) {
        if ([self.interstitial_ isReady]) {
            [self.interstitial_ presentFromRootViewController:self];
        }
    }
    retryCount = 0;
}


- (IBAction)leaderboardPressed:(id)sender {
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
}

- (IBAction)ratePressed:(id)sender  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KEY_URL_REVIEW]];
}

- (IBAction)sharePressed:(id)sender {
    NSString *body = NSLocalizedString(@"SHAREWORD", nil);
    UIGraphicsBeginImageContextWithOptions(gameview.frame.size, NO, 0.0);
    [gameview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGSize finalSize = CGSizeMake(image.size.width*image.scale, image.size.height*image.scale);
    UIGraphicsBeginImageContext(finalSize);
    [image drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *arrayOfActivityItems = [NSArray arrayWithObjects:body, newImage, [NSURL URLWithString:KEY_URL], nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:arrayOfActivityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        activityVC.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - GameCenter Manager Delegate

- (void)rankForIdentifier:(NSString*)identifier value:(long)value {
    //countLabel.text = [NSString stringWithFormat:@"%lu", value];
    NSString *key = identifier;
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateRankingLabel];
}

- (void)updateRankingLabel {
    BOOL getRank = NO;
    if (_type == 0) {
        if (gameType < 7) {
            getRank = YES;
        }
    } else if (_type == 1) {
        if (gameType < 8) {
            getRank = YES;
        }
    } else if (_type == 2) {
        if (gameType < 9) {
            getRank = YES;
        }
    } else if (_type == 3) {
        if (gameType < 5) {
            getRank = YES;
        }
    }
    if (getRank) {
        NSInteger rank = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%ld_RANK", gameType]];
        if (rank > 0) {
            rankLabel.text = [NSString stringWithFormat:@"%lu", rank];
            return;
        }
    }
    rankLabel.text = @"N/A";
}

- (void)valueForIdentifier:(NSString *)identifier value:(long)value {
    NSLog(@"value %ld", value);
}

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_45];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_56];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_67];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_78];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_89];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_910];
        [[GameCenterManager sharedManager] rankForLeaderboard:GAMECENT_DOMINOSA_1011];
    
    } else {
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
    } else {
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
    } else {
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
}

- (IBAction)playAgain:(id)sender {
    [gameview doNewGame];
}

- (void)startNewGame {
    [self doBeep:@"click" ext:@"caf"];
    
    retryCount++;
    if (retryCount > 2) {
        [self showAd];
        retryCount = 0;
        adCount = 0;
    }
    _gameFailed = NO;
    _useSolved = NO;
    isGamePlaying = YES;
    count = 0;
    if (gameTimer) {
        [gameTimer invalidate]; gameTimer = nil;
    }
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)doBeep:(NSString*)name ext:(NSString*)ext {
    [[SoundManager sharedManager] playSound:[NSString stringWithFormat:@"%@.%@", name, ext] looping:NO];
}

- (void)newGame {
    [self updateRankingLabel];
    [self startNewGame];
    [self saveGame];
}

- (void)solveDone {
    
}

- (void)failGame {
    _gameFailed = YES;
    if (gameTimer) {
        [gameTimer invalidate]; gameTimer = nil;
    }
    [self showAd];
    [self doBeep:@"bomb" ext:@"caf"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE", nil)                                                    message:NSLocalizedString(@"FAILED", nil) delegate:self  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)endGame {
    if (!_useSolved && !_gameFailed) {
        isGamePlaying = NO;
        if (gameTimer) {
            [gameTimer invalidate]; gameTimer = nil;
        }
        if ([self isHighScore:count]) {
            [self doBeep:@"victory" ext:@"caf"];
            if (_type == 0) {
                if (gameType < 7) {
                    NSString *key = GAMECENT_DOMINOSA_45;
                    if (gameType == 1) {
                        key = GAMECENT_DOMINOSA_56;
                    } else if (gameType == 2) {
                        key = GAMECENT_DOMINOSA_67;
                    } else if (gameType == 3) {
                        key = GAMECENT_DOMINOSA_78;
                    } else if (gameType == 4) {
                        key = GAMECENT_DOMINOSA_89;
                    } else if (gameType == 5) {
                        key = GAMECENT_DOMINOSA_910;
                    } else if (gameType == 6) {
                        key = GAMECENT_DOMINOSA_1011;
                    }
                    [[GameCenterManager sharedManager] saveAndReportScore:count leaderboard:key sortOrder:GameCenterSortOrderLowToHigh];
                    [[GameCenterManager sharedManager] rankForLeaderboard:key];
                    [self showConfetti:YES];
                }
            }
        } else {
            [self showAd];
            [self doBeep:@"correct" ext:@"wav"];
            [self showConfetti:NO];
        }
    }
}

- (void)solveGame {
    if (gameTimer) {
        [gameTimer invalidate]; gameTimer = nil;
    }
    _useSolved = YES;
}

- (void)saveGame {
    BOOL inprogress;
    NSString *save = [gameview saveGameState_inprogress:&inprogress];
    if (save != nil) {
        [_saver saveGame:[NSString stringWithUTF8String:_thegame->name] state:save inprogress:inprogress];
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:KEY_TIME_COUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
