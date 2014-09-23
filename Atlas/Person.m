//
//  Person.m
//  Atlas
//
//  Created by Jason Welch on 9/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Person.h"
#import "Atlas.h"

@implementation Person

@synthesize email;
@synthesize likesToHaveFun;
@synthesize name;
@synthesize createdAt;

@dynamic attributes; // From super class

- (void) printMe {
    NSLog(@"\n\n***PERSON VALUES***\n\nName: %@\nEmail: %@\nLikes to have fun: %@\n\n", self.name, self.email, ((self.likesToHaveFun)? @"YES" : @"NO"));
}

- (void) setAttributes:(NSDictionary*)receivedAttributes {
    [super setAttributes:receivedAttributes];

    for (NSString *key in self.attributes) {
        if ([key isEqualToString:@"name"]) {
            self.name = [self.attributes valueForKey:key];
        } else if ([key isEqualToString:@"createdAt"]) {
            self.createdAt = [self.attributes valueForKey:key];
        } else { // Just adding values so that printMe will run without crashing
            self.email = @"person@example.com";
            self.likesToHaveFun = [NSNumber numberWithBool:YES];
        }
    }
}

/*
- (id) initWithAttributes:(NSDictionary*)sentAttributes {
    if (self) {
        self = [super initWithAttributes:sentAttributes];
        id thisPerson = [Atlas fetchForReturnWithAttributes:sentAttributes className:NSStringFromClass([self class])];
        [thisPerson printMe];
//        self = thisPerson;
        return [Atlas fetchForReturnWithAttributes:sentAttributes className:NSStringFromClass([self class])];
    }
    else return nil;
}
*/
@end
