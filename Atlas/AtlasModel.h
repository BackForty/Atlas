//
//  AtlasModel.h
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import "Atlas.h"

@interface AtlasModel : NSManagedObject

@property (strong, nonatomic) NSDictionary *attributes;

@end
