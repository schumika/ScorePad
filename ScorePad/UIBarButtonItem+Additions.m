//
//  UIBarButtonItem+Additions.m
//  ScoreTracker
//
//  Created by Anca Julean on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"

@implementation UIBarButtonItem (Additions)

+ (UIBarButtonItem *)clearBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIBarButtonItem *barButtonItem = nil;
    
    UIImage *backImage = [[UIImage imageNamed:@"bar-button.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:15.0];
    
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.0 alpha:0.35] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize buttonSize = [title sizeWithFont:button.titleLabel.font];
    CGFloat marginSpace = 20.0f;
    button.frame = CGRectMake(0, 0, buttonSize.width + marginSpace, 30);
    
    barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    return barButtonItem;
}

@end
