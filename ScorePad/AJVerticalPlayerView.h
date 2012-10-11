//
//  AJVerticalPlayerView.h
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJVerticalPlayerView : UIView {
    NSString *_name;
    NSArray *_scores;
    NSString *_color;
    
    double _maxViewHeight;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, retain) NSArray *scores;

@property (nonatomic, assign) double maxViewHeight;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name andScores:(NSArray *)scores andColor:(NSString *)color;

@end
