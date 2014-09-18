//
//  AtlasModel.m
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "AtlasModel.h"
#import <objc/runtime.h>

@interface AtlasModel ()
#define RunningLog if(0); else NSLog
@property (strong, nonatomic) NSArray *propertyKeys;
@property (strong, nonatomic) id obj;
@end

@implementation AtlasModel

#pragma mark - Custom Inits

- (id) init {

    if (self) {
        self = [super init];

        // Create arrays of property strings and valid value types
        id obj = self;
        [self arrayKeysForObject:obj];

        return self;
    }
    else return nil;
}

- (id) initWithAttributes:(NSDictionary*)attributes {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if (self) {
        self = [super init];
        self.obj = self;

        [self updateWithAttributes:attributes];

        self = self.obj;
        return self;
    }
    else return nil;
}

-(void)updateWithAttributes: (NSDictionary*)attributes {

    // To use for an Alert or log
    NSMutableArray *invalidPropNames = [NSMutableArray new];
    NSString *errorMessage = @"The following properties were not loaded properly:\n";

    // These property strings are then paired with bools (in NSNumber format) telling whether or not the received obj has such properties
    NSDictionary *keyValidation = [self validateKeysInAttributes:attributes forObject:self.obj];

    for (NSString *propertyName in attributes) {
        BOOL isValid = NO;

        if ([self.propertyKeys containsObject:propertyName]) {
            isValid = [[keyValidation valueForKey:propertyName] boolValue];

            if (isValid) {
                [self.obj setObject:[attributes valueForKey:propertyName] forKey:propertyName];
            }
        }
        if (!isValid) {
            [invalidPropNames addObject:propertyName];
        }
    }
    for (NSString *invalidProp in invalidPropNames) {
        errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@\n", invalidProp]];
    }
    NSLog(@"%@", errorMessage);
}

// Uses the objc/runtime ability to determine a class's property and stuffs a string of that property in an array to be returned
- (void) arrayKeysForObject: (id)obj {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    NSMutableArray *propertyNames = [NSMutableArray new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);

    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        [propertyNames addObject:[NSString stringWithFormat:@"%s",propName]];
    }

    self.propertyKeys = [NSArray arrayWithArray:propertyNames];
}

// Checking to see if the values in the sent dictionary are the right class types
- (NSDictionary*) validateKeysInAttributes: (NSDictionary*)attributes forObject: (id)obj {
    RunningLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    NSMutableDictionary *validating = [NSMutableDictionary new];

    for (NSString *propName in self.propertyKeys) {
        BOOL valid = NO;

        if ([attributes valueForKey:propName]) {
            if ([[obj valueForKey:propName] isKindOfClass:[[attributes valueForKey:propName] class]]) {
                valid = YES;
            }
          /*  else if ([[[attributes valueForKey:propName] class] isKindOfClass:[NSNumber class]]) {
                NSNumber *couldBeBool = [attributes valueForKey:propName];
                if ([couldBeBool isEqual: @0] || [couldBeBool  isEqual: @1]) {
                    valid = YES;
                }
            } */
        }
        [validating setObject:[NSNumber numberWithBool:valid] forKey:propName];
    }

    return [NSDictionary dictionaryWithDictionary:validating];
}

@end
