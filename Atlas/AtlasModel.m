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
#import "AppDelegate.h"
#import "Person.h"

static NSArray const *kPropertyKeys;

@interface AtlasModel ()
#define RunningLog if(0); else NSLog
@end

@implementation AtlasModel

@synthesize cdh;
@synthesize className;
@synthesize attributes;

#pragma mark - Custom Inits

- (id) init {

    if (self) {
        self = [super init];
        className = NSStringFromClass([self class]);

        // Create arrays of property strings and valid value types
        [self arrayKeysForObject];

        // Setup local Core Data Helper
        cdh = [(AppDelegate*) [[UIApplication sharedApplication] delegate] cdh];

//        [self addObserver:self forKeyPath:@"attributes"
//                  options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
//                  context:NULL];

        return self;
    }
    else return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"attributes"]) {
        NSDictionary *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSDictionary *sentValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSMutableDictionary *newValue = [[NSMutableDictionary alloc] initWithDictionary:oldValue];

        for (NSString *key in sentValue) {
            if (oldValue[key]) {
                [newValue removeObjectForKey:key];
            }
            [newValue setObject:sentValue[key] forKey:key];
        }

        [self setValue:[NSDictionary dictionaryWithDictionary:newValue] forKey:@"attributes"];
    }
}

- (void) setAttributes:(NSDictionary*)receivedAttributes {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

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
    else attributes = receivedAttributes;
}

- (id) initWithAttributes:(NSDictionary*)sentAttributes {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

//    NSMutableDictionary *

    if (self) {
        self = [self init];
        id obj = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:self.cdh.context];

        // To use for an Alert or log
        NSMutableArray *invalidPropNames = [NSMutableArray new];
        NSString *errorMessage = @"The following properties were not loaded properly:\n";

        // These property strings are then paired with bools (in NSNumber format) telling whether or not the received obj has such properties
        NSDictionary *keyValidation = [self validateKeysInAttributes:sentAttributes forObject:obj];

        for (NSString *propertyName in sentAttributes) {
            BOOL isValid = NO;

            if ([kPropertyKeys containsObject:propertyName]) {
                isValid = [[keyValidation valueForKey:propertyName] boolValue];

                if (isValid) {
                    // APPROVED AND SET!!
                    id thisProperty = [sentAttributes valueForKey:propertyName];
                    [obj setValue:thisProperty forKey:propertyName];
                }
            }
            if (!isValid) {
                [invalidPropNames addObject:propertyName];
            }
        }
        for (NSString *invalidProp in invalidPropNames) {
            errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@\n", invalidProp]];
        }
        if (invalidPropNames.count > 0) {
            NSLog(@"%@", errorMessage);
        }

//        Person *thisPerson = [Atlas fetchForReturnWithAttributes:sentAttributes className:className];
//        [thisPerson printMe];

        return self;
    }
    else return nil;
}

- (id) fetchForReturnWithAttributes:(NSDictionary*)sentAttributes {

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

// Uses the objc/runtime ability to determine a class's property and stuffs a string of that property in an array to be returned
- (void) arrayKeysForObject {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    NSMutableArray *propertyNames = [NSMutableArray new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);

    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        [propertyNames addObject:[NSString stringWithFormat:@"%s",propName]];
    }

    kPropertyKeys = [NSArray arrayWithArray:propertyNames];
}

// Checking to see if the values in the sent dictionary are the right class types
- (NSDictionary*) validateKeysInAttributes: (NSDictionary*)sentAttributes forObject: (id)obj {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    NSMutableDictionary *validating = [NSMutableDictionary new];

    for (NSString *propName in kPropertyKeys) {
        BOOL valid = NO;

        if ([sentAttributes valueForKey:propName]) {
            /*
            if ([[obj valueForKey:propName] isKindOfClass:[[sentAttributes valueForKey:propName] class]]) { */
                valid = YES;
//            }
        }
        [validating setObject:[NSNumber numberWithBool:valid] forKey:propName];
    }

    return [NSDictionary dictionaryWithDictionary:validating];
}

@end
