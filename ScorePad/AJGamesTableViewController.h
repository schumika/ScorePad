//
//  AJGamesTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJGamesTableViewController : UITableViewController <UITextFieldDelegate> {
    NSArray *_gamesArray;
    
    UIBarButtonItem *_editBarButton;
    UIBarButtonItem *_doneBarButton;
    
    UITextField *_newGametextField;
}

@property (nonatomic, retain) NSArray *gamesArray;

@end
