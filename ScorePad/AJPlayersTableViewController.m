//
//  AJPlayersTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayersTableViewController.h"
#import "AJScoresTableViewController.h"
#import "AJSettingsViewController.h"
#import "AJScoresManager.h"

#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

@interface AJPlayersTableViewController ()

@end

@implementation AJPlayersTableViewController

@synthesize game = _game;

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    _playersArray = [[[AJScoresManager sharedInstance] getAllPlayersForGame:self.game] retain];
    self.title = self.game.name;
    if (updateUI) {
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 65.0;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(settingsButtonClicked:)] autorelease];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
        
        if (player.imageData == nil) {
            cell.imageView.image = [UIImage defaultPlayerPicture];
        } else {
            cell.imageView.image = [UIImage imageWithData:player.imageData];
        }
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
        AJScoresTableViewController *scoresViewController = [[AJScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
        scoresViewController.player = [_playersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:scoresViewController animated:YES];
        [scoresViewController release];
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

#pragma mark - Buttons Action

- (IBAction)settingsButtonClicked:(id)sender {
    /*AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingsViewController.item = self.game;*/
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithImageData:self.game.imageData ? self.game.imageData : UIImagePNGRepresentation([UIImage imageNamed:@"cards_icon.png"])
                                                                                                   andName:self.game.name andColorString:self.game.color];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

#pragma mark - AJSettingsViewControllerDelegate methods

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withDictionary:(NSDictionary *)dictionary {
    [dictionary retain];
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (dictionary != nil) {
        [self.game setName:[dictionary objectForKey:kSettingsNameKey]];
        [self.game setColor:[dictionary objectForKey:kSettingsColorKey]];
        [self.game setImageData:[dictionary objectForKey:kSettingsImageKey]];
    }
    
    [dictionary release];
    
    [[AJScoresManager sharedInstance] saveContext];
    [self loadDataAndUpdateUI:YES];
}

@end
