//
//  Atlas.m
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Atlas.h"

@interface Atlas ()
#define RunningLog if(0); else NSLog
@end

@implementation Atlas

+ (id) fetchForReturnWithAttributes:(NSDictionary*)sentAttributes className:(NSString*)className {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    CoreDataHelper *cdh = [(AppDelegate*) [[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    NSArray *fetchedObjects = [NSArray new];
    NSPredicate *filter = [NSPredicate new];

    // Making sure all elements match the object being retrieved
    NSMutableArray *allFilters = [NSMutableArray new];
    NSString *predicateString = [NSString new];
    for (NSString *key in sentAttributes) {
        id thisAttribute = sentAttributes[key];

        // Extra quotes are needed when searching for a string value
        if ([thisAttribute isKindOfClass:[NSString class]]) {
            predicateString = [NSString stringWithFormat:@"%@ == '%@'", key, thisAttribute];
        } else {
            predicateString = [NSString stringWithFormat:@"%@ == %@", key, thisAttribute];
        }
        [allFilters addObject:[NSPredicate predicateWithFormat:predicateString]];
        NSLog(@"Created Predicate with format: %@ == '%@'", key, thisAttribute);

        filter = [NSCompoundPredicate orPredicateWithSubpredicates:allFilters];
        [request setPredicate:filter];

        NSLog(@"Predicate Format: %@", filter.predicateFormat);

        fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
        if (fetchedObjects.count == 0) {
            [allFilters removeLastObject];
            NSLog(@"Found no match for Predicate: %@\nPredicate Removed", filter.predicateFormat);
        } else if (fetchedObjects.count == 1) {
            NSLog(@"Search narrowed down to one match. Completing fetch request");
            break;
        }
    }

    return [fetchedObjects firstObject];
}

@end
