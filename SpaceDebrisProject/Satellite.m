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
    
}

@end
