//
//  GameSettingsViewController.m
//  Dominosa
//
//  Created by Anjona on 11/03/18.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "Constants.h"
#import "SettingsChoiceViewController.h"
#import "Utils.h"

extern BOOL isPad;
extern BOOL isPhoneX;

@interface GameSettingsViewController ()

@end

@implementation GameSettingsViewController {
    const game *thegame;
    config_item *config_items;
    int type;
    id<GameSettingsDelegate> delegate;
    int num;
    NSArray *choiceText;
}

- (id)initWithGame:(const game *)game config:(config_item *)config type:(int)typ title:(NSString *)t delegate:(id<GameSettingsDelegate>)d
{
    self = [super initWithNibName:@"SettingViewController" bundle:nil];
    if (self) {
        // Custom initialization
        thegame = game;
        config_items = config;
        type = typ;
        delegate = d;
        self.title = t;
        NSMutableArray *choices = [[NSMutableArray alloc] init];
        num = 0;
        while (config_items[num].type != C_END) {
            [choices addObject:@[]];
            if (config_items[num].type == C_CHOICES) {
                //NSString *sval = [NSString stringWithUTF8String:config_items[num].sval];
                NSString *sval = [Utils localization:config_items[num].sval];
                NSCharacterSet *delim = [NSCharacterSet characterSetWithCharactersInString:[sval substringToIndex:1]];
                choices[num] = [[sval substringFromIndex:1] componentsSeparatedByCharactersInSet:delim];
            }
            num++;
        }
        choiceText = choices;
    }
    return self;
}

- (void)dealloc
{
    free_cfg(config_items);
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return num;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (type != CFG_SETTINGS) {
        if (section == 0) {
            return [Utils localization:config_items[0].name];
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    // Note that we are using a custom subview rather than accessoryView here because accessoryView:
    //   - prevents the display of the disclosure indicator
    //   - causes the table to truncate its text depending on the width of the accessoryView
    // Using a (manually positioned) custom subview prevents these unwanted behaviours
    int roffset = !IOS7() && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 40 : 5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            if (type == CFG_SETTINGS) {
                cell.textLabel.text = [Utils localization:config_items[indexPath.row].name];
                switch (config_items[indexPath.row].type) {
                    case C_STRING: {
                        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100-roffset, 0, 80, (isPad?88:44))];
                        text.tag = indexPath.row;
                        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
                        text.textAlignment = NSTextAlignmentRight;
                        text.text = [NSString stringWithUTF8String:config_items[indexPath.row].sval];
                        text.font = [UIFont fontWithName:@"HelveticaNeue" size:(isPad?34:17)];
                        [cell addSubview:text];
                        break;
                    }
                    case C_BOOLEAN: {
                        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80-roffset, ((isPad?88:44)-31)/2, 80, 31)];
                        sw.tag = indexPath.row;
                        [sw addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
                        sw.on = config_items[indexPath.row].ival;
                        [cell addSubview:sw];
                        break;
                    }
                    case C_CHOICES: {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200-roffset, 0, 165, (isPad?88:44))];
                        label.enabled = NO;
                        label.textAlignment = NSTextAlignmentRight;
                        label.text = choiceText[indexPath.row][config_items[indexPath.row].ival];
                        label.font = [UIFont fontWithName:@"HelveticaNeue" size:(isPad?34:17)];
                        [cell addSubview:label];
                        break;
                    }
                }
            } else {
                UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(20+roffset, 0, self.view.frame.size.width-(20+roffset)*2, (isPad?88:44))];
                text.tag = indexPath.row;
                [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
                text.text = [NSString stringWithUTF8String:config_items[indexPath.row].sval];
                [cell addSubview:text];
            }
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"APPLY", nil);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = LIGHTBG;
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(isPad?34:17)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_settingView reloadData];
}

- (void)valueChanged:(UIControl *)sender
{
    config_item *item = &config_items[sender.tag];
    switch (item->type) {
        case C_STRING: {
            UITextField *text = (UITextField *)sender;
            free(item->sval);
            item->sval = dupstr([text.text cStringUsingEncoding:NSUTF8StringEncoding]);
            break;
        }
        case C_BOOLEAN: {
            UISwitch *sw = (UISwitch *)sender;
            item->ival = sw.on;
            break;
        }
        case C_CHOICES: {
            break;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (config_items[indexPath.row].type == C_CHOICES) {
            NSArray *choices = choiceText[indexPath.row];
            int value = config_items[indexPath.row].ival;
            NSString *title = [Utils localization:config_items[indexPath.row].name];//[NSString stringWithUTF8String:config_items[indexPath.row].name];
            SettingsChoiceViewController *gscc = [[SettingsChoiceViewController alloc] initWithGame:thegame index:indexPath.row choices:choices value:value title:title delegate:self];
            [self.navigationController pushViewController:gscc animated:YES];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [delegate didApply:config_items];
    }
}

- (void)didSelectChoice:(int)index value:(int)value
{
    config_items[index].ival = value;
    [_settingView reloadData];
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
