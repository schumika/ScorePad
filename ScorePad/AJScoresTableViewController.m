//
//  AJScoresTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoresTableViewController.h"
#import "AJScoresManager.h"

#import "NSString+Additions.h"

@interface AJScoresTableViewController ()

@end


@implementation AJScoresTableViewController

@synthesize player = _player;

- (void)dealloc {
    [_player release];
    [_scoresArray release];
    
    [super dealloc];
}

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
     _scoresArray = [[[AJScoresManager sharedInstance] getAllScoresForPlayer:self.player] retain];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.player.name;
    self.tableView.rowHeight = 35.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDataAndUpdateUI:YES];
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
    return (section == 0) ? _scoresArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ScoreCellIdentifier = @"ScoreCell";
    static NSString *NewScoreCellIdentifier = @"NewScoreCell";
    
    
    NSString *CellIdentifier = (indexPath.section == 0) ? ScoreCellIdentifier : NewScoreCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            _newScoreTextField = [[UITextField alloc] initWithFrame:cell.contentView.bounds];
            _newScoreTextField.borderStyle = UITextBorderStyleNone;
            _newScoreTextField.backgroundColor = [UIColor clearColor];
            _newScoreTextField.font = [UIFont boldSystemFontOfSize:20.0];
            _newScoreTextField.textColor = [UIColor blueColor];
            _newScoreTextField.placeholder = @"Add New Score ...";
            _newScoreTextField.text = @"";
            _newScoreTextField.delegate = self;
            _newScoreTextField.textAlignment = UITextAlignmentCenter;
            _newScoreTextField.returnKeyType = UIReturnKeyDone;
            _newScoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:_newScoreTextField];
            [_newScoreTextField release];
            
        }
    }
    
    if (indexPath.section == 0) {
        AJScore *score = [_scoresArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%g", score.value.doubleValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", score.round.intValue];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [_newScoreTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_newScoreTextField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createScoreWithValue:text.doubleValue inRound:([_scoresArray count] +1) forPlayer:self.player];
        [_newScoreTextField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

@end
