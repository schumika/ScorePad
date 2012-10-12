//
//  AJNewItemTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJNewItemTableViewCell.h"

@implementation AJNewItemTableViewCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect textFieldRect = CGRectMake(0.0, 0.0, 320.0, 60.0);
        textFieldRect.origin.y = ceil((textFieldRect.size.height - 31.0) / 2.0);
        textFieldRect.size.height = 31.0;
        _textField = [[UITextField alloc] initWithFrame:textFieldRect];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
        _textField.textColor = [UIColor darkGrayColor];
        _textField.textAlignment = UITextAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        [_textField release];
    }
    return self;
}

@end
