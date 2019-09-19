//
//  TypeViewController.m
//  Dominosa
//
//  Created by Anjona on 11/03/18.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import "TypeViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utils.h"

extern NSInteger gameType;
extern BOOL isPad;
extern BOOL isPhoneX;

@interface TypeViewController ()

@end

@implementation TypeViewController {
    const game *thegame;
    midend *me;
    DominosaView *gameview;
}

- (id)initWithGame:(const game *)game midend:(midend *)m gameview:(DominosaView *)gv
{
    self = [super initWithNibName:@"SettingViewController" bundle:nil];
    if (self) {
        // Custom initialization
        thegame = game;
        me = m;
        gameview = gv;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_titleLabel setText:NSLocalizedString(@"GAMETYPE", nil)];
    _settingView.rowHeight = isPad?88:44;
    if (isPhoneX) {
        topLayout.constant = 44;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return midend_num_presets(me) + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row < midend_num_presets(me)) {
            char *name;
            game_params *params;
            midend_fetch_preset(me, indexPath.row, &name, &params);
            NSString *str = [Utils localization:name];
            cell.textLabel.text = str;//[NSString stringWithUTF8String:name];
            if (indexPath.row == midend_which_preset(me)) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else {
            cell.textLabel.text = NSLocalizedString(@"CUSTOM", nil);
            if (midend_which_preset(me) < 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(isPad?34:17)];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row < midend_num_presets(me)) {
            char *name;
            game_params *params;
            midend_fetch_preset(me, indexPath.row, &name, &params);
            midend_set_params(me, params);
            [gameview startNewGame];
            gameType = indexPath.row;
            [[NSUserDefaults standardUserDefaults] setInteger:gameType forKey:KEY_GAME_TYPE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [gameview.delegate newGame];
            // bit of a hack here, gameview.nextResponder is actually the view controller we want
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            char *wintitle;
            config_item *config = midend_get_config(me, CFG_SETTINGS, &wintitle);
            [self.navigationController pushViewController:[[GameSettingsViewController alloc] initWithGame:thegame config:config type:CFG_SETTINGS title:[NSString stringWithUTF8String:wintitle] delegate:self] animated:YES];
            free(wintitle);
        }
    }
}

- (void)didApply:(config_item *)config
{
    char *msg = midend_set_config(me, CFG_SETTINGS, config);
    if (msg) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE", nil) message:[NSString stringWithUTF8String:msg] delegate:nil cancelButtonTitle:NSLocalizedString(@"CLOSE", nil) otherButtonTitles:nil] show];
    } else {
        gameType = midend_num_presets(me);
        [[NSUserDefaults standardUserDefaults] setInteger:gameType forKey:KEY_GAME_TYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [gameview startNewGame];
        [gameview.delegate newGame];
        // bit of a hack here, gameview.nextResponder is actually the view controller we want
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
