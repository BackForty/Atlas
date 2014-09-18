//
//  AtlasModel.h
//  Atlas
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtlasModel : NSObject

@property (strong, nonatomic) NSDictionary *attributes;

- (id) initWithAttributes:(NSDictionary*)attributes;

@end
