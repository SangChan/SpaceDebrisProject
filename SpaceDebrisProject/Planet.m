//
//  Planet.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Planet.h"

@implementation Planet

-(instancetype)initWithPosition:(CGPoint)position Radius:(CGFloat)radius{
    self = [self init];
    if (!self) return nil;
    
    SKShapeNode *planet = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    self.fixedRadius = radius;
    [planet setFillColor:[UIColor blueColor]];
    self.position = position;
    self.fixedPosition = position;
    [self addChild:planet];
    
    [self addAnchorPoint];
    
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 100;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = PLANET;
    self.physicsBody.collisionBitMask = DEBRIS;
    self.physicsBody.contactTestBitMask = DEBRIS;

    return self;
}

-(void)addAnchorPoint {
    SKShapeNode *point = [SKShapeNode shapeNodeWithCircleOfRadius:5.0];
    [point setFillColor:[UIColor whiteColor]];
    point.position = CGPointMake(0,self.fixedRadius - 9.0);
    [self addChild:point];
}

-(void)update {
    self.physicsBody.angularVelocity = 1.0;
    self.position = self.fixedPosition;
    //self.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
}

@end
