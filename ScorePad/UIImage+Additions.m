//
//  UIImage+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)staticImageNamed:(NSString *)imageName {
    static UIImage *i = nil;
	if (i == nil) {
		i = [[UIImage imageNamed:imageName] retain];
	}
	return i;
}

+ (UIImage *)defaultGamePicture {
    return [UIImage imageNamed:@"cards_icon.png"];
}

+ (UIImage *)defaultPlayerPicture {
    return [UIImage imageNamed:@"main_tile_default_pic.png"];
}

+ (UIImage *)separatorImage {
    return [UIImage imageNamed:@"separator.png"];
}

@end
