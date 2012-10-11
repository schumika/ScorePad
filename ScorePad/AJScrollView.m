//
//  AJScrollView.m
//  ScorePad
//
//  Created by Anca Calugar on 10/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScrollView.h"

@implementation AJScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];*/
        
    }
    return self;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panRecognizer {
    if (panRecognizer.state == UIGestureRecognizerStateChanged || panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panRecognizer translationInView:self];
        NSLog(@"gesture changed point %@", NSStringFromCGPoint(translation));
        
        if (ABS(translation.y) < 30.0) {
            [self setContentOffset:CGPointMake(-translation.x, 0.0)];
        } else {
            [self setContentOffset:CGPointMake(-translation.x, -translation.y)];
        }
        
        //[panRecognizer setTranslation:CGPointZero inView:self];
    }
}

@end
