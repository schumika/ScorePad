//
//  AJGamesTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGamesTableViewController.h"
#import "AJScoresManager.h"

#import "AJGame+Additions.h"

@interface AJGamesTableViewController ()

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
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blueColor];
        }
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"+ New Game";
    } else {
        cell.textLabel.text = [(AJGame *)[_gamesArray objectAtIndex:indexPath.row] name];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }  
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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
    if (indexPath.section == 1) {
        int maxNo = [tableView numberOfRowsInSection:0];
        [[AJScoresManager sharedInstance] addGameWithName:[NSString stringWithFormat:@"Game %d", maxNo] andRowId:maxNo+1];
        
        [self loadDataAndUpdateUI:YES];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Buttons Actions

- (IBAction)editButtonClicked:(id)sender {
    [self setEditing:YES animated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self setEditing:NO animated:YES];
}

@end
