//
//  SettingsChoiceViewController.h
//  Dominosa
//
//  Created by Anjona on 12/03/13.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "cores.h"

@protocol GameSettingsChoiceDelegate <NSObject>

- (void)didSelectChoice:(int)index value:(int)value;

@end

@interface SettingsChoiceViewController : UIViewController {
    IBOutlet UILabel *_titleLabel;
    IBOutlet NSLayoutConstraint *topLayout;
}

- (id)initWithGame:(const game *)game index:(int)index choices:(NSArray *)choices value:(int)value title:(NSString *)title delegate:(id<GameSettingsChoiceDelegate>)delegate;
@property (nonatomic, retain) IBOutlet UITableView *settingView;

@end
