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


@interface BasicTests : XCTestCase {
    // Add instance variables for testing
@private
    Person *itsaMe;
    Person *newPerson;
}
@end

@implementation BasicTests

#pragma mark - Setup and Teardown

- (void)setUp {
    [super setUp];

    itsaMe = [Person new];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Test Methods

- (void)testAtlasModelCreation {
    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");


    NSDictionary *personAttributes = @{
                                       @"name":@"Jason",
                                       @"email":@"jason@inthebackforty.com",
                                       @"likesToHaveFun":[NSNumber numberWithBool:YES],
                                       };

    itsaMe.attributes = personAttributes;
    NSLog(@"\n\nATTRIBUTES: %@", itsaMe.attributes);

    XCTAssertEqualObjects(personAttributes, itsaMe.attributes);
}

- (void) testOverwriteAttributes {
    itsaMe.attributes = @{@"email":@"jasonpwelch@yahoo.com"};
    NSLog(@"\n\nATTRIBUTES: %@", itsaMe.attributes);

    XCTAssertEqualObjects(itsaMe.attributes[@"email"], @"jasonpwelch@yahoo.com");
}

- (void) testSubclassPropertyCreation {
    NSDate *testDate = [NSDate date];
    itsaMe.attributes = @{@"name":@"jason", @"createdAt":testDate};
    NSLog(@"\n\nATTRIBUTES: %@", itsaMe.attributes);

    XCTAssertEqualObjects(itsaMe.name, @"jason");
    XCTAssertEqualObjects(itsaMe.createdAt, testDate);
}

- (void) testQuickInstantiation {
    NSDictionary *personAttributes = @{
                                       @"name":@"Flip",
                                       @"email":@"flip@inthebackforty.com",
                                       @"likesToHaveFun":[NSNumber numberWithBool:YES],
                                       };

    newPerson = [Person withAttributes:personAttributes];
    itsaMe.attributes = personAttributes;
    XCTAssertNotNil(newPerson);
    XCTAssertEqualObjects(newPerson.attributes[@"name"], itsaMe.attributes[@"name"]);
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
