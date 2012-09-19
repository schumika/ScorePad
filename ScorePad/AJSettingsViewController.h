//
//  AJSettingsViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJSettingsViewControllerDelegate;

@interface AJSettingsViewController : UITableViewController {
    id _item;
    NSMutableDictionary *_settingsDictionary;
    
    id<AJSettingsViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) id item;

@property (nonatomic, assign) id<AJSettingsViewControllerDelegate> delegate;

@end


@protocol AJSettingsViewControllerDelegate<NSObject>

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withDictionary:(NSDictionary *)dictionary;

@end