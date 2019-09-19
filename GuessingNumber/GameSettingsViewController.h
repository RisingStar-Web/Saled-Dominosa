//
//  GameSettingsViewController.h
//  Dominosa
//
//  Created by Anjona on 11/03/18.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsChoiceViewController.h"

#include "cores.h"

@protocol GameSettingsDelegate <NSObject>

- (void)didApply:(config_item *)config;

@end

@interface GameSettingsViewController : UIViewController <GameSettingsChoiceDelegate> {
    IBOutlet UILabel *_titleLabel;
    IBOutlet NSLayoutConstraint *topLayout;
}

- (id)initWithGame:(const game *)game config:(config_item *)config type:(int)type title:(NSString *)title delegate:(id<GameSettingsDelegate>)delegate;

@property (nonatomic, retain) IBOutlet UITableView *settingView;

@end
