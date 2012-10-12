//
//  AJPlayerTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayerTableViewCell.h"

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"


@interface AJPlayerTableViewCell () {
    UIImageView *_pictureView;
    UILabel *_nameLabel;
    UILabel *_totalScoresLabel;
}

@end


@implementation AJPlayerTableViewCell

@synthesize name = _name;
@synthesize color = _color;
@synthesize picture = _picture;
@synthesize totalScores = _totalScores;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
        _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_pictureView];
        [_pictureView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 3.0, 240.0, 40.0)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor brownColor];
        _nameLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _totalScoresLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 40.0, 240.0, 20.0)];
        _totalScoresLabel.backgroundColor = [UIColor clearColor];
        _totalScoresLabel.textColor = [UIColor grayColor];
        _totalScoresLabel.font = [UIFont fontWithName:@"Thonburi" size:15.0];
        _totalScoresLabel.adjustsFontSizeToFitWidth = YES;
        _totalScoresLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_totalScoresLabel];
        [_totalScoresLabel release];
    }
    return self;
}


- (void)dealloc {
    [_name release];
    [_color release];
    [_picture release];
    
    [super dealloc];
}

- (void)setName:(NSString *)name {
    if (name != _name) {
        [_name release];
        _name = [name retain];
        
        _nameLabel.text = _name;
    }
}

- (void)setColor:(NSString *)color {
    if (color != _color) {
        [_color release];
        _color = [color retain];
        
        _nameLabel.textColor = [UIColor colorWithHexString:_color];
    }
}

- (void)setPicture:(UIImage *)picture {
    if (picture != _picture) {
        [_picture release];
        _picture = [picture retain];
        
        [_pictureView setImage:[_picture applyMask:[UIImage imageNamed:@"mask.png"]]];
    }
}

- (void)setTotalScores:(double)totalScores {
    _totalScores = totalScores;
    
    _totalScoresLabel.text = [NSString stringWithFormat:@"%g", _totalScores];
}


@end
