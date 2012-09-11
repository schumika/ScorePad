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
    
    [super dealloc];
}

- (void)loadData {
    self.gamesArray = [[AJScoresManager sharedInstance] getGamesArray];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Score Pad";
    [self loadData];
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
        int maxNo = [tableView numberOfRowsInSection:0];
        [[AJScoresManager sharedInstance] addGameWithName:[NSString stringWithFormat:@"Game %d", maxNo] andRowId:maxNo+1];
        
        [self loadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
