//
//  GameScene.m
//  SpaceDebrisProject2
//
//  Created by SangChan on 2015. 6. 8..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
    SKShapeNode *_planet;
    SKShapeNode *_satellite;
    SKShapeNode *_debris;
    CFTimeInterval _startTime;
    CFTimeInterval _currentTime;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity =  CGVectorMake(0.0, 0.0);
    _startTime = 0.0;
    [self initPlanet];
    [self initSatellite];
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *creatDebris = [SKAction performSelector:@selector(initDebris) onTarget:self];
    SKAction *perform = [SKAction repeatActionForever:[SKAction sequence:@[wait,creatDebris]]];
    [self runAction:perform];
    //[self initDebris];
    
    _planet.physicsBody.angularVelocity = 1.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    _planet.physicsBody.angularVelocity = 1.0;
    _planet.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
}

-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    
    _planet = [SKShapeNode shapeNodeWithCircleOfRadius:50.0];

    [_planet setFillColor:[UIColor blueColor]];
    
    _planet.position = CGPointMake(centerPos.x,centerPos.y);
    
    SKShapeNode *point = [SKShapeNode shapeNodeWithCircleOfRadius:5.0];
    [point setFillColor:[UIColor whiteColor]];
    point.position = CGPointMake(0,_planet.frame.size.height/2 - 9.0);
    [_planet addChild:point];
    
    _planet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50.0];
    _planet.physicsBody.dynamic = YES;
    _planet.physicsBody.density = 100;
    [self addChild:_planet];
}

-(void)initSatellite {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _satellite = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(10.0,10.0)];
    
    _satellite.position = CGPointMake(centerPos.x, centerPos.y - _planet.frame.size.width/2 - 45);
    
    [_satellite setFillColor:[UIColor redColor]];
    
    _satellite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10.0, 10.0)];
    _satellite.physicsBody.dynamic = YES;
    _satellite.physicsBody.density = 1;
    [self addChild:_satellite];
    
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:_planet.physicsBody bodyB:_satellite.physicsBody anchorA:_planet.frame.origin anchorB:_satellite.frame.origin];
    [limitJoint setMaxLength:1.0];
    [self.physicsWorld addJoint:limitJoint];
    
    SKPhysicsJointPin *pinJoint = [SKPhysicsJointPin jointWithBodyA:_planet.physicsBody bodyB:_satellite.physicsBody anchor:_satellite.frame.origin];

    [self.physicsWorld addJoint:pinJoint];
    
    
}

-(void)initDebris {
    //CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    int xFactor = arc4random_uniform(INT16_MAX) % 6;
    _debris = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(13.0, 7.0)];
    _debris.position = CGPointMake((self.size.width / 6) * xFactor,  self.size.height);
    [_debris setFillColor:[UIColor brownColor]];
    
    _debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_debris.frame.size];
    _debris.physicsBody.dynamic = YES;
    _debris.physicsBody.density = 1;
    [self addChild:_debris];
    NSLog(@"planet x= %f, y= %f. debris x= %f, y =%f", _planet.position.x, _planet.position.y, _debris.position.x, _debris.position.y);
    
    CGVector throwVector = CGVectorMake(_planet.position.x - _debris.position.x, _planet.position.y - _debris.position.y);
    NSLog(@"vector = %f,%f", throwVector.dx, throwVector.dy);
    [_debris.physicsBody applyForce:throwVector];
    
}

@end
