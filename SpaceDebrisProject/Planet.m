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
    
    self.maxHealthPoint = 100.0;
    self.healthPoint = 100.0;
    
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

-(void)getDamage:(CGFloat)damage {
    self.healthPoint -= damage;
    [self shake:5];
}

-(void)shake:(NSInteger)times {
    CGPoint initialPoint = self.position;
    NSInteger amplitudeX = 10;
    NSInteger amplitudeY = 10;
    NSMutableArray *randomActions = [NSMutableArray array];
    for (int i=0; i<times; i++) {
        NSInteger randX = (arc4random() % amplitudeX);
        NSInteger randY = (arc4random() % amplitudeY);
        SKAction *action = [SKAction moveByX:randX y:randY duration:0.01];
        [randomActions addObject:action];
    }
    
    SKAction *rep = [SKAction sequence:randomActions];
    
    [self runAction:rep completion:^{
        self.position = initialPoint;
    }];
}

@end
