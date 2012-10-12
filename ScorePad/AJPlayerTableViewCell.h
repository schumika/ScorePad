//
//  AJPlayerTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJPlayerTableViewCell : UITableViewCell {
    NSString *_name;
    NSString *_color;
    UIImage *_picture;
    double _totalScores;
    int _numberOfRounds;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, assign) double totalScores;
@property (nonatomic, assign) int numberOfRounds;

@end
