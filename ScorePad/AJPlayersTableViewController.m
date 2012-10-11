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
#import "AJVerticalPlayerView.h"
#import "AJSettingsInfo.h"
#import "AJScoresManager.h"

#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"


@interface AJPlayersTableViewController () {
    UIImageView *_backView;
}

- (void)prepareUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end


@implementation AJPlayersTableViewController

@synthesize game = _game;
@synthesize playersArray = _playersArray;

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.playersArray = [[AJScoresManager sharedInstance] getAllPlayersForGame:self.game];
    [self reloadTitleView];
    if (updateUI) {
        if (self.tableView.hidden == NO) {
            [self.tableView reloadData];
        } else {
            CGFloat playerViewWidth = (self.playersArray.count == 0) ? 0.0 : MAX(120.0, 480.0 / (self.playersArray.count));
            CGFloat maxScrollViewContentHeight = 50.0 + 30.0 * [self.game maxNumberOfScores];
            for (int playerIndex = 0; playerIndex < self.playersArray.count; playerIndex++) {
                AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:playerIndex];
                AJVerticalPlayerView *verticalPlayerView = [[AJVerticalPlayerView alloc] initWithFrame:CGRectMake(playerIndex * playerViewWidth, 0.0, playerViewWidth, maxScrollViewContentHeight)
                                                            andName:player.name andScores:[player scoreValues] andColor:player.color];
                [_scrollView addSubview:verticalPlayerView];
                [verticalPlayerView release];
            }
            _scrollView.contentSize = CGSizeMake(self.playersArray.count * 120.0, maxScrollViewContentHeight + 30.0);
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Portrait
    self.tableView.rowHeight = 65.0;
    
    // Landscape
    _backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape_background.png"]];
    [self.view addSubview:_backView];
    [_backView release];
    [_backView setHidden:YES];
    
    CGRect bounds = self.view.bounds;
    _scrollView = [[AJScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.height + 20.0, bounds.size.width)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [_scrollView setHidden:YES];
    [_scrollView release];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Settings" target:self action:@selector(settingsButtonClicked:)];
    self.navigationItem.leftBarButtonItem = [self backButtonItem];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareUIForInterfaceOrientation:self.interfaceOrientation];
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

- (NSString*)titleViewText {
	return self.game.name;
}

#pragma mark - Rotation methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareUIForInterfaceOrientation:toInterfaceOrientation];
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [self.playersArray count] : 1;
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
        AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:indexPath.row];
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
        [[AJScoresManager sharedInstance] deletePlayer:[self.playersArray objectAtIndex:indexPath.row]];
        [self loadDataAndUpdateUI:NO];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView reloadData];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) return;
    
    if (indexPath.section == 1) {
        [_newPlayerTextField becomeFirstResponder];
    } else {        
        AJScoresTableViewController *scoresViewController = [[AJScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
        scoresViewController.player = [self.playersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:scoresViewController animated:YES];
        [scoresViewController release];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.tableView.editing;
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
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithSettingsInfo:[self.game settingsInfo] andItemType:AJGameItem];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

#pragma mark - AJSettingsViewControllerDelegate methods

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withSettingsInfo:(AJSettingsInfo *)settingsInfo {
    [settingsInfo retain];
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (settingsInfo != nil) {
        [self.game setName:settingsInfo.name];
        [self.game setColor:settingsInfo.colorString];
        [self.game setImageData:settingsInfo.imageData];
    }
    
    [settingsInfo release];
    
    [[AJScoresManager sharedInstance] saveContext];
    [self loadDataAndUpdateUI:YES];
}

- (void)prepareUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.tableView.hidden = YES;
        _scrollView.hidden = NO;
        _backView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        _scrollView.hidden = YES;
        _backView.hidden = YES;
    }
}

@end
