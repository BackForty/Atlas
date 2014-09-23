//
//  Person.h
//  Atlas
//
//  Created by Jason Welch on 9/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtlasModel.h"

@interface Person : AtlasModel

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * likesToHaveFun;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate *createdAt;

- (void) printMe;

@end
