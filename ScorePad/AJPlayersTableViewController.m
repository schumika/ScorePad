//
//  AJPlayersTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayersTableViewController.h"
#import "AJScoresManager.h"

@interface AJPlayersTableViewController ()

@end

@implementation AJPlayersTableViewController

@synthesize game = _game;

- (void)loadData {
    _playersArray = [[[AJScoresManager sharedInstance] getAllPlayersForGame:self.game] retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.game.name;
    
    [self loadData];
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
    static NSString *gameCellIdentifier = @"PlayerCell";
    static NSString *newGameCellIdentifier = @"NewPlayerCell";
    
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
        cell.textLabel.text = [player name];
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
