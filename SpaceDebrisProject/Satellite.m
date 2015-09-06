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
    SKSpriteNode *_satellite100;
    SKSpriteNode *_satellite80;
    SKSpriteNode *_satellite60;
    SKSpriteNode *_satellite40;
    SKSpriteNode *_satellite20;
}

@end

@implementation Satellite


-(instancetype)initWithPosition:(CGPoint)position {
    self = [self init];
    if (!self) return nil;
    
    self.shoot = NO;
    self.battery = 100.0;
    self.energyDrain = 0.5;
    self.position = position;
    
    CGSize satelliteSize = CGSizeMake(10.0,10.0);
    
    _satellite100 = [SKSpriteNode spriteNodeWithImageNamed:@"satellite.png"];
    _satellite100.anchorPoint = CGPointMake(0.5, 0.5);
    _satellite100.xScale = 0.2;
    _satellite100.yScale = 0.2;
    
    [self addChild:_satellite100];
    
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
    //NSLog(@"satellite energy = %f",self.battery);
}

-(void)usePower {
    self.battery -= self.energyDrain;
    if(self.battery < 10.0)
        self.shoot = NO;
}
-(void)chargePower {
    self.battery += self.energyDrain * 2;
    if (self.battery > 100.0) {
        self.battery = 100.0;
    }
}


@end
