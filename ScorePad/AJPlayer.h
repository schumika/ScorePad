//
//  AJPlayer.h
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJGame;

@interface AJPlayer : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) AJGame *game;
@property (nonatomic, retain) NSSet *scores;
@end

@interface AJPlayer (CoreDataGeneratedAccessors)

- (void)addScoresObject:(NSManagedObject *)value;
- (void)removeScoresObject:(NSManagedObject *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;
@end
