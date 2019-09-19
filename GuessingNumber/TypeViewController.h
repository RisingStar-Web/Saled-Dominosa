//
//  TypeViewController.h
//  Dominosa
//
//  Created by Anjona on 11/03/18.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSettingsViewController.h"
#import "DominosaView.h"

@interface TypeViewController : UIViewController <GameSettingsDelegate> {
    IBOutlet UILabel *_titleLabel;
    IBOutlet NSLayoutConstraint *topLayout;
}

@property (nonatomic, retain) IBOutlet UITableView *settingView;

- (id)initWithGame:(const game *)game midend:(midend *)me gameview:(DominosaView *)gv;

@end
