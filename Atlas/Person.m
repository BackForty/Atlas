//
//  Person.m
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Person.h"


@implementation Person

@dynamic email;
@dynamic name;
@dynamic likesToHaveFun;

- (void) printMe {
    NSLog(@"\n\n***PERSON VALUES***\n\nName: %@\nEmail: %@\nLikes to have fun: %@\n\n", self.name, self.email, ((self.likesToHaveFun)? @"YES" : @"NO"));
}

@end
