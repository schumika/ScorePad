//
//  AJPlayersTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayersTableViewController.h"
#import "AJScoresManager.h"

#import "NSString+Additions.h"
#import "UIColor+Additions.h"

@interface AJPlayersTableViewController ()

@end

@implementation AJPlayersTableViewController

@synthesize game = _game;

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    _playersArray = [[[AJScoresManager sharedInstance] getAllPlayersForGame:self.game] retain];
    if (updateUI) {
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.game.name;
    
    self.tableView.rowHeight = 65.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDataAndUpdateUI:YES];
}

- (void)dealloc {
    [_game release];
    [_playersArray release];
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [_playersArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playerCellIdentifier = @"PlayerCell";
    static NSString *newPlayerCellIdentifier = @"NewPlayerCell";
    
    NSString *CellIdentifier = (indexPath.section == 0) ? playerCellIdentifier : newPlayerCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            CGRect textFieldRect = cell.contentView.bounds;
            textFieldRect.origin.y = ceil((textFieldRect.size.height - 31.0) / 2.0);
            textFieldRect.size.height = 31.0;
            _newPlayerTextField= [[UITextField alloc] initWithFrame:textFieldRect];
            _newPlayerTextField.borderStyle = UITextBorderStyleNone;
            _newPlayerTextField.backgroundColor = [UIColor clearColor];
            _newPlayerTextField.font = [UIFont boldSystemFontOfSize:20.0];
            _newPlayerTextField.textColor = [UIColor blueColor];
            _newPlayerTextField.placeholder = @"Add New Player ...";
            _newPlayerTextField.text = @"";
            _newPlayerTextField.delegate = self;
            _newPlayerTextField.textAlignment = UITextAlignmentCenter;
            _newPlayerTextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:_newPlayerTextField];
            [_newPlayerTextField release];
        }
    }
    
    if (indexPath.section == 0) {
        AJPlayer *player = (AJPlayer *)[_playersArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:[player color]];
        cell.textLabel.text = [player name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", [player totalScore]];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[AJScoresManager sharedInstance] deletePlayer:[_playersArray objectAtIndex:indexPath.row]];
        [self loadDataAndUpdateUI:NO];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView reloadData];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.editing) return;
    
    if (indexPath.section == 1) {
        [_newPlayerTextField becomeFirstResponder];
    } else {
        AJPlayer *player = [_playersArray objectAtIndex:indexPath.row];
        [[AJScoresManager sharedInstance] createScoreWithValue:10.0 inRound:([player.scores count]+1) forPlayer:player];
        [self loadDataAndUpdateUI:YES];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_newPlayerTextField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createPlayerWithName:text forGame:self.game];
        [_newPlayerTextField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

@end
