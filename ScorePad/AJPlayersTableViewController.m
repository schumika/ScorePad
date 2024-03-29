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
#import "AJSettingsInfo.h"
#import "AJScoresManager.h"
#import "AJNewItemTableViewCell.h"
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
            // remove old vertical columns
            for (UIView *subView in [_scrollView subviews]) {
                [subView removeFromSuperview];
            }
            
            CGFloat playerViewWidth = (self.playersArray.count == 0) ? 0.0 : MAX(100.0, 480.0 / (self.playersArray.count));
            CGFloat maxScrollViewContentHeight = 60.0 + 30.0 * [self.game maxNumberOfScores];
            for (int playerIndex = 0; playerIndex < self.playersArray.count; playerIndex++) {
                AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:playerIndex];
                AJVerticalPlayerView *verticalPlayerView = [[AJVerticalPlayerView alloc] initWithFrame:CGRectMake(playerIndex * playerViewWidth, 0.0, playerViewWidth, maxScrollViewContentHeight)
                                                            andName:player.name andScores:[player scoreValues] andColor:player.color];
                verticalPlayerView.isFirstColumn = (playerIndex == 0);
                [verticalPlayerView setDelegate:self];
                [_scrollView addSubview:verticalPlayerView];
                [verticalPlayerView release];
            }
            _scrollView.contentSize = CGSizeMake(self.playersArray.count * 100.0, maxScrollViewContentHeight + 40.0);
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.tableView.rowHeight = 80.0;
    
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
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        AJPlayerTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:playerCellIdentifier];
        if (!aCell) {
            aCell = [[[AJPlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:playerCellIdentifier] autorelease];
            aCell.delegate = self;
            aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:indexPath.row];
        aCell.name = player.name; 
        aCell.color = player.color;
        int totalScore = [player totalScore];
        aCell.totalScores = totalScore;
        aCell.numberOfRounds = [[player scores] count];
        
        UIImage *playerImage = nil;
        if (player.imageData == nil) {
            playerImage  = [[UIImage defaultPlayerPicture] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        } else {
            playerImage = [[UIImage imageWithData:player.imageData] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        }
        
        aCell.picture = [playerImage applyMask:[UIImage imageNamed:@"mask.png"]];
        aCell.scoreTextField.text = @"";
        aCell.scoreTextField.placeholder = [NSString stringWithFormat:@"%g", ((AJScore *)[[player.scores allObjects] lastObject]).value.doubleValue];
        
        cell = aCell;
    } else {
        AJNewItemTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:newPlayerCellIdentifier];
        if (!aCell) {
            aCell = [[[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPlayerCellIdentifier] autorelease];
            aCell.accessoryType = UITableViewCellAccessoryNone;
        }
        aCell.textField.placeholder = @"Add New Player ...";
        aCell.textField.text = @"";
        aCell.textField.delegate = self;
        
        cell = aCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
        [((AJNewItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
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
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createPlayerWithName:text forGame:self.game];
        [textField setText:nil];
        
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
        
        [[AJScoresManager sharedInstance] saveContext];
        [self loadDataAndUpdateUI:YES];
    }
    
    [settingsInfo release];
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

#pragma mark - AJVerticalPlayerViewDelegate methods

- (void)verticalPlayerViewDidClickName:(AJVerticalPlayerView *)verticalPlayerView {
    AJScoresTableViewController *scoresViewController = [[AJScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
    scoresViewController.player = [self.playersArray objectAtIndex:[[_scrollView subviews] indexOfObject:verticalPlayerView]];
    [self.navigationController pushViewController:scoresViewController animated:YES];
    [scoresViewController release];
}

#pragma mark - AJPlayerTableViewCellDelegate methods

- (void)playerCellClickedPlusButton:(AJPlayerTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AJPlayer *player = [self.playersArray objectAtIndex:indexPath.row];
    
    [[AJScoresManager sharedInstance] createScoreWithValue:cell.scoreTextField.text.doubleValue
                                                   inRound:([[player scores] count] + 1) forPlayer:player];
    [cell.scoreTextField resignFirstResponder];
    [self loadDataAndUpdateUI:YES];
    
}

- (void)playerCellClickedMinusButton:(AJPlayerTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AJPlayer *player = [self.playersArray objectAtIndex:indexPath.row];
    
    [[AJScoresManager sharedInstance] createScoreWithValue:-(cell.scoreTextField.text.doubleValue)
                                                   inRound:([[player scores] count] + 1) forPlayer:player];
    [cell.scoreTextField resignFirstResponder];
    [self loadDataAndUpdateUI:YES];
}

@end
