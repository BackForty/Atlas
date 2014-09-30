//
//  AtlasModel.h
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Atlas.h"

@interface AtlasModel : NSManagedObject

@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic, readonly) Atlas* atlas;

-(void) save;

+ (id) withAttributes:(NSDictionary*)attributes;
@end
