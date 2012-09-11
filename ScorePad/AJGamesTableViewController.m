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

#import "AJGame+Additions.h"
#import "NSString+Additions.h"

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
    
    self.title = @"Score Pad";
    
    _editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    _doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = _editBarButton;
    
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [_gamesArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gameCellIdentifier = @"GameCell";
    static NSString *newGameCellIdentifier = @"NewGameCell";
    
    NSString *CellIdentifier = (indexPath.section == 0) ? gameCellIdentifier : newGameCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            CGRect textFieldRect = cell.contentView.bounds;
            textFieldRect.origin.y = ceil((textFieldRect.size.height - 31.0) / 2.0);
            textFieldRect.size.height = 31.0;
            _newGametextField= [[UITextField alloc] initWithFrame:textFieldRect];
            _newGametextField.borderStyle = UITextBorderStyleNone;
            _newGametextField.backgroundColor = [UIColor clearColor];
            _newGametextField.font = [UIFont boldSystemFontOfSize:20.0];
            _newGametextField.textColor = [UIColor blueColor];
            _newGametextField.placeholder = @"+ New Game ...";
            _newGametextField.text = @"";
            _newGametextField.delegate = self;
            _newGametextField.textAlignment = UITextAlignmentCenter;
            _newGametextField.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:_newGametextField];
            [_newGametextField release];
        }
    }
    
    if (indexPath.section == 0) {
        AJGame *game = (AJGame *)[_gamesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[game name]];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = editing ? _doneBarButton : _editBarButton;
    
    [super setEditing:editing animated:animated];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[AJScoresManager sharedInstance] deleteGame:[self.gamesArray objectAtIndex:indexPath.row]];
        [self loadDataAndUpdateUI:NO];
        [self updateRowIdsForGames];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    self.gamesArray = mutableArray;
    [mutableArray release];
    
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
    
    if (self.editing) return;
    
    if (indexPath.section == 1) {
        [_newGametextField becomeFirstResponder];
    } else {
        /*NSArray *players = [[AJScoresManager sharedInstance] getDummyData];
        //NSLog(@"players: %@", players);
        for (AJPlayer *player in players) {
            NSLog(@"player name: %@", player.name);
        }*/
        
        AJPlayersTableViewController *playersViewController = [[AJPlayersTableViewController alloc] initWithStyle:UITableViewStylePlain];
        playersViewController.game = (AJGame *)[_gamesArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:playersViewController animated:YES];
        [playersViewController release];
    }
}

#pragma mark - Buttons Actions

- (IBAction)editButtonClicked:(id)sender {
    [self setEditing:YES animated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self setEditing:NO animated:YES];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.editing;
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
    self.gamesArray = mutableArray;
    [mutableArray release];
    
    [[AJScoresManager sharedInstance] saveContext];
}

@end
