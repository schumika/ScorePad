//
//  AJGamesTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGamesTableViewController.h"
#import "AJPlayersTableViewController.h"
#import "AJScoresManager.h"
#import "AJTableViewController.h"
#import "AJGameTableViewCell.h"

#import "AJGame+Additions.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

@interface AJGamesTableViewController ()

- (void)updateRowIdsForGames;

@end


@implementation AJGamesTableViewController

@synthesize gamesArray = _gamesArray;

- (void)dealloc {
    [_gamesArray release];
    
    [_editBarButton release];
    [_doneBarButton release];
    
    [super dealloc];
}

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.gamesArray = [[AJScoresManager sharedInstance] getGamesArray];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _editBarButton = [[UIBarButtonItem clearBarButtonItemWithTitle:@"Edit" target:self action:@selector(editButtonClicked:)] retain];
    _doneBarButton = [[UIBarButtonItem clearBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)] retain];
    
    self.navigationItem.rightBarButtonItem = _editBarButton;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.rowHeight = 70.0;
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString*)titleViewText {
	return @"Score Pad";
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
    return (section == 0) ? [self.gamesArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gameCellIdentifier = @"GameCell";
    static NSString *newGameCellIdentifier = @"NewGameCell";
    
    UITableViewCell *aCell = nil;
    
    if (indexPath.section == 0) {
        AJGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
        
        if (cell == nil) {
            cell = [[[AJGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gameCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        AJGame *game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        cell.name = game.name;
        int playersNumber = [[game players] count];
        cell.numberOfPlayers = playersNumber;
        
        if (game.imageData == nil) {
            cell.picture = [UIImage defaultGamePicture];
        } else {
            cell.picture = [UIImage imageWithData:game.imageData];
        }
        
        aCell = cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newGameCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newGameCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            CGRect textFieldRect = cell.contentView.bounds;
            textFieldRect.origin.y = ceil((textFieldRect.size.height - 31.0) / 2.0);
            textFieldRect.size.height = 31.0;
            _newGametextField= [[UITextField alloc] initWithFrame:textFieldRect];
            _newGametextField.borderStyle = UITextBorderStyleNone;
            _newGametextField.backgroundColor = [UIColor clearColor];
            _newGametextField.font = [UIFont boldSystemFontOfSize:20.0];
            _newGametextField.textColor = [UIColor blueColor];
            _newGametextField.placeholder = @"Add New Game ...";
            _newGametextField.text = @"";
            _newGametextField.delegate = self;
            _newGametextField.textAlignment = UITextAlignmentCenter;
            _newGametextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:_newGametextField];
            [_newGametextField release];
        }
        aCell = cell;
    }
    
    return aCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[AJScoresManager sharedInstance] deleteGame:[self.gamesArray objectAtIndex:indexPath.row]];
        [self loadDataAndUpdateUI:NO];
        [self updateRowIdsForGames];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView reloadData];
    }  
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.gamesArray];
    AJGame *gameToMove = [[mutableArray objectAtIndex:fromIndexPath.row] retain];
    [mutableArray removeObjectAtIndex:fromIndexPath.row];
    [mutableArray insertObject:gameToMove atIndex:toIndexPath.row];
    [gameToMove release];
    [self setGamesArray:mutableArray];
    
    [self updateRowIdsForGames];
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) return;
    
    if (indexPath.section == 1) {
        [_newGametextField becomeFirstResponder];
    } else {        
        AJPlayersTableViewController *playersViewController = [[AJPlayersTableViewController alloc] initWithStyle:UITableViewStylePlain];
        playersViewController.game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:playersViewController animated:YES];
        [playersViewController release];
    }
}

#pragma mark - Buttons Actions


- (IBAction)editButtonClicked:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = _doneBarButton;
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = _editBarButton;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.tableView.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_newGametextField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        int maxNo = [self.tableView numberOfRowsInSection:0];
        [[AJScoresManager sharedInstance] addGameWithName:text andRowId:maxNo+1];
        [_newGametextField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)updateRowIdsForGames {
    int numberOfGames = [self.gamesArray count];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (AJGame *game in self.gamesArray) {
        game.rowId = [NSNumber numberWithInt:numberOfGames - [self.gamesArray indexOfObject:game]];
        [mutableArray addObject:game];
    }
    [self setGamesArray:mutableArray];
    
    [[AJScoresManager sharedInstance] saveContext];
}

@end
