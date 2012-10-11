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
        self.backgroundColor = [UIColor clearColor];
        self.name = name;
        self.scores = scores;
        self.color = color;
        
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameButton.frame = CGRectMake(0.0, 0.0, frame.size.width, 50.0);
        [_nameButton setTitle:name forState:UIControlStateNormal];
        [_nameButton setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
        [_nameButton setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
        [self addSubview:_nameButton];
        
        for (int scoreIndex = 0; scoreIndex < [self.scores count]; scoreIndex++) {
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0 + 30 * scoreIndex, frame.size.width, 30.0)];
            [scoreLabel setBackgroundColor:[UIColor clearColor]];
            [scoreLabel setTextAlignment:UITextAlignmentCenter];
            [scoreLabel setText:[NSString stringWithFormat:@"%g",[[scores objectAtIndex:scoreIndex] doubleValue]]];
            [self addSubview:scoreLabel];
            [scoreLabel release];
        }
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [_scores release];
    [_color release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef redColor = [UIColor lightGrayColor].CGColor;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextSetStrokeColorWithColor(context, redColor);
    CGContextStrokePath(context);
}

@end
