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

@dynamic email;
@dynamic likesToHaveFun;
@dynamic name;

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

- (void) printMe {
    NSLog(@"\n\n***PERSON VALUES***\n\nName: %@\nEmail: %@\nLikes to have fun: %@\n\n", self.name, self.email, ((self.likesToHaveFun)? @"YES" : @"NO"));
}

@end
