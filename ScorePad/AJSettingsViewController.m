//
//  AJSettingsViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJSettingsViewController.h"
#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"

#import "UIColor+Additions.h"

@interface AJSettingsViewController ()

@end

@implementation AJSettingsViewController

@synthesize delegate = _delegate;
@synthesize item = _item;

- (void)dealloc {
    [_settingsDictionary release];
    [_item release];
    
    [super dealloc];
}

- (id)item {
    return _item;
}

- (void)setItem:(id)item {
    if (item != _item) {
        [_settingsDictionary release];        
        _settingsDictionary = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[item imageData] ? [item imageData] : UIImagePNGRepresentation([UIImage imageNamed:@"cards_icon.png"]),
                                                                            [item name], (NSString *)[item color], nil]
                                                                   forKeys:[NSArray arrayWithObjects:@"SettingsImageData", @"SettingsName", @"SettingsColor", nil]];
        
        [_item release];
        _item = [item retain];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ImageCellIdentifier = @"ImageCell";
    static NSString *NameCellIdentifier = @"NameCell";
    static NSString *ColorCellIdentifier = @"ColorCell";
    
    NSString *CellIdentifier = nil;
    switch (indexPath.row) {
        case 0:
            CellIdentifier = ImageCellIdentifier;
            break;
        case 1:
            CellIdentifier = NameCellIdentifier;
            break;
        case 2:
            CellIdentifier = ColorCellIdentifier;
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Image";
                break;
            case 1:
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = [_settingsDictionary objectForKey:@"SettingsName"];
                break;
            case 2:
                cell.textLabel.text = @"Color";
                cell.detailTextLabel.text = @"Color";
                cell.detailTextLabel.textColor = [UIColor colorWithHexString:[_settingsDictionary objectForKey:@"SettingsColor"]];
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [_settingsDictionary setObject:@"NewName" forKey:@"SettingsName"];
    }
}

#pragma mark - Buttons Actions

- (IBAction)cancelButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidFinishEditing:withDictionary:)]) {
        [self.delegate settingsViewControllerDidFinishEditing:self withDictionary:nil];
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidFinishEditing:withDictionary:)]) {
        [self.delegate settingsViewControllerDidFinishEditing:self withDictionary:_settingsDictionary];
    }
}

@end
