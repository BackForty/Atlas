//
//  CoreDataHelper.m
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper
#define RunningLog if(0); else NSLog

#pragma mark - FILES
NSString *storeFilename = @"Atlas.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}
- (NSURL *)applicationStoresDirectory {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {

                NSLog(@"Successfully created Stores directory");
        }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}
- (NSURL *)storeURL {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SETUP
- (id)init {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    self = [super init];
    if (!self) {return nil;}

    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc]
                initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    return self;
}
- (void)loadStore {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if (_store) {return;} // Don’t load store if it's already loaded

    NSDictionary *options =
    @{NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};

    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {NSLog(@"Successfully added store: %@", _store);}
}
- (void)setupCoreData {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    [self loadStore];
}

#pragma mark - SAVING
- (void)saveContext {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

@end

