//
//  AJVerticalPlayerView.m
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJVerticalPlayerView.h"
#import "UIColor+Additions.h"

@interface AJVerticalPlayerView() {
    UIButton *_nameButton;
}

@end

@implementation AJVerticalPlayerView

@synthesize name = _name;
@synthesize scores = _scores;
@synthesize color = _color;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name andScores:(NSArray *)scores andColor:(NSString *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name = name;
        self.scores = scores;
        self.color = color;
        
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameButton.frame = CGRectMake(0.0, 0.0, 120.0, 50.0);
        [_nameButton setTitle:name forState:UIControlStateNormal];
        [_nameButton setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
        [_nameButton setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
        [self addSubview:_nameButton];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [_scores release];
    [_color release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
