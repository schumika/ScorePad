//
//  AJVerticalPlayerView.m
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJVerticalPlayerView.h"
#import "UIColor+Additions.h"

@interface AJVerticalPlayerHeaderView : UIView {
    
    UIButton *_nameButton;
    UILabel *_totalLabel;
}

@property (nonatomic, readonly) UIButton *nameButton;
@property (nonatomic, readonly) UILabel *totalLabel;

@end


@interface AJVerticalPlayerView()

@end


@implementation AJVerticalPlayerView

@synthesize name = _name;
@synthesize scores = _scores;
@synthesize color = _color;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name andScores:(NSArray *)scores andColor:(NSString *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.name = name;
        self.scores = scores;
        self.color = color;
        
        AJVerticalPlayerHeaderView *headerView = [[AJVerticalPlayerHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 60.0)];
        [headerView.nameButton setTitle:self.name forState:UIControlStateNormal];
        [headerView.nameButton addTarget:self action:@selector(nameButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headerView];
        [headerView release];
        
        double sum = 0.0;
        for (int scoreIndex = 0; scoreIndex < [self.scores count]; scoreIndex++) {
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 60.0 + 30 * scoreIndex, frame.size.width, 30.0)];
            [scoreLabel setBackgroundColor:[UIColor clearColor]];
            [scoreLabel setTextAlignment:UITextAlignmentCenter];
            double value = [[scores objectAtIndex:scoreIndex] doubleValue];
            sum += value;
            [scoreLabel setText:[NSString stringWithFormat:@"%g", value]];
            [self addSubview:scoreLabel];
            [scoreLabel release];
        }
        [headerView.totalLabel setText:[NSString stringWithFormat:@"%g", sum]];
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

- (IBAction)nameButtonCliked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(verticalPlayerViewDidClickName:)]) {
        [self.delegate verticalPlayerViewDidClickName:self];
    }
}

@end



@implementation AJVerticalPlayerHeaderView

@synthesize nameButton = _nameButton;
@synthesize totalLabel = _totalLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    
    _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameButton.frame = CGRectMake(0.0, 0.0, frame.size.width, 40.0);
    _nameButton.backgroundColor = [UIColor clearColor];
    [_nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_nameButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_nameButton];
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 35.0, frame.size.width, 20.0)];
    [_totalLabel setBackgroundColor:[UIColor clearColor]];
    [_totalLabel setTextAlignment:UITextAlignmentCenter];
    [self addSubview:_totalLabel];
    [_totalLabel release];
    
    return self;
}

@end
