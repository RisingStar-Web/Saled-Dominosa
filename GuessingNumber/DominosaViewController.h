//
//  DominosaViewController.h
//  Dominosa
//
//  Created by Anjona Inc. on 6/4/12.
//  Copyright (c) 2012 Anjona Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GameCenterManager.h"
#include "cores.h"
#import "PHConfettiView.h"

@protocol DominosaViewControllerSaver <NSObject>

- (void)saveGame:(NSString *)name state:(NSString *)save inprogress:(BOOL)inprogress;

@end

@class DominosaView;

@interface DominosaViewController : UIViewController <GADBannerViewDelegate,GADInterstitialDelegate, GameCenterManagerDelegate> {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *rankLabel;
    
    IBOutlet NSLayoutConstraint *topLayout;
    IBOutlet NSLayoutConstraint *bottomLayout;
    CGFloat offsetY;
    
    BOOL isGamePlaying;
    NSInteger count;
    GADBannerView *bannerView_;
    
    NSTimer *gameTimer;
    
    NSInteger retryCount;
    DominosaView *gameview;
    BOOL _useSolved;
    BOOL _gameFailed;
    BOOL isLaunch;
}

- (IBAction)leaderboardPressed:(id)sender;

@property (nonatomic, strong) PHConfettiView *confettiView;
@property (nonatomic, retain) GADInterstitial *interstitial_;
@property (nonatomic, assign) const game *thegame;
@property (nonatomic, retain) id<DominosaViewControllerSaver> saver;
@property (nonatomic, retain) NSString *saved;
@property (nonatomic, assign) BOOL init_inprogress;
@property (nonatomic, assign) NSInteger type;

@end
