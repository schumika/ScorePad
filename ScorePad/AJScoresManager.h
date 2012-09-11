//
//  AJScoresManager.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"

@interface AJScoresManager : NSObject

+ (AJScoresManager *)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Public methods
- (NSArray *)getGamesArray;
- (void)addGameWithName:(NSString *)name andRowId:(int)rowId;
- (void)deleteGame:(AJGame *)game;
- (NSArray *)getAllPlayersForGame:(AJGame *)game;
- (AJPlayer *)createPlayerWithName:(NSString *)playerName forGame:(AJGame *)game;

// Other public methods
- (BOOL)saveContext;

// Methods used for testing
- (NSArray *)getDummyData;

@end
