//
//  AJScoresTableViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPlayer+Additions.h"

@interface AJScoresTableViewController : UITableViewController {
    NSArray *_scoresArray;
}

@property (nonatomic, retain) AJPlayer *player;

@end
