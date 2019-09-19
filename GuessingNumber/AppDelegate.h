//
//  DominosaAppDelegate.h
//  Dominosa
//
//  Created by Anjona Inc. on 6/4/12.
//  Copyright (c) 2012 Anjona Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"
#import "DominosaViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,DominosaViewControllerSaver> {
    NSString *path;
}

@property (strong, nonatomic) DominosaViewController *dominosaVC;
@property (strong, nonatomic) DominosaViewController *inertiaVC;
@property (strong, nonatomic) DominosaViewController *pegsVC;
@property (strong, nonatomic) DominosaViewController *lightupVC;

@property (strong, nonatomic) UIWindow *window;

- (void)switchGame:(NSInteger)index isInit:(BOOL)isInit;

@end
