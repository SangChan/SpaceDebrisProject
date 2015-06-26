//
//  Satellite.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Satellite.h"
#import "MyConst.h"

@interface Satellite () {
}

@end

@implementation Satellite


-(instancetype)initWithPosition:(CGPoint)position {
    self = [self init];
    if (!self) return nil;
    
    self.shoot = NO;
    self.battery = 100.0;
    self.energyDrain = 1.0;
    self.position = position;
    
    CGSize satelliteSize = CGSizeMake(10.0,10.0);
    
    SKSpriteNode *satellite = [[SKSpriteNode alloc]initWithColor:[UIColor redColor] size:satelliteSize];
    satellite.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self addChild:satellite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:satelliteSize];
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 1;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = SATELLITE;
    self.physicsBody.collisionBitMask = PLANET | DEBRIS;
    self.physicsBody.contactTestBitMask = PLANET | DEBRIS;
    
    return self;
    
}

-(void)update {
    /*CGPoint satelliteStart = CGPointMake(0,0);
    for (int i = 0; i < 90; i++) {
        float angle = self.zRotation + SK_DEGREES_TO_RADIANS(-45.0f-i);
        CGPoint satelliteEnd = CGPointMake(self.beamLength*cos(angle)+satelliteStart.x, self.beamLength*sin(angle)+satelliteStart.y);
        
        SKShapeNode *line = [SKShapeNode node];
        [line setStrokeColor:[UIColor cyanColor]];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, satelliteStart.x,satelliteStart.y);
        CGPathAddLineToPoint(pathToDraw, NULL, satelliteEnd.x, satelliteEnd.y);
        [self addChild:line];
    }*/
}

@end
