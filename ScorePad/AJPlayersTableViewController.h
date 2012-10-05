//
//  AJPlayersTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"

#import "AJSettingsViewController.h"

@interface AJPlayersTableViewController : AJTableViewController <UITextFieldDelegate, AJSettingsViewControllerDelegate> {
    AJGame *_game;
    
    NSArray *_playersArray;
    
    UITextField *_newPlayerTextField;
}

@property (nonatomic, retain) AJGame *game;
@property (nonatomic, retain) NSArray *playersArray;

@end
