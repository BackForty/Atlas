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

@synthesize attributes;

#pragma mark - Custom setters

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

@end
