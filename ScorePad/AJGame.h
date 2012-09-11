//
//  AJGame.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AJGame : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rowId;
@property (nonatomic, retain) NSSet *players;
@end

@interface AJGame (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(NSManagedObject *)value;
- (void)removePlayersObject:(NSManagedObject *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;
@end
