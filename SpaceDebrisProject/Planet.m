//
//  Planet.m
//  SpaceDebrisProject
//
//  Created by LeeSangchan on 2015. 6. 16..
//  Copyright (c) 2015년 LeeSangchan. All rights reserved.
//

#import "Planet.h"

@interface Planet () {
    SKSpriteNode *_planet;
    SKSpriteNode *_nextPlanet;
}

@end


@implementation Planet

static Planet *sharedMyPlanet = nil;
+ (instancetype)sharedInstanceWithPosition:(CGPoint)position Radius:(CGFloat)radius{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyPlanet = [[super alloc] initWithPosition:(CGPoint)position Radius:(CGFloat)radius];
    });
    return sharedMyPlanet;
}


-(instancetype)initWithPosition:(CGPoint)position Radius:(CGFloat)radius{
    self = [self init];
    if (!self) return nil;
    
    self.fixedRadius = radius;
    self.position = position;
    self.fixedPosition = position;
    
    _planet = [SKSpriteNode spriteNodeWithImageNamed:@"planet.png"];
    _planet.xScale = 0.45;
    _planet.yScale = 0.45;
    
    [self addChild:_planet];
    
    _nextPlanet = [SKSpriteNode spriteNodeWithImageNamed:@"planet_d1.png"];
    _nextPlanet.xScale = 0.45;
    _nextPlanet.yScale = 0.45;
    
    //SKShapeNode *planet = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    //[planet setFillColor:[UIColor blueColor]];
    
    [self addChild:_nextPlanet];
    
    [self resetDamege];
    
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

-(void)resetDamege {
    self.maxHealthPoint = 500.0;
    self.healthPoint = 500.0;
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
    _planet.alpha = self.healthPoint / self.maxHealthPoint;
    _nextPlanet.alpha = 1.0 - _planet.alpha;
}

-(void)getDamage:(CGFloat)damage {
    self.healthPoint -= damage;
    if (self.healthPoint <= 0.0) {
        // TODO : APOCALYPSE NOW !!!!!!
        NSLog(@"game over!");
    }
    NSLog(@"planet hp : %f",self.healthPoint);
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
