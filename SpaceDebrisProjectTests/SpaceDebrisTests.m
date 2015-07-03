//
//  SpaceDebrisTests.m
//  SpaceDebrisProject
//
//  Created by SangChan on 2015. 7. 3..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Satellite.h"

@interface SpaceDebrisTests : XCTestCase

@end

@implementation SpaceDebrisTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSatellite {
    Satellite *satellite = [[Satellite alloc]initWithPosition:CGPointMake(0.0, 0.0)];
    satellite.battery = 100;
    satellite.beamLength = 100;
    satellite.energyDrain = 100;
    satellite.shoot = YES;
    
    XCTAssertNotNil(satellite);
    XCTAssertEqual(satellite.battery, 100);
    XCTAssertEqual(satellite.beamLength, 100);
    XCTAssertEqual(satellite.energyDrain, 100);
    XCTAssertTrue(satellite.shoot);
}

@end
