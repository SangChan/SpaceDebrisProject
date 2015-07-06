//
//  SpaceDebrisTests.m
//  SpaceDebrisProject
//
//  Created by SangChan on 2015. 7. 3..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Debris.h"
#import "Satellite.h"
#import "MyConst.h"
#import "Planet.h"

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

- (void)testMyConst {
    CGPoint testResultPoint = ccp(0.0,0.0);
    CGFloat testResultFloat = 0.0;
    CGPoint testPoint1 = ccp(100.0, 100.0);
    CGPoint testPoint2 = ccp(50.0, 50.0);
    XCTAssertEqual(testPoint1.x, 100.0);
    XCTAssertEqual(testPoint1.y, 100.0);

    testResultPoint = ccpSub(testPoint1, testPoint2);
    XCTAssertEqual(testResultPoint.x, 50.0);
    XCTAssertEqual(testResultPoint.y, 50.0);
    
    testResultPoint = ccpSub(testPoint2, testPoint1);
    XCTAssertEqual(testResultPoint.x, -50.0);
    XCTAssertEqual(testResultPoint.y, -50.0);
    
    testResultPoint = ccpMult(testPoint2, 2.0);
    XCTAssertEqual(testResultPoint.x, 100.0);
    XCTAssertEqual(testResultPoint.y, 100.0);
    
    testResultFloat = ccpDot(testPoint1, testPoint2);
    XCTAssertEqual(testResultFloat, 10000.0);
    
    testResultFloat = ccpLengthSQ(testPoint2);
    XCTAssertEqual(testResultFloat, 5000.0);
    
    testResultFloat = ccpLength(ccp(3.0, 4.0));
    XCTAssertEqual(testResultFloat,5.0);
    
    testResultFloat = ccpDistance(testPoint2, testPoint1);
    XCTAssertEqual((int)testResultFloat,70);
    
    // TODO : add test case for ccpNormalize
}

- (void)testPlanet {
    Planet *planet = [Planet sharedInstanceWithPosition:CGPointMake(0.0, 0.0) Radius:50.0];
    planet.name = @"onlyOnePlanet";
    Planet *testPlanet = [Planet sharedInstanceWithPosition:CGPointMake(5.0, 5.0) Radius:20.0];
    XCTAssertEqual(testPlanet.name, planet.name);
}

- (void)testMyConstRandomRaidian {
    for (int i = 0; i < 10000; i++) {
        float result = randomFromMinToMax(0, M_PI);
        NSLog(@"case#%d : %f",i,result);
    }
}

- (void)testDebris {
    float radian = randomFromMinToMax(0, M_PI);
    CGFloat radius =  sqrt(pow(1024 * 0.5, 2.0) + pow(768 * 0.5, 2.0));
    Debris *debris = [[Debris alloc]initWithPosition:CGPointMake(radius*cos(radian)+1024*0.5, radius*sin(radian)+768*0.5) Radian:radian];
    debris.active = YES;
    
    XCTAssertNotNil(debris);
}

@end
