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
    UILabel *_roundsPlayedLabel;
}

@end


@implementation AJPlayerTableViewCell

@synthesize name = _name;
@synthesize color = _color;
@synthesize picture = _picture;
@synthesize totalScores = _totalScores;
@synthesize numberOfRounds = _numberOfRounds;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_pictureView];
        [_pictureView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor brownColor];
        _nameLabel.font = [UIFont fontWithName:@"Thonburi" size:25.0];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _totalScoresLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalScoresLabel.backgroundColor = [UIColor clearColor];
        _totalScoresLabel.textColor = [UIColor brownColor];
        _totalScoresLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:40.0];
        _totalScoresLabel.adjustsFontSizeToFitWidth = YES;
        _totalScoresLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_totalScoresLabel];
        [_totalScoresLabel release];
        
        _roundsPlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundsPlayedLabel.backgroundColor = [UIColor clearColor];
        _roundsPlayedLabel.textColor = [UIColor grayColor];
        _roundsPlayedLabel.font = [UIFont fontWithName:@"Thonburi" size:15.0];
        _roundsPlayedLabel.adjustsFontSizeToFitWidth = YES;
        _roundsPlayedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_roundsPlayedLabel];
        [_roundsPlayedLabel release];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    _pictureView.frame = CGRectMake(5.0, ceil((cellHeight - 50.0) / 2.0), 50.0, 50.0);
    CGFloat pictureMaxX = CGRectGetMaxX(_pictureView.frame) + 20.0;
    _nameLabel.frame = CGRectMake(pictureMaxX, 0.0, cellWidth - pictureMaxX, 25.0);
    _totalScoresLabel.frame = CGRectMake(pictureMaxX + 10.0, CGRectGetMaxY(_nameLabel.frame), cellWidth - pictureMaxX - 10.0, cellHeight - CGRectGetMaxY(_nameLabel.frame) - 17.0);
    _roundsPlayedLabel.frame = CGRectMake(pictureMaxX, cellHeight - 17.0, cellWidth - pictureMaxX, 15.0);
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

- (void)setNumberOfRounds:(int)numberOfRounds {
    _numberOfRounds = numberOfRounds;
    
    _roundsPlayedLabel.text = [NSString stringWithFormat:@"%d %@ played", _numberOfRounds, (_numberOfRounds == 1) ? @"round" : @"rounds"];
}

@end
