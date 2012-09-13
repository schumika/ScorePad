//
//  UIImage+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)defaultGamePicture {
    return [UIImage imageNamed:@"cards_icon.png"];
}

+ (UIImage *)defaultPlayerPicture {
    return [UIImage imageNamed:@"main_tile_default_pic.png"];
}

@end
