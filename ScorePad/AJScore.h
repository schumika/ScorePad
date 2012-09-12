//
//  AJScore.h
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJScore : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) AJPlayer *player;

@end
