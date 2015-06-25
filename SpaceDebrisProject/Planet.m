//
//  Planet.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Planet.h"

@implementation Planet

-(instancetype)initWithPosition:(CGPoint)position {
    self = [super init];
    if (!self) return nil;
    
    
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50.0];
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 100;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = PLANET;
    self.physicsBody.collisionBitMask = DEBRIS;
    self.physicsBody.contactTestBitMask = DEBRIS;
    return self;
}

-(void)update {
    self.physicsBody.angularVelocity = 1.0;
    self.position = self.fixedPosition;
    //self.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
}

@end
