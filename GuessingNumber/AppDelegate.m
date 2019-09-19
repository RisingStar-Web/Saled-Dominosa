//
//  DominosaAppDelegate.m
//  Dominosa
//
//  Created by Anjona Inc. on 6/4/12.
//  Copyright (c) 2012 Anjona Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "DominosaViewController.h"
#import "Constants.h"
#import "RMStore.h"
#import "UAAppReviewManager.h"

BOOL isPhone5;
BOOL isPad;
BOOL removeAd;
BOOL isPhoneX;
NSInteger adCount;
NSMutableSet *g_InProgress;
NSInteger gameType;
NSInteger currentType;

#define GAMELIST(A) \
A(Dominosa) \

#define DECL(x) extern const game x;
#define REF(x) &x,
GAMELIST(DECL)
const game *gamelist[] = { GAMELIST(REF) };
const int gamecount = lenof(gamelist);

@implementation AppDelegate
@synthesize window = _window;

- (void)initStoreKit {
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:@[BUY_REMOVEAD]] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
    } failure:^(NSError *error) {
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UITableViewCell appearance] setTintColor:[UIColor blackColor]];
    
    //[self initStoreKit];
    if (!IS_OS_103_OR_LATER) {
        [UAAppReviewManager setAppID:APP_REVIEW];
        [UAAppReviewManager setAppName:NSLocalizedString(@"TITLE", nil)];
        [UAAppReviewManager setDaysUntilPrompt:3];
        [UAAppReviewManager setUsesUntilPrompt:6];
        [UAAppReviewManager showPromptIfNecessary];
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:KEY_ACTIVE]) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:KEY_GAME_TYPE];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_ACTIVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    gameType = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_TYPE];
    [[GameCenterManager sharedManager] setupManager];
    
    g_InProgress = [[NSMutableSet alloc] init];
    path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *fn in files) {
        if ([fn hasSuffix:@".save"]) {
            [g_InProgress addObject:[fn substringToIndex:fn.length-5]];
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        isPhoneX = Device_Is_iPhoneX;
        if (!isPhoneX) {
            isPhoneX = Device_Is_iPhoneXS_MAX;
        }
        if (!isPhoneX) {
            isPhoneX = Device_Is_iPhoneXR;
        }
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            isPhone5 = NO;
        } else {
            isPhone5 = YES;
        }
    } else {
        isPad = YES;
    }
    
    _dominosaVC = [self DominosaViewControllerForGame:gamelist[0]];
    _dominosaVC.type = 0;
    const game *game = gamelist[0]; // 选择哪个游戏
    NSString *name = [NSString stringWithUTF8String:game->name];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"lastgame"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_dominosaVC];
    [navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    //[self.window setTintColor:[UIColor blackColor]];
    return YES;
}

- (DominosaViewController *)DominosaViewControllerForGame:(const game *)game
{
    NSString *name = [NSString stringWithUTF8String:game->name];
    BOOL inprogress = YES;
    NSString *saved = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.save", path, name] encoding:NSUTF8StringEncoding error:NULL];
    if (saved == nil) {
        saved = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.new", path, name] encoding:NSUTF8StringEncoding error:NULL];
        inprogress = NO;
    } else {
    }
    DominosaViewController *vc = nil;
    if (!isPad) {
        vc = [[DominosaViewController alloc] initWithNibName:@"DominosaViewController" bundle:nil];
    } else {
        vc = [[DominosaViewController alloc] initWithNibName:@"DominosaViewController_iPad" bundle:nil];
    }
    vc.thegame = game;
    vc.saver = self;
    vc.saved = saved;
    vc.init_inprogress = inprogress;
    return vc;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveGame:(NSString *)name state:(NSString *)save inprogress:(BOOL)inprogress {
    if (inprogress) {
        [g_InProgress addObject:name];
    } else {
        [g_InProgress removeObject:name];
    }
    [save writeToFile:[NSString stringWithFormat:@"%@/%@.%@", path, name, (inprogress ? @"save" : @"new")] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    if (!inprogress) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.save", path, name] error:NULL];
    }
}

@end
