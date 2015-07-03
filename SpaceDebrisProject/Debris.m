//
//  Debris.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Debris.h"
#import "MyConst.h"

@implementation Debris

-(instancetype)initWithPosition:(CGPoint)position Radian:(CGFloat)radian{
    self = [self init];
    if (!self) return nil;
    
    self.position = position;
    
    CGSize debrisSize = CGSizeMake(10.0 + (arc4random() % 10), 10.0 + (arc4random()%10));
    
    self.attackPoint = (debrisSize.width * debrisSize.height)/10;
    self.radian = radian;
    
    SKSpriteNode *debris = [[SKSpriteNode alloc]initWithColor:[UIColor brownColor] size:debrisSize];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debrisSize];
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 1;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = DEBRIS;
    self.physicsBody.collisionBitMask = PLANET | SATELLITE | DEBRIS;
    self.physicsBody.contactTestBitMask = PLANET | SATELLITE | DEBRIS;
    
    [self addChild:debris];
 
    return self;
}

-(void)update {
    
}

-(void)boom_boom_kaboom {
    self.physicsBody = nil;
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    emitterNode.position = CGPointMake(0.0, 0.0);
    emitterNode.zRotation = self.radian+SK_DEGREES_TO_RADIANS(-90.0f);
    [self addChild:emitterNode];
    
    SKAction *wait = [SKAction waitForDuration:0.15];
    SKAction *destruction = [SKAction runBlock:^{
        [self removeFromParent];
    }];
    SKAction *changeAlpha = [SKAction runBlock:^{
        self.alpha = 0.5;
    }];
    [self runAction:[SKAction sequence:@[wait,changeAlpha,wait,destruction]]];
}
-(void)becomeGold {
    self.active = NO;
    self.physicsBody.resting = YES;
    self.physicsBody.angularVelocity = 0.0;
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.physicsBody.usesPreciseCollisionDetection = NO;
    self.physicsBody.categoryBitMask = GOLD;
    self.physicsBody.collisionBitMask = NO_ONE;
    self.physicsBody.contactTestBitMask = NO_ONE;
}

@end
