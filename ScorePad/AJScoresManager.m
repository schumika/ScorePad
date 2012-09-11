//
//  AJScoresManager.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoresManager.h"

@interface AJScoresManager()

- (NSURL *)applicationDocumentsDirectory;

- (void)insertDummyData;

@end


@implementation AJScoresManager

@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static AJScoresManager *sharedAJScoresManager = nil;

#pragma mark - Singleton methods

+ (AJScoresManager *)sharedAJScoresManager {
    if (sharedAJScoresManager == nil) {
        sharedAJScoresManager = [self alloc];
        [sharedAJScoresManager init];
    }
    
    return sharedAJScoresManager;
}

+ (AJScoresManager *)sharedInstance {
    return [self sharedAJScoresManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ScorePad" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ScorePadModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@ %@", error, error.userInfo);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Public methods

- (NSArray *)getGamesArray {        
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJGame"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rowId" ascending:NO]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)addGameWithName:(NSString *)name andRowId:(int)rowId {
    AJGame *game = [AJGame createGameWithName:name inManagedObjectContext:self.managedObjectContext];
    game.rowId = [NSNumber numberWithInt:rowId];
    
    [self saveContext];
}

- (void)deleteGame:(AJGame *)game {
    [[self managedObjectContext] deleteObject:game];
    
    [self saveContext];
}

#pragma mark - Other public methods

- (BOOL)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *mObjectContext = self.managedObjectContext;
    if (mObjectContext != nil) {
        if ([mObjectContext hasChanges] && ![mObjectContext save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, error.userInfo);
            return NO;
        }
    }
    return YES;
}

#pragma mark - Private methods

// Returns the URL to the application's Document directory
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertDummyData {
    NSManagedObjectContext *context = self.managedObjectContext;
    /*NSManagedObject *game1 = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    [game1 setValue:[NSNumber numberWithInt:1] forKey:@"rowId"];
    [game1 setValue:@"Game1" forKey:@"name"];
    NSManagedObject *game2 = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    [game2 setValue:[NSNumber numberWithInt:2] forKey:@"rowId"];
    [game2 setValue:@"Game2" forKey:@"name"];*/
    
    AJGame *game1 = [AJGame createGameWithName:@"game1" inManagedObjectContext:context];
    game1.rowId = [NSNumber numberWithInt:1];
    AJGame *game2 = [AJGame createGameWithName:@"game2" inManagedObjectContext:context];
    game2.rowId = [NSNumber numberWithInt:2];
    
    [self saveContext];
}

- (NSArray *)getDummyData {
    //[self insertDummyData];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJGame"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rowId" ascending:NO]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

@end
