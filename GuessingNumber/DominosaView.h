//
//  DominosaView.h
//  Dominosa
//
//  Created by Anjona on 7/03/13.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSettingsViewController.h"

#include "cores.h"

@protocol GameViewDelegate <NSObject>

- (void)newGame;
- (void)endGame;
- (void)failGame;
- (void)solveGame;
- (void)solveDone;

@end

@interface DominosaView : UIView <UIActionSheetDelegate, GameSettingsDelegate> {
}

- (id)initWithFrame:(CGRect)frame nc:(UINavigationController *)nc game:(const game *)g saved:(NSString *)saved inprogress:(BOOL)inprogress;
- (void)startNewGame;
- (NSString *)saveGameState_inprogress:(BOOL *)inprogress;

@property CGContextRef bitmap;
@property UILabel *statusbar;
@property UIToolbar *game_toolbar;
@property UIView *toolbar;
@property (nonatomic, retain) UIButton *redoBtn;
@property (nonatomic, retain) UIButton *undoBtn;
@property (nonatomic, retain) UIButton *menuBtn;
@property (nonatomic, retain) UIButton *restartBtn;
@property (nonatomic, assign) NSInteger offsetY;
@property (nonatomic, assign) id <GameViewDelegate> delegate;

- (void)doNewGame;

@end
