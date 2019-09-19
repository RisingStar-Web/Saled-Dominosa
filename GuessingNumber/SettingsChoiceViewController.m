//
//  SettingsChoiceViewController.m
//  Dominosa
//
//  Created by Anjona on 12/03/13.
//  Copyright (c) 2018 Anjona. All rights reserved.
//

#import "SettingsChoiceViewController.h"
#import "Utils.h"

extern BOOL isPad;
extern BOOL isPhoneX;

@interface SettingsChoiceViewController ()

@end

@implementation SettingsChoiceViewController {
    const game *thegame;
    int index;
    NSArray *choices;
    id<GameSettingsChoiceDelegate> delegate;
    int value;
}

- (id)initWithGame:(const game *)game index:(int)ind choices:(NSArray *)ch value:(int)val title:(NSString *)title delegate:(id<GameSettingsChoiceDelegate>)d
{
    self = [super initWithNibName:@"SettingViewController" bundle:nil];
    if (self) {
        // Custom initialization
        thegame = game;
        index = ind;
        choices = ch;
        delegate = d;
        value = val;
        self.title = title;
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
    // Return the number of rows in the section.
    return choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = choices[indexPath.row];
    if (indexPath.row == value) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [delegate didSelectChoice:index value:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
