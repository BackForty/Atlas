//
//  AtlasTests.m
//  AtlasTests
//
//  Created by Jason Welch on 9/18/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//
// Importing the application specific header files
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Person.h"
#import "AtlasModel.h"
#import "CoreDataHelper.h"


@interface BasicTests : XCTestCase
    // Add instance variables for testing
@property (strong, nonatomic) Person *itsaMe;
@property (strong, nonatomic) Person *anotherPerson;

@end

@implementation BasicTests

#pragma mark - Setup and Teardown

- (void)setUp {
    [super setUp];

    _itsaMe = [[Person alloc] init];

    NSDictionary *personAttributes = @{
                                       @"name":@"Jason",
                                       @"email":@"jason@inthebackforty.com",
                                       @"likesToHaveFun":[NSNumber numberWithBool:YES],
                                       };

    _itsaMe.attributes = personAttributes;
    NSLog(@"\n\nATTRIBUTES: %@", _itsaMe.attributes);

//    NSMutableDictionary *includeID = [[NSMutableDictionary alloc] initWithDictionary:personAttributes];
//    [includeID setValue:_itsaMe.attributes[@"id"] forKey:@"id"];
//    personAttributes = [NSDictionary dictionaryWithDictionary:includeID];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Test Methods

- (void)testAtlasModelCreation {
    /*
     Assume that dictionary to be a set of camel-cased property / value pairs, as in {"userName": "flipsasser", "email": "flip.sasser@gmail.com", "likesToHaveFun": false}
     */

    NSDictionary *personAttributes = @{
                                       @"name":@"Jason",
                                       @"email":@"jason@inthebackforty.com",
                                       @"likesToHaveFun":[NSNumber numberWithBool:YES],
                                       };
    XCTAssertEqualObjects(personAttributes, _itsaMe.attributes);
    NSLog(@"\n\nATTRIBUTES: %@", _itsaMe.attributes);
}

- (void) testOverwriteAttributes {
    /*
     Setting attributes on an AtlasModel should overwrite the keys in the attributes dictionary with those from the passed-in version.
     It should not overwrite other keys, such that aModel.attributes = @{"name": "Flip", "password": "Secret"} followed by aModel.attributes = @{"name": "Jason"}
     Results in aModel.attributes #=> @{"name": "Jason", "password": "Secret"}
     */

    _itsaMe.attributes = @{@"email":@"jasonpwelch@yahoo.com"};
    NSLog(@"\n\nATTRIBUTES: %@", _itsaMe.attributes);

    XCTAssertEqualObjects(_itsaMe.attributes[@"email"], @"jasonpwelch@yahoo.com");
}

- (void) testSubclassPropertyCreation {
    /*
     Given a subclass of AtlasModel "Person" with properties "createdAt" (date) and "name" (string), setting aPerson.attributes = @{"createdAt": [NSDate date], "name": "Jason"} should set aPerson.name to "Jason" and aPerson.createdAt to the date.
     */
    NSDate *testDate = [NSDate date];
    _itsaMe.attributes = @{@"name":@"jason", @"createdAt":testDate};
    NSLog(@"\n\nATTRIBUTES: %@", _itsaMe.attributes);

    XCTAssertEqualObjects(_itsaMe.name, @"jason");
    XCTAssertEqualObjects(_itsaMe.createdAt, testDate);
}

- (void) testQuickInstantiation {
    /*
     An AtlasModel should be quickly instantiated with [AtlasModel withAttributes:(NSDictionary *)whatever]
     This should return an instance of AtlasModel with attributes set to the whatever dictionary.
     */
    NSDictionary *personAttributes = @{
                                       @"name":@"Flip",
                                       @"email":@"flip@inthebackforty.com",
                                       @"likesToHaveFun":[NSNumber numberWithBool:YES],
                                       };

    _anotherPerson = [Person withAttributes:personAttributes];
    _itsaMe.attributes = personAttributes;
    XCTAssertNotNil(_anotherPerson);
    XCTAssertEqualObjects(_anotherPerson.attributes[@"name"], _itsaMe.attributes[@"name"]);
}

- (void) testCoreDataSave {
    /*
     Calling [aModel save] should save the model to the local CoreData store
     */
    [_itsaMe save];

}
/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/
@end
