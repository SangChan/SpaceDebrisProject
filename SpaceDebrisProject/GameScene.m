//
//  GameScene.m
//  SpaceDebrisProject2
//
//  Created by SangChan on 2015. 6. 8..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
    SKShapeNode *planet;
    SKShapeNode *satellite;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.gravity =  CGVectorMake(0.0, 0.0);
    
    [self initPlanet];
    [self initSatellite];
    [self initDebris];
    
//    SKAction *action = [SKAction rotateByAngle:M_PI duration:10];
//    [planet runAction:[SKAction repeatActionForever:action]];
    planet.physicsBody.angularVelocity = 1.0;
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
    planet.physicsBody.angularVelocity = 1.0;
    
}

-(void)initPlanet {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    
    planet = [SKShapeNode shapeNodeWithCircleOfRadius:50.0];

    [planet setFillColor:[UIColor blueColor]];
    
    planet.position = CGPointMake(centerPos.x,centerPos.y);
    
    SKShapeNode *point = [SKShapeNode shapeNodeWithCircleOfRadius:5.0];
    [point setFillColor:[UIColor whiteColor]];
    point.position = CGPointMake(0,planet.frame.size.height/2 - 9.0);
    [planet addChild:point];
    
    planet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50.0];
    planet.physicsBody.dynamic = true;
    planet.physicsBody.density = 100;
    [self addChild:planet];
}

-(void)initSatellite {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    satellite = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(10.0,10.0)];
    
    satellite.position = CGPointMake(centerPos.x, centerPos.y - planet.frame.size.width/2 - 45);
    
    [satellite setFillColor:[UIColor redColor]];
    
    satellite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10.0, 10.0)];
    satellite.physicsBody.dynamic = true;
    satellite.physicsBody.density = 1;
    [self addChild:satellite];
    
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:planet.physicsBody bodyB:satellite.physicsBody anchorA:planet.frame.origin anchorB:satellite.frame.origin];
    [limitJoint setMaxLength:1.0];
    [self.physicsWorld addJoint:limitJoint];
    
    //[satellite.physicsBody applyForce:CGVectorMake(1.0, 1.0)];
    
    SKPhysicsJointPin *pinJoint = [SKPhysicsJointPin jointWithBodyA:planet.physicsBody bodyB:satellite.physicsBody anchor:satellite.frame.origin];

    [self.physicsWorld addJoint:pinJoint];
    
    
}

-(void)initDebris {
    
}

@end
