//
//  AtlasModel.m
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "AtlasModel.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Person.h"

@interface AtlasModel ()
#define RunningLog if(0); else NSLog
@property (strong, nonatomic) Atlas* atlas;
@end

@implementation AtlasModel

@synthesize attributes;
@synthesize atlas;
@synthesize className;

#pragma mark - Custom setter

- (void) setAttributes:(NSDictionary*)receivedAttributes {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    // Embedded inits

    if (!className)
        className = NSStringFromClass([self class]);

    // Handling existing attributes
    if (attributes) {

        NSDictionary *oldValue = attributes;
        NSDictionary *sentValue = receivedAttributes;
        NSMutableDictionary *newValue = [[NSMutableDictionary alloc] initWithDictionary:oldValue];

        for (NSString *key in sentValue) {
            if (oldValue[key]) {
                [newValue removeObjectForKey:key];
            }
            [newValue setObject:sentValue[key] forKey:key];
        }
        attributes = [NSDictionary dictionaryWithDictionary:newValue];
    }
    else attributes = receivedAttributes; // Assign new attributes
}

- (void) save {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if (!atlas) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            atlas = [[Atlas alloc] init];
        });
        //        [atlas setupCoreData];
    }
    [atlas saveClassNamed:className withAttributes:attributes];
}

+ (id) withAttributes:(NSDictionary*)receivedAttributes {
    AtlasModel *newAM = [[AtlasModel alloc] init];
    newAM.attributes = receivedAttributes;

    return newAM;
}

//- (BOOL) existsInCoreData {
//    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
//    NSPredicate *filter = [NSPredicate predicateWithFormat:@"id == %@", attributes[@"id"]];
//    [request setPredicate:filter];
//
//    NSArray *fetchedObject = [atlas.coreDataDelegate.managedObjectContext executeFetchRequest:request error:nil];
//    if (fetchedObject.count == 1) {
//        return YES;
//    } else
//        return NO;
//}

@end
